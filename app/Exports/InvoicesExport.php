<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

class InvoicesExport implements FromCollection, WithHeadings, WithMapping
{
    protected $userId;
    protected $dateFrom;
    protected $dateTo;

    public function __construct($userId = null)
    {
        $this->userId = $userId;
    }

    public function setDateFrom($date)
    {
        $this->dateFrom = $date;
    }

    public function setDateTo($date)
    {
        $this->dateTo = $date;
    }

    public function collection()
    {
        $query = Invoice::with(['client'])->orderBy('created_at', 'desc');

        if ($this->userId) {
            $query->where('user_id', $this->userId);
        }

        if ($this->dateFrom) {
            $query->where('issue_date', '>=', $this->dateFrom);
        }

        if ($this->dateTo) {
            $query->where('issue_date', '<=', $this->dateTo);
        }

        return $query->get();
    }

    public function headings(): array
    {
        return [
            'No Invoice',
            'Klien',
            'Tanggal',
            'Jatuh Tempo',
            'Subtotal',
            'Pajak',
            'Diskon',
            'Total',
            'Status',
        ];
    }

    public function map($invoice): array
    {
        return [
            $invoice->invoice_number,
            $invoice->client->name ?? '-',
            $invoice->issue_date,
            $invoice->due_date,
            $invoice->subtotal,
            $invoice->tax,
            $invoice->discount,
            $invoice->total,
            ucfirst($invoice->status),
        ];
    }

    public function columnFormats(): array
    {
        return [
            'E' => '#,##0',
            'F' => '#,##0',
            'G' => '#,##0',
            'H' => '#,##0',
        ];
    }
}