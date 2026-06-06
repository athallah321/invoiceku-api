<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    @page { margin: 20px; }
    body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; color: #1a1a1a; padding: 50px; background: #fff; }
    .invoice-wrap { max-width: 700px; margin: 0 auto; }
    .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 50px; }
    .header-left { display: flex; align-items: center; gap: 20px; }
    .header-right { text-align: right; }
    .brand-logo { max-width: 100px; max-height: 80px; }
    .brand-name { font-size: 18px; font-weight: 600; color: #1a1a1a; }
    .invoice-title { font-size: 36px; font-weight: 300; color: #1a1a1a; letter-spacing: -1px; }
    .invoice-number { font-size: 12px; color: #666; margin-top: 5px; }
    .invoice-date { font-size: 12px; color: #888; margin-top: 2px; }
    .section-label { font-size: 10px; text-transform: uppercase; color: #999; letter-spacing: 1px; margin-bottom: 10px; }
    .client-info { margin-bottom: 50px; }
    .client-info p { margin-bottom: 2px; font-size: 13px; }
    .client-name { font-size: 15px; font-weight: 500; color: #1a1a1a; }
    table { width: 100%; border-collapse: collapse; margin-bottom: 40px; }
    th { text-align: left; padding: 0 0 15px 0; font-size: 10px; text-transform: uppercase; color: #999; letter-spacing: 1px; border-bottom: 1px solid #e5e5e5; }
    th:last-child { text-align: right; }
    td { padding: 15px 0; font-size: 13px; border-bottom: 1px solid #f0f0f0; vertical-align: top; }
    td:last-child { text-align: right; }
    td:nth-child(2) { text-align: center; width: 60px; }
    .amount { font-variant-numeric: tabular-nums; }
    .item-note { color: #999; font-size: 11px; margin-top: 3px; }
    .totals { margin-left: auto; width: 250px; }
    .total-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
    .total-row:last-child { border-bottom: none; border-top: 2px solid #1a1a1a; margin-top: 5px; padding-top: 15px; font-size: 16px; font-weight: 600; }
    .total-label { color: #666; }
    .total-value { color: #1a1a1a; }
    .notes { margin-top: 50px; padding-top: 30px; border-top: 1px solid #eee; }
    .notes p { font-size: 12px; color: #666; line-height: 1.6; }
    .footer { margin-top: 60px; text-align: center; color: #ccc; font-size: 11px; }
  </style>
</head>
<body>
  <div class="invoice-wrap">
    <div class="header">
      <div class="header-left">
        @if($logoUrl)
          <img src="{{ $logoUrl }}" alt="Logo" class="brand-logo">
        @endif
        <div class="brand-name">{{ $businessName }}</div>
      </div>
      <div class="header-right">
        <div class="invoice-title">Invoice</div>
        <div class="invoice-number">{{ $invoice->invoice_number }}</div>
        <div class="invoice-date">{{ $invoice->issue_date }} &middot; {{ $lang['due_date'] }} {{ $invoice->due_date }}</div>
      </div>
    </div>

    <div class="client-info">
      <div class="section-label">{{ $lang['bill_to'] }}</div>
      <p class="client-name">{{ $invoice->client->name }}</p>
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
          <th></th>
          <th>{{ $lang['amount'] }}</th>
        </tr>
      </thead>
      <tbody>
        @foreach($invoice->items as $item)
        <tr>
          <td>
            {{ $item->description }}
            <div class="item-note">{{ $item->quantity }} x {{ $symbol }}{{ number_format($item->price, $currency == 'IDR' ? 0 : 2, ',', '.') }}</div>
          </td>
          <td></td>
          <td class="amount">{{ $symbol }}{{ number_format($item->total, $currency == 'IDR' ? 0 : 2, ',', '.') }}</td>
        </tr>
        @endforeach
      </tbody>
    </table>

    <div class="totals">
      <div class="total-row">
        <span class="total-label">{{ $lang['subtotal'] }}</span>
        <span class="total-value">{{ $symbol }}{{ number_format($invoice->subtotal, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
      <div class="total-row">
        <span class="total-label">{{ $lang['tax'] }}</span>
        <span class="total-value">{{ $symbol }}{{ number_format($invoice->tax, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
      @if($invoice->discount > 0)
      <div class="total-row">
        <span class="total-label">{{ $lang['discount'] }}</span>
        <span class="total-value">- {{ $symbol }}{{ number_format($invoice->discount, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
      </div>
      @endif
      <div class="total-row">
        <span class="total-label">{{ $lang['total'] }}</span>
        <span class="total-value">{{ $symbol }}{{ number_format($invoice->total, $currency == 'IDR' ? 0 : 2, ',', '.') }}</span>
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