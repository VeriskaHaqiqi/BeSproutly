<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Consultation;
use App\Models\ExpertProfile;
use App\Models\Rating;
use Illuminate\Http\Request;

class RatingController extends Controller
{
    // ==================== SUBMIT RATING (USER) ====================
    public function store(Request $request, $consultationId)
    {
        // Cek role user
        if ($request->user()->role !== 'user') {
            return response()->json([
                'success' => false,
                'message' => 'Only users can submit ratings',
            ], 403);
        }

        // Cek konsultasi
        $consultation = Consultation::where('id', $consultationId)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$consultation) {
            return response()->json([
                'success' => false,
                'message' => 'Consultation not found',
            ], 404);
        }

        // Cek apakah konsultasi sudah selesai
        if ($consultation->status !== 'completed') {
            return response()->json([
                'success' => false,
                'message' => 'Consultation is not completed yet',
            ], 400);
        }

        // Cek apakah sudah pernah rating
        $existingRating = Rating::where('consultation_id', $consultationId)->first();
        if ($existingRating) {
            return response()->json([
                'success' => false,
                'message' => 'You have already rated this consultation',
            ], 400);
        }

        $request->validate([
            'score'   => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        // Simpan rating
        $rating = Rating::create([
            'consultation_id' => $consultationId,
            'user_id'         => $request->user()->id,
            'expert_id'       => $consultation->expert_id,
            'score'           => $request->score,
            'comment'         => $request->comment,
        ]);

        // Update average rating expert
        $this->updateExpertRating($consultation->expert_id);

        return response()->json([
            'success' => true,
            'message' => 'Rating submitted successfully',
            'data'    => $rating->load(['user', 'expert']),
        ], 201);
    }

    // ==================== GET USER RATINGS (USER) ====================
    public function userRatings(Request $request)
    {
        $ratings = Rating::with(['expert', 'consultation'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(10);

        return response()->json([
            'success' => true,
            'data'    => $ratings,
        ]);
    }

    // ==================== GET EXPERT RATINGS (EXPERT) ====================
    public function expertRatings(Request $request)
    {
        if ($request->user()->role !== 'expert') {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $ratings = Rating::with(['user', 'consultation'])
            ->where('expert_id', $request->user()->id)
            ->latest()
            ->paginate(10);

        $averageRating = Rating::where('expert_id', $request->user()->id)
            ->avg('score');

        return response()->json([
            'success' => true,
            'data'    => [
                'average_rating' => round($averageRating, 2),
                'total_ratings'  => $ratings->total(),
                'ratings'        => $ratings,
            ],
        ]);
    }

    // ==================== GET RATINGS BY EXPERT ID (PUBLIC) ====================
    public function expertRatingsPublic($expertId)
    {
        $ratings = Rating::with(['user'])
            ->where('expert_id', $expertId)
            ->latest()
            ->paginate(10);

        $averageRating = Rating::where('expert_id', $expertId)->avg('score');

        return response()->json([
            'success' => true,
            'data'    => [
                'average_rating' => round($averageRating, 2),
                'total_ratings'  => $ratings->total(),
                'ratings'        => $ratings,
            ],
        ]);
    }

    // ==================== GET CONSULTATIONS PENDING RATING ====================
    public function pendingRatings(Request $request)
    {
        if ($request->user()->role !== 'user') {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Ambil konsultasi completed yang belum dirating
        $consultations = Consultation::with(['expert', 'expert.expertProfile'])
            ->where('user_id', $request->user()->id)
            ->where('status', 'completed')
            ->whereDoesntHave('rating')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $consultations,
        ]);
    }

    // ==================== HELPER: UPDATE EXPERT AVERAGE RATING ====================
    private function updateExpertRating($expertId)
    {
        $averageRating = Rating::where('expert_id', $expertId)->avg('score');
        $totalRatings  = Rating::where('expert_id', $expertId)->count();

        ExpertProfile::where('user_id', $expertId)->update([
            'average_rating' => round($averageRating, 2),
        ]);
    }
}