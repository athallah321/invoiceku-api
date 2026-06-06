<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Invoice {{ $invoice->invoice_number }}</title>
</head>
<body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">

    <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #2563eb;">INVOICE</h1>
        <p style="color: #6b7280;">{{ $invoice->invoice_number }}</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p><strong>Date:</strong> {{ $invoice->issue_date }}</p>
        <p><strong>Due Date:</strong> {{ $invoice->due_date }}</p>
    </div>

    <div style="margin-bottom: 30px;">
        <h3 style="color: #6b7280; font-size: 12px; text-transform: uppercase;">Bill To</h3>
        <p style="font-weight: bold;">{{ $invoice->client->name }}</p>
        @if($invoice->client->company)
            <p>{{ $invoice->client->company }}</p>
        @endif
        @if($invoice->client->email)
            <p>{{ $invoice->client->email }}</p>
        @endif
    </div>

    <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <thead>
            <tr style="border-bottom: 1px solid #e5e7eb;">
                <th style="text-align: left; padding: 10px 0;">Description</th>
                <th style="text-align: center; padding: 10px 0;">Qty</th>
                <th style="text-align: right; padding: 10px 0;">Price</th>
                <th style="text-align: right; padding: 10px 0;">Total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($invoice->items as $item)
            <tr style="border-bottom: 1px solid #f3f4f6;">
                <td style="padding: 10px 0;">{{ $item->description }}</td>
                <td style="text-align: center; padding: 10px 0;">{{ $item->quantity }}</td>
                <td style="text-align: right; padding: 10px 0;">{{ $symbol }} {{ number_format($item->price, 0, ',', '.') }}</td>
                <td style="text-align: right; padding: 10px 0;">{{ $symbol }} {{ number_format($item->total, 0, ',', '.') }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <div style="text-align: right; margin-bottom: 30px;">
        <p>Subtotal: {{ $symbol }} {{ number_format($invoice->subtotal, 0, ',', '.') }}</p>
        <p>Tax: {{ $symbol }} {{ number_format($invoice->tax, 0, ',', '.') }}</p>
        @if($invoice->discount > 0)
            <p>Discount: - {{ $symbol }} {{ number_format($invoice->discount, 0, ',', '.') }}</p>
        @endif
        <p style="font-size: 18px; font-weight: bold;">Total: {{ $symbol }} {{ number_format($invoice->total, 0, ',', '.') }}</p>
    </div>

    @if($invoice->notes)
    <div style="border-top: 1px solid #e5e7eb; padding-top: 20px;">
        <h4 style="color: #6b7280; font-size: 12px; text-transform: uppercase;">Notes</h4>
        <p>{{ $invoice->notes }}</p>
    </div>
    @endif

    <div style="margin-top: 40px; padding: 20px; background: #f3f4f6; border-radius: 8px; text-align: center;">
        <p style="color: #6b7280; font-size: 14px;">
            Thank you for your business.<br>
            If you have any questions, please contact us.
        </p>
    </div>

</body>
</html>