<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    use HasFactory;

    protected $fillable = [
    'user_id', 'client_id', 'invoice_number', 'status',
    'issue_date', 'due_date', 'subtotal', 'tax', 'discount', 'total', 'notes'
];

    public function client()
    {
        return $this->belongsTo(Client::class);
    }

    public function items()
    {
        return $this->hasMany(InvoiceItem::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function scopeOverdue($query)
    {
        return $query->where('due_date', '<', now()->toDateString())
                    ->whereIn('status', ['sent', 'draft']);
    }

    public static function markAllOverdue()
    {
        return static::overdue()->update(['status' => 'overdue']);
    }
}
