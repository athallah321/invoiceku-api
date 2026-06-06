<?php

namespace App\Console\Commands;

use App\Models\Invoice;
use Illuminate\Console\Command;

class MarkOverdueInvoices extends Command
{
    protected $signature = 'invoices:mark-overdue';
    protected $description = 'Mark invoices as overdue if past due date';

    public function handle()
    {
        $today = now()->toDateString();

        $count = Invoice::where('due_date', '<', $today)
            ->whereIn('status', ['sent', 'draft'])
            ->update(['status' => 'overdue']);

        $this->info("Marked {$count} invoices as overdue.");

        return Command::SUCCESS;
    }
}
