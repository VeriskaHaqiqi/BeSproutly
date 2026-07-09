<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
#use Illuminate\Database\Eloquent\Model;
use App\Models\BaseModel; // tambah ini

class ExpertProfile extends BaseModel
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'university',
        'years_of_experience',
        'description',
        'certificate',
        'diploma',
        'bank_name',
        'account_holder',
        'account_number',
        'session_fee',
        'session_duration',
        'instant_booking',
        'availability_status',
        'average_rating',
        'total_consultations',
    ];

    protected $casts = [
        'instant_booking' => 'boolean',
        'session_fee' => 'decimal:2',
        'average_rating' => 'decimal:2',
    ];

    // Relasi ke user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relasi ke jadwal milik expert ini
    // (ExpertSchedule.expert_id references the same id as users.id / this profile's user_id)
    public function schedules()
    {
        return $this->hasMany(ExpertSchedule::class, 'expert_id', 'user_id');
    }

    /**
     * Override: `availability_status` is no longer read from the stored
     * column. Instead it's computed live from `expert_schedules` — an
     * expert is "available" only if right now (server time, Asia/Jakarta)
     * falls inside one of their active schedule windows for today.
     *
     * This runs automatically anywhere the app reads
     * `$expertProfile->availability_status` (including JSON responses via
     * User::with('expertProfile')), so no controller or frontend changes
     * are needed.
     */
    public function getAvailabilityStatusAttribute($value)
    {
        return $this->isCurrentlyOnline() ? 'available' : 'unavailable';
    }

    public function isCurrentlyOnline(): bool
    {
        $now = now('Asia/Jakarta');
        $today = $now->format('l');          // e.g. "Tuesday"
        $currentTime = $now->format('H:i:s'); // e.g. "14:30:00"

        return ExpertSchedule::where('expert_id', $this->user_id)
            ->where('day', $today)
            ->where('is_active', true)
            ->where('start_time', '<=', $currentTime)
            ->where('end_time', '>=', $currentTime)
            ->exists();
    }
}