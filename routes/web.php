<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    return response()->json(['message' => 'Invoiceku API']);
});

// Fallback routes for auth redirects
Route::get('/login', function () {
    return response()->json(['error' => 'API endpoint - use POST /api/login'], 401);
});

Route::get('/register', function () {
    return response()->json(['error' => 'API endpoint - use POST /api/register'], 401);
});
