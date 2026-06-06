<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    @page { margin: 20px; }
    body { font-family: Arial, sans-serif; font-size: 13px; color: #333; padding: 40px; background: #fff; }
    .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; }
    .header-left { display: flex; align-items: center; gap: 15px; }
    .header-right { display: flex; flex-direction: column; align-items: flex-end; gap: 15px; }
    .brand-logo { max-width: 100px; max-height: 80px; }
    .brand-name { font-size: 22px; font-weight: bold; color: #2563eb; }
    .invoice-meta { color: #666; font-size: 12px; text-align: right; }
    .invoice-meta p { margin-bottom: 4px; }
    .invoice-title { font-size: 28px; font-weight: bold; color: #2563eb; }
    .section-label { font-size: 10px; text-transform: uppercase; color: #999; font-weight: bold; margin-bottom: 6px; letter-spacing: 1px; }
    .client-info { margin-bottom: 40px; }
    .client-info p { margin-bottom: 3px; color: #555; }
    .client-info .name { font-weight: bold; font-size: 15px; color: #111; }
    table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    thead tr { background: #f1f5f9; }
    th { padding: 10px 12px; text-align: left; font-size: 11px; text-transform: uppercase; color: #666; }
    th:last-child, td:last-child { text-align: right; }
    th:nth-child(2), td:nth-child(2) { text-align: center; }
    td { padding: 12px; border-bottom: 1px solid #f1f5f9; color: #444; }
    .summary { float: right; width: 260px; }
    .summary-row { display: flex; justify-content: space-between; padding: 6px 0; color: #666; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
    .summary-row:last-child { border-bottom: none; }
    .summary-row.total { border-top: 2px solid #e5e7eb; margin-top: 6px; padding-top: 10px; font-weight: bold; font-size: 15px; color: #111; }
    .notes { margin-top: 60px; padding-top: 20px; border-top: 1px solid #e5e7eb; }
    .notes p { color: #666; margin-top: 6px; }
    .status-badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: bold; }
    .status-draft { background: #f1f5f9; color: #64748b; }
    .status-sent { background: #dbeafe; color: #1d4ed8; }
    .status-paid { background: #dcfce7; color: #16a34a; }
    .status-overdue { background: #fee2e2; color: #dc2626; }
    .footer { margin-top: 60px; text-align: center; color: #999; font-size: 11px; }
  </style>
</head>
<body>

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
        <p style="font-size:18px;font-weight:bold;color:#111">{{ $invoice->invoice_number }}</p>
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
    <p>This document was automatically generated by INVOICEKU</p>
  </div>

</body>
</html>