<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Http\Request;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     */
    protected function redirectTo(Request $request): ?string
    {
        // Always return null for API routes to return JSON instead of redirect
        if ($request->is('api/*') || $request->expectsJson()) {
            return null;
        }

        // For web routes, redirect to home or custom login
        if (route('login', [], false)) {
            return route('login');
        }
        return null;
    }
}
