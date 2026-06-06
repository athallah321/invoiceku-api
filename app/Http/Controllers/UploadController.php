<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class UploadController extends Controller
{
    public function logo(Request $request)
    {
        $request->validate([
            'logo' => 'required|image|mimes:png,jpg,jpeg,gif|max:2048',
        ]);

        $path = $request->file('logo')->store('logos', 'public');
        $url = asset('storage/' . $path);

        return response()->json([
            'url' => $url,
            'path' => $path
        ]);
    }
}