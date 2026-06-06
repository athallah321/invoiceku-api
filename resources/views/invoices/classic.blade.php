<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    @page { margin: 20px; }
    body { font-family: Georgia, serif; font-size: 13px; color: #333; padding: 40px; background: #fff; }
    .invoice-box { max-width: 800px; margin: 0 auto; }
    .header { border-bottom: 3px solid #0d9488; padding-bottom: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: flex-start; }
    .header-left { display: flex; align-items: center; gap: 15px; }
    .header-right { display: flex; flex-direction: column; align-items: flex-end; gap: 10px; }
    .brand-logo { max-width: 100px; max-height: 80px; }
    .brand-name { font-size: 24px; font-weight: bold; color: #0d9488; font-family: Arial, sans-serif; }
    .invoice-title { font-size: 32px; color: #0d9488; font-weight: bold; }
    .invoice-meta { color: #666; font-size: 12px; text-align: right; }
    .invoice-meta p { margin-bottom: 3px; }
    .section-label { font-size: 11px; text-transform: uppercase; color: #0d9488; font-weight: bold; margin-bottom: 8px; letter-spacing: 1px; font-family: Arial, sans-serif; }
    .client-info { margin-bottom: 30px; }
    .client-info p { margin-bottom: 2px; color: #444; }
    .client-info .name { font-weight: bold; font-size: 14px; color: #111; }
    table { width: 100%; border-collapse: collapse; margin-bottom: 30px; font-family: Arial, sans-serif; }
    thead tr { background: #0d9488; color: white; }
    th { padding: 12px 10px; text-align: left; font-size: 11px; text-transform: uppercase; font-weight: normal; }
    th:last-child, td:last-child { text-align: right; }
    th:nth-child(2), td:nth-child(2) { text-align: center; }
    td { padding: 12px 10px; border-bottom: 1px solid #e5e5e5; color: #444; }
    .summary { float: right; width: 240px; margin-top: 20px; }
    .summary-row { display: flex; justify-content: space-between; padding: 8px 0; color: #666; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
    .summary-row:last-child { border-bottom: none; }
    .summary-row.total { border-top: 2px solid #0d9488; border-bottom: none; margin-top: 8px; padding-top: 12px; font-weight: bold; font-size: 16px; color: #0d9488; }
    .notes { margin-top: 60px; padding: 20px; background: #f5f5f5; border-left: 4px solid #0d9488; }
    .notes p { color: #666; font-size: 12px; }
    .status-badge { display: inline-block; padding: 4px 12px; border-radius: 4px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
    .status-draft { background: #f5f5f5; color: #666; }
    .status-sent { background: #d1fae5; color: #065f46; }
    .status-paid { background: #0d9488; color: white; }
    .status-overdue { background: #fee2e2; color: #991b1b; }
    .footer { margin-top: 40px; text-align: center; color: #999; font-size: 11px; padding-top: 20px; border-top: 1px solid #eee; }
  </style>
</head>
<body>
  <div class="invoice-box">
    <div class="header">
      <div class="header-left">
        @if($logoUrl)
          <img src="{{ $logoUrl }}" alt="Logo" class="brand-logo">
        @endif
        <div class="brand-name">{{ $businessName }}</div>
      </div>
      <div class="header-right">
        <div class="invoice-title">INVOICE</div>
        <div class="invoice-meta">
          <p style="font-weight:bold;color:#333">{{ $invoice->invoice_number }}</p>
          <p>{{ $lang['date'] }}: {{ $invoice->issue_date }}</p>
          <p>{{ $lang['due_date'] }}: {{ $invoice->due_date }}</p>
          <span class="status-badge status-{{ $invoice->status }}">{{ $invoice->status }}</span>
        </div>
      </div>
    </div>

    <div class="client-info">
      <div class="section-label">{{ $lang['bill_to'] }}</div>
      <p class="name">{{ $invoice->client->name }}</p>
      @if($invoice->client->company)
        <p>{{ $invoice->client->company }}</p>
      @endif
      @if($invoice->client->email)
        <p>{{ $invoice->client->email }}</p>
      @endif
      @if($invoice->client->phone)
        <p>{{ $invoice->client->phone }}</p>
      @endif
      @if($invoice->client->address)
        <p>{{ $invoice->client->address }}</p>
      @endif
    </div>

    <table>
      <thead>
        <tr>
          <th>{{ $lang['description'] }}</th>
          <th>{{ $lang['qty'] }}</th>
          <th>{{ $lang['price'] }}</th>
          <th>{{ $lang['amount'] }}</th>
        </tr>
      </thead>
      <tbody>
        @foreach($invoice->items as $item)
        <tr>
          <td>{{ $item->description }}</td>
          <td style="text-align:center">{{ $item->quantity }}</td>
          <td style="text-align:right">{{ $symbol }} {{ number_format($item->price, $currency == 'IDR' ? 0 : 2, ',', '.') }}</td>
          <td style="text-align:right">{{ $symbol }} {{ number_format($item->total, $currency == 'IDR' ? 0 : 2, ',', '.') }}</td>
        </tr>
        @endforeach
      </tbody>
    </table>

    <div class="summary">
      <div class="summary-row">
        <span>{{ $lang['subtotal'] }}</span>
        <span>{{ $symbol }} {{ number_format($invoice->subtotal, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
      <div class="summary-row">
        <span>{{ $lang['tax'] }}</span>
        <span>{{ $symbol }} {{ number_format($invoice->tax, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
      @if($invoice->discount > 0)
      <div class="summary-row">
        <span>{{ $lang['discount'] }}</span>
        <span>- {{ $symbol }} {{ number_format($invoice->discount, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
      @endif
      <div class="summary-row total">
        <span>{{ $lang['total'] }}</span>
        <span>{{ $symbol }} {{ number_format($invoice->total, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
    </div>

    @if($invoice->notes)
    <div class="notes">
      <div class="section-label">{{ $lang['notes'] }}</div>
      <p>{{ $invoice->notes }}</p>
    </div>
    @endif

    <div class="footer">
      <p>Thank you for your business.</p>
    </div>
  </div>
</body>
</html>