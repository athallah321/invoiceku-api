<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Invoice;
use App\Models\Client;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function dashboard()
    {
        $stats = [
            'total_users' => User::count(),
            'total_invoices' => Invoice::count(),
            'total_clients' => Client::count(),
            'total_revenue' => Invoice::where('status', 'paid')->sum('total'),
        ];

        $recentUsers = User::latest()->take(5)->get();
        $recentInvoices = Invoice::with('client', 'user')->latest()->take(5)->get();

        return response()->json([
            'stats' => $stats,
            'recent_users' => $recentUsers,
            'recent_invoices' => $recentInvoices,
        ]);
    }

    public function users(Request $request)
    {
        $query = User::query();

        // Search
        if ($request->search) {
            $query->where('name', 'like', '%' . $request->search . '%')
                  ->orWhere('email', 'like', '%' . $request->search . '%');
        }

        // Filter by role
        if ($request->role) {
            $query->where('role', $request->role);
        }

        $users = $query->withCount('invoices')->latest()->paginate(15);

        return response()->json($users);
    }

    public function storeUser(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
            'role' => 'required|in:admin,user',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'role' => $request->role,
        ]);

        return response()->json($user, 201);
    }

    public function userDetail(User $user)
    {
        $user->loadCount('invoices', 'clients');
        $invoices = $user->invoices()->latest()->take(10)->get();
        $clients = $user->clients()->latest()->take(10)->get();

        return response()->json([
            'user' => $user,
            'invoices' => $invoices,
            'clients' => $clients,
        ]);
    }

    public function updateUser(Request $request, User $user)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'role' => 'required|in:admin,user',
        ]);

        $user->update($request->only('name', 'email', 'role'));

        return response()->json($user);
    }

    public function deleteUser(User $user)
    {
        // Cannot delete yourself
        if ($user->id === auth()->id()) {
            return response()->json(['message' => 'Tidak bisa menghapus akun sendiri'], 403);
        }

        // Delete user's invoices and clients first
        $user->invoices()->delete();
        $user->clients()->delete();
        $user->delete();

        return response()->json(['message' => 'User berhasil dihapus']);
    }

    public function allInvoices(Request $request)
    {
        $query = Invoice::with('client', 'user');

        // Search
        if ($request->search) {
            $query->where('invoice_number', 'like', '%' . $request->search . '%');
        }

        // Filter by status
        if ($request->status) {
            $query->where('status', $request->status);
        }

        // Filter by user
        if ($request->user_id) {
            $query->where('user_id', $request->user_id);
        }

        $invoices = $query->latest()->paginate(15);

        return response()->json($invoices);
    }

    public function userStats(User $user)
    {
        $stats = [
            'total_invoices' => $user->invoices()->count(),
            'paid_invoices' => $user->invoices()->where('status', 'paid')->count(),
            'pending_invoices' => $user->invoices()->whereIn('status', ['sent', 'draft'])->count(),
            'overdue_invoices' => $user->invoices()->where('status', 'overdue')->count(),
            'total_revenue' => $user->invoices()->where('status', 'paid')->sum('total'),
        ];

        return response()->json($stats);
    }

    public function exportBackup()
    {
        $users = User::all()->map(function ($user) {
            return [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'created_at' => $user->created_at,
            ];
        });

        $invoices = Invoice::with('client', 'user')->get()->map(function ($inv) {
            return [
                'id' => $inv->id,
                'invoice_number' => $inv->invoice_number,
                'user_id' => $inv->user_id,
                'user_name' => $inv->user->name ?? null,
                'client_id' => $inv->client_id,
                'client_name' => $inv->client->name ?? null,
                'status' => $inv->status,
                'issue_date' => $inv->issue_date,
                'due_date' => $inv->due_date,
                'subtotal' => $inv->subtotal,
                'tax' => $inv->tax,
                'discount' => $inv->discount,
                'total' => $inv->total,
                'created_at' => $inv->created_at,
            ];
        });

        $clients = Client::with('user')->get()->map(function ($client) {
            return [
                'id' => $client->id,
                'name' => $client->name,
                'email' => $client->email,
                'phone' => $client->phone,
                'address' => $client->address,
                'user_id' => $client->user_id,
                'user_name' => $client->user->name ?? null,
                'created_at' => $client->created_at,
            ];
        });

        $backup = [
            'exported_at' => now()->toIso8601String(),
            'version' => '1.0',
            'users' => $users,
            'invoices' => $invoices,
            'clients' => $clients,
        ];

        return response()->json($backup)->header('Content-Disposition', 'attachment; filename="invoiceku-backup.json"');
    }
}