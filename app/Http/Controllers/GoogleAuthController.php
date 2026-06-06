<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Str;
use Laravel\Socialite\Facades\Socialite;

class GoogleAuthController extends Controller
{
    public function redirectToGoogle()
    {
        return Socialite::driver('google')->redirect();
    }

    public function handleGoogleCallback()
    {
        try {
            $googleUser = Socialite::driver('google')->stateless()->user();

            // Find user by google_id ONLY (don't link by email)
            $user = User::where('google_id', $googleUser->id)->first();

            if (!$user) {
                // Create new user for this Google account
                // Don't check by email to avoid logging in as existing user
                $user = User::create([
                    'name' => $googleUser->name,
                    'email' => $googleUser->email,
                    'google_id' => $googleUser->id,
                    'password' => bcrypt(Str::random(16)),
                    'role' => 'user',
                ]);
            }

            // Create token
            $token = $user->createToken('google-auth')->plainTextToken;

            // Create URL-safe payload
            $authData = json_encode([
                'user' => ['id' => $user->id, 'name' => $user->name, 'email' => $user->email, 'role' => $user->role],
                'token' => $token,
                'exp' => time() + 600 // 10 minutes
            ]);

            $encoded = rtrim(strtr(base64_encode($authData), '+/', '-_'), '=');

            return redirect(env('FRONTEND_URL', 'http://localhost:3000') . '/auth/google?auth=' . $encoded);

        } catch (\Exception $e) {
            return redirect(env('FRONTEND_URL', 'http://localhost:3000') . '/login?error=google_failed');
        }
    }
}