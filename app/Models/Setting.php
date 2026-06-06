<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    protected $fillable = [
        'user_id',
        'key',
        'value',
    ];

    protected $casts = [
        'value' => 'string',
    ];

    // Get settings as array for a user
    public static function getSettings($userId)
    {
        $settings = self::where('user_id', $userId)->get();
        $result = [];
        foreach ($settings as $setting) {
            $result[$setting->key] = $setting->value;
        }
        return $result;
    }

    // Save or update setting
    public static function saveSetting($userId, $key, $value)
    {
        return self::updateOrCreate(
            ['user_id' => $userId, 'key' => $key],
            ['value' => $value]
        );
    }
}