<?php

namespace App\Http\Controllers;

use App\Models\Client;
use Illuminate\Http\Request;

class ClientController extends Controller
{
    public function index(Request $request)
    {
        $clients = Client::where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json($clients);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name'    => 'required|string|max:255',
            'email'   => 'nullable|email',
            'phone'   => 'nullable|string',
            'address' => 'nullable|string',
            'company' => 'nullable|string',
        ]);

        $client = Client::create([
            ...$request->only('name', 'email', 'phone', 'address', 'company'),
            'user_id' => $request->user()->id,
        ]);

        return response()->json($client, 201);
    }

    public function show(Request $request, Client $client)
    {
        if ($client->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($client);
    }

    public function update(Request $request, Client $client)
    {
        if ($client->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $request->validate([
            'name'    => 'sometimes|string|max:255',
            'email'   => 'nullable|email',
            'phone'   => 'nullable|string',
            'address' => 'nullable|string',
            'company' => 'nullable|string',
        ]);

        $client->update($request->only('name', 'email', 'phone', 'address', 'company'));

        return response()->json($client);
    }

    public function destroy(Request $request, Client $client)
    {
        if ($client->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $client->delete();

        return response()->json(['message' => 'Client deleted']);
    }
}
