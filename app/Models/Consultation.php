<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
#use Illuminate\Database\Eloquent\Model;
use App\Models\BaseModel; // tambah ini

class Consultation extends BaseModel
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'expert_id',
        'topic',
        'fee',
        'duration',
        'status',
        'started_at',
        'scheduled_end_at',
        'ended_at',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'scheduled_end_at' => 'datetime',
        'ended_at' => 'datetime',
        'fee' => 'decimal:2',
    ];

    /**
     * Every time a Consultation is loaded from the database (show,
     * list endpoints, chat polling, etc.), automatically flip it to
     * "completed" if it's still marked "active" but its scheduled end
     * time has already passed. This is what makes sessions end on
     * their own without needing the expert to press "End Session" --
     * there's no cron job running on Railway, so this check-on-read
     * approach is what keeps things up to date instead.
     */
    protected static function booted()
    {
        static::retrieved(function (Consultation $consultation) {
            $consultation->autoCompleteIfExpired();
        });
    }

    public function autoCompleteIfExpired(): bool
    {
        if (
            $this->status === 'active' &&
            $this->scheduled_end_at &&
            now()->gte($this->scheduled_end_at)
        ) {
            $this->update([
                'status'   => 'completed',
                'ended_at' => $this->scheduled_end_at,
            ]);

            // Keep this consistent with the manual "End Session" path,
            // which also increments the expert's total_consultations.
            $expertProfile = ExpertProfile::where('user_id', $this->expert_id)->first();
            $expertProfile?->increment('total_consultations');

            return true;
        }

        return false;
    }

    // Relasi ke user
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    // Relasi ke expert
    public function expert()
    {
        return $this->belongsTo(User::class, 'expert_id');
    }

    // Relasi ke payment
    public function payment()
    {
        return $this->hasOne(Payment::class);
    }

    // Relasi ke chat messages
    public function messages()
    {
        return $this->hasMany(ChatMessage::class);
    }

    // Relasi ke rating
    public function rating()
    {
        return $this->hasOne(Rating::class);
    }
}