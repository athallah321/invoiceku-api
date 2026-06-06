<?php

namespace App\Http\Controllers;

use App\Models\Invoice;
use App\Models\InvoiceItem;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Exports\InvoicesExport;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use App\Mail\InvoiceMail;
use Maatwebsite\Excel\Facades\Excel;

class InvoiceController extends Controller
{
    public function index(Request $request)
    {
        $invoices = Invoice::where('user_id', $request->user()->id)
            ->with('client', 'items')
            ->latest()
            ->get();

        return response()->json($invoices);
    }

    public function store(Request $request)
    {
        $request->validate([
            'client_id'  => 'required|exists:clients,id',
            'issue_date' => 'required|date',
            'due_date'   => 'required|date|after_or_equal:issue_date',
            'items'      => 'required|array|min:1',
            'items.*.description' => 'required|string',
            'items.*.quantity'    => 'required|integer|min:1',
            'items.*.price'       => 'required|numeric|min:0',
            'notes'      => 'nullable|string',
            'tax'        => 'nullable|numeric|min:0',
            'discount'   => 'nullable|numeric|min:0',
        ]);

        $subtotal = collect($request->items)->sum(fn($item) =>
            $item['quantity'] * $item['price']
        );

        $tax      = $request->tax ?? 0;
        $discount = $request->discount ?? 0;
        $total    = $subtotal + $tax - $discount;

        // Get settings for invoice number
        $settings = Setting::getSettings($request->user()->id);
        $prefix = $settings['invoice_prefix'] ?? 'INV';
        $startingNumber = (int) ($settings['invoice_starting_number'] ?? 1);

        // Get existing invoice count to generate next number
        $existingCount = Invoice::where('user_id', $request->user()->id)->count();
        $nextNumber = $startingNumber + $existingCount;

        // Format invoice number: PREFIX + padded number
        // Example: "INV/" + "0001" = "INV/0001"
        // Example: "INV-" + "0001" = "INV-0001"
        // Example: "INVOICE/" + "0001" = "INVOICE/0001"
        $invoiceNumber = $prefix . str_pad($nextNumber, 4, '0', STR_PAD_LEFT);

        $invoice = Invoice::create([
            'user_id'        => $request->user()->id,
            'client_id'      => $request->client_id,
            'invoice_number' => $invoiceNumber,
            'status'         => 'draft',
            'issue_date'     => $request->issue_date,
            'due_date'       => $request->due_date,
            'subtotal'       => $subtotal,
            'tax'            => $tax,
            'discount'       => $discount,
            'total'          => $total,
            'notes'          => $request->notes,
        ]);

        foreach ($request->items as $item) {
            InvoiceItem::create([
                'invoice_id'  => $invoice->id,
                'description' => $item['description'],
                'quantity'    => $item['quantity'],
                'price'       => $item['price'],
                'total'       => $item['quantity'] * $item['price'],
            ]);
        }

        return response()->json($invoice->load('client', 'items'), 201);
    }

    public function show(Request $request, Invoice $invoice)
    {
        if ($invoice->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($invoice->load('client', 'items'));
    }

    public function update(Request $request, Invoice $invoice)
    {
        if ($invoice->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $request->validate([
            'client_id'  => 'required|exists:clients,id',
            'issue_date' => 'required|date',
            'due_date'   => 'required|date|after_or_equal:issue_date',
            'items'      => 'required|array|min:1',
            'items.*.description' => 'required|string',
            'items.*.quantity'    => 'required|integer|min:1',
            'items.*.price'       => 'required|numeric|min:0',
            'notes'      => 'nullable|string',
            'tax'        => 'nullable|numeric|min:0',
            'discount'   => 'nullable|numeric|min:0',
        ]);

        // Update invoice basic info
        $invoice->update($request->only(
            'client_id', 'issue_date', 'due_date', 'notes', 'tax', 'discount'
        ));

        // Recalculate totals
        $subtotal = collect($request->items)->sum(fn($item) =>
            $item['quantity'] * $item['price']
        );
        $tax      = $request->tax ?? 0;
        $discount = $request->discount ?? 0;
        $total    = $subtotal + $tax - $discount;

        $invoice->update([
            'subtotal' => $subtotal,
            'total'    => $total,
        ]);

        // Delete existing items and recreate
        $invoice->items()->delete();
        foreach ($request->items as $item) {
            InvoiceItem::create([
                'invoice_id'  => $invoice->id,
                'description' => $item['description'],
                'quantity'    => $item['quantity'],
                'price'       => $item['price'],
                'total'       => $item['quantity'] * $item['price'],
            ]);
        }

        return response()->json($invoice->load('client', 'items'));
    }

    public function updateStatus(Request $request, Invoice $invoice)
    {
        if ($invoice->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $request->validate([
            'status' => 'required|in:draft,sent,paid,overdue',
        ]);

        $invoice->update(['status' => $request->status]);

        return response()->json($invoice);
    }

    public function destroy(Request $request, Invoice $invoice)
    {
        if ($invoice->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $invoice->delete();

        return response()->json(['message' => 'Invoice deleted']);
    }

    public function downloadPdf(Request $request, Invoice $invoice)
    {
        // Coba auth dari query string token
        if ($request->query('token')) {
            $token = $request->query('token');
            $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);
            if ($accessToken) {
                Auth::login($accessToken->tokenable);
            }
        }

        if ($invoice->user_id !== Auth::id()) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $invoice->load('client', 'items', 'user');

        // Get settings - gunakan $invoice->user_id untuk pastikan benar
        $settings = Setting::getSettings($invoice->user_id);

        $currency = $settings['invoice_currency'] ?? 'IDR';
        $logoUrl = $settings['invoice_invoice_logo_url'] ?? '';
        $businessName = $settings['business_name'] ?? 'Invoiceku';
        $template = $settings['invoice_template'] ?? 'modern';
        $logo_position = $settings['invoice_logo_position'] ?? 'left';
        $invoice_language = $settings['invoice_invoice_language'] ?? 'id';

        // Language labels
        $lang = $invoice_language === 'en' ? [
            'bill_to' => 'Bill To',
            'description' => 'Description',
            'qty' => 'Qty',
            'price' => 'Price',
            'amount' => 'Amount',
            'subtotal' => 'Subtotal',
            'tax' => 'Tax',
            'discount' => 'Discount',
            'total' => 'Total',
            'notes' => 'Notes',
            'date' => 'Date',
            'due_date' => 'Due Date',
        ] : [
            'bill_to' => 'Ditagihkan Kepada',
            'description' => 'Deskripsi',
            'qty' => 'Qty',
            'price' => 'Harga',
            'amount' => 'Total',
            'subtotal' => 'Subtotal',
            'tax' => 'Pajak',
            'discount' => 'Diskon',
            'total' => 'Total',
            'notes' => 'Catatan',
            'date' => 'Tanggal',
            'due_date' => 'Jatuh Tempo',
        ];

        // Convert URL to local path for DomPDF
        if ($logoUrl && strpos($logoUrl, 'localhost') !== false) {
            $path = str_replace('http://localhost:8000/storage/', '', $logoUrl);
            $logoPath = storage_path('app/public/' . $path);
            if (file_exists($logoPath)) {
                $logoUrl = $logoPath;
            }
        }

        // Currency symbols
        $currencySymbols = [
            'IDR' => 'Rp',
            'USD' => '$',
            'EUR' => '€',
            'GBP' => '£',
            'SGD' => 'S$',
        ];
        $symbol = $currencySymbols[$currency] ?? 'Rp';

        $pdf = Pdf::loadView('invoices.' . $template, compact('invoice', 'currency', 'symbol', 'logoUrl', 'businessName', 'logo_position', 'lang'));

        // Sanitize filename - replace "/" with "_"
        $safeFilename = str_replace(['/', '\\', ':', '*', '?', '"', '<', '>', '|'], '_', $invoice->invoice_number);

        return $pdf->download("invoice-{$safeFilename}.pdf");
    }

public function sendEmail(Request $request, $id)
    {
        $invoice = Invoice::with(['client', 'items'])->findOrFail($id);

        // Pastikan client ada
        if (!$invoice->client || !$invoice->client->email) {
            return response()->json(['message' => 'Email klien tidak tersedia'], 422);
        }

        // Get settings
        $settings = Setting::getSettings($invoice->user_id);
        $currency = $settings['invoice_currency'] ?? 'IDR';
        $logoUrl = $settings['invoice_invoice_logo_url'] ?? '';
        $businessName = $settings['business_name'] ?? 'Invoiceku';
        $template = $settings['invoice_template'] ?? 'modern';
        $logo_position = $settings['invoice_logo_position'] ?? 'left';
        $invoice_language = $settings['invoice_invoice_language'] ?? 'id';

        // Language labels
        $lang = $invoice_language === 'en' ? [
            'bill_to' => 'Bill To',
            'description' => 'Description',
            'qty' => 'Qty',
            'price' => 'Price',
            'amount' => 'Amount',
            'subtotal' => 'Subtotal',
            'tax' => 'Tax',
            'discount' => 'Discount',
            'total' => 'Total',
            'notes' => 'Notes',
            'date' => 'Date',
            'due_date' => 'Due Date',
        ] : [
            'bill_to' => 'Ditagihkan Kepada',
            'description' => 'Deskripsi',
            'qty' => 'Qty',
            'price' => 'Harga',
            'amount' => 'Total',
            'subtotal' => 'Subtotal',
            'tax' => 'Pajak',
            'discount' => 'Diskon',
            'total' => 'Total',
            'notes' => 'Catatan',
            'date' => 'Tanggal',
            'due_date' => 'Jatuh Tempo',
        ];

        // Convert URL to local path for DomPDF
        if ($logoUrl && strpos($logoUrl, 'localhost') !== false) {
            $path = str_replace('http://localhost:8000/storage/', '', $logoUrl);
            $logoPath = storage_path('app/public/' . $path);
            if (file_exists($logoPath)) {
                $logoUrl = $logoPath;
            }
        }

        // Currency symbols
        $currencySymbols = [
            'IDR' => 'Rp',
            'USD' => '$',
            'EUR' => '€',
            'GBP' => '£',
            'SGD' => 'S$',
        ];
        $symbol = $currencySymbols[$currency] ?? 'Rp';

        // Validate template exists
        $templatePath = resource_path('views/invoices/' . $template . '.blade.php');
        if (!file_exists($templatePath)) {
            \Log::error('PDF Template not found: ' . $templatePath . ' (template: ' . $template . ')');
            $template = 'modern'; // fallback to default
        }

        $pdf = Pdf::loadView('invoices.' . $template, compact('invoice', 'currency', 'symbol', 'logoUrl', 'businessName', 'logo_position', 'lang'));

        Mail::to($invoice->client->email)->send(new InvoiceMail($invoice, $pdf->output()));

        return response()->json(['message' => 'Invoice berhasil dikirim']);
    }

    public function exportExcel(Request $request)
    {
        $export = new InvoicesExport(Auth::id());

        if ($request->date_from) {
            $export->setDateFrom($request->date_from);
        }
        if ($request->date_to) {
            $export->setDateTo($request->date_to);
        }

        return Excel::download($export, 'invoices.xlsx');
    }

}
