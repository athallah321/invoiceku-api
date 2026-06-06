<?php

namespace App\Http\Controllers;

use App\Models\Setting;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function show(Request $request)
    {
        $userId = $request->user()->id;

        // Debug: log user ID
        \Log::info('Settings show - User ID: ' . $userId);

        $settings = Setting::getSettings($userId);

        // Debug: log settings
        \Log::info('Settings show - All settings: ' . json_encode($settings));

        return response()->json([
            'business' => [
                'name' => $settings['business_name'] ?? '',
                'address' => $settings['business_address'] ?? '',
                'phone' => $settings['business_phone'] ?? '',
                'email' => $settings['business_email'] ?? '',
                'logo_url' => $settings['business_logo_url'] ?? '',
            ],
            'invoice' => [
                'prefix' => $settings['invoice_prefix'] ?? 'INV',
                'starting_number' => (int) ($settings['invoice_starting_number'] ?? 1),
                'currency' => $settings['invoice_currency'] ?? 'IDR',
                'invoice_logo_url' => $settings['invoice_invoice_logo_url'] ?? '',
                'template' => $settings['invoice_template'] ?? 'modern',
                'logo_position' => $settings['invoice_logo_position'] ?? 'left',
            ],
        ]);
    }

    public function store(Request $request)
    {
        $userId = $request->user()->id;

        // Debug: log what we're saving
        \Log::info('Settings store - User ID: ' . $userId);
        \Log::info('Settings store - Data: ' . json_encode($request->all()));

        $data = $request->all();

        // Save business settings
        if (isset($data['business'])) {
            foreach ($data['business'] as $key => $value) {
                Setting::saveSetting($userId, 'business_' . $key, $value);
            }
        }

        // Save invoice settings
        if (isset($data['invoice'])) {
            foreach ($data['invoice'] as $key => $value) {
                Setting::saveSetting($userId, 'invoice_' . $key, $value);
                \Log::info('Saved invoice_' . $key . ' = ' . $value);
            }
        }

        return response()->json(['message' => 'Settings saved']);
    }
}