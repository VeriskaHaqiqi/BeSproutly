<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ExpertProfile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    // ==================== GET PROFILE ====================
    public function index(Request $request)
    {
        $user = $request->user()->load([
            'expertProfile',
            'specializations',
            'schedules',
        ]);

        return response()->json([
            'success' => true,
            'data'    => $user,
        ]);
    }

    // ==================== EDIT PROFILE ====================
    public function update(Request $request)
    {
        $request->validate([
            'name'   => 'nullable|string|max:100',
            'phone'  => 'nullable|string|max:20',
            'gender' => 'nullable|in:Male,Female,Other',
        ]);

        $user = $request->user();

        $user->update([
            'name'   => $request->name   ?? $user->name,
            'phone'  => $request->phone  ?? $user->phone,
            'gender' => $request->gender ?? $user->gender,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data'    => $user->load('expertProfile'),
        ]);
    }

    // ==================== UPLOAD FOTO PROFIL ====================
    public function uploadPhoto(Request $request)
    {
        $request->validate([
            'profile_photo' => 'required|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        $user = $request->user();

        // Hapus foto lama kalau ada
        if ($user->profile_photo) {
            Storage::disk('public')->delete($user->profile_photo);
        }

        // Upload foto baru
        $path = $request->file('profile_photo')
            ->store('profiles/photos', 'public');

        $user->update(['profile_photo' => $path]);

        return response()->json([
            'success' => true,
            'message' => 'Profile photo uploaded successfully',
            'data'    => [
                'profile_photo' => $path,
                'photo_url'     => asset('storage/' . $path),
            ],
        ]);
    }

    // ==================== HAPUS FOTO PROFIL ====================
    public function deletePhoto(Request $request)
    {
        $user = $request->user();

        if (!$user->profile_photo) {
            return response()->json([
                'success' => false,
                'message' => 'No profile photo to delete',
            ], 400);
        }

        // Hapus file dari storage
        Storage::disk('public')->delete($user->profile_photo);

        $user->update(['profile_photo' => null]);

        return response()->json([
            'success' => true,
            'message' => 'Profile photo deleted successfully',
        ]);
    }

    // ==================== GANTI PASSWORD ====================
    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password'  => 'required|string',
            'new_password'      => 'required|string|min:8|confirmed',
        ]);

        $user = $request->user();

        // Cek password lama
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Current password is incorrect',
            ], 400);
        }

        // Cek apakah password baru sama dengan yang lama
        if (Hash::check($request->new_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'New password cannot be the same as current password',
            ], 400);
        }

        $user->update([
            'password' => Hash::make($request->new_password),
        ]);

        // Hapus semua token lama, paksa login ulang
        $user->tokens()->delete();
        $newToken = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Password changed successfully, please login again',
            'data'    => [
                'token' => $newToken,
            ],
        ]);
    }

    // ==================== EDIT EXPERT PROFILE ====================
    public function updateExpertProfile(Request $request)
    {
        if ($request->user()->role !== 'expert') {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $request->validate([
            'university'          => 'nullable|string|max:150',
            'years_of_experience' => 'nullable|integer|min:0',
            'description'         => 'nullable|string',
        ]);

        $profile = ExpertProfile::where('user_id', $request->user()->id)->first();

        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Expert profile not found',
            ], 404);
        }

        $profile->update([
            'university'          => $request->university          ?? $profile->university,
            'years_of_experience' => $request->years_of_experience ?? $profile->years_of_experience,
            'description'         => $request->description         ?? $profile->description,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Expert profile updated successfully',
            'data'    => $profile,
        ]);
    }

    // ==================== UPDATE BANK ACCOUNT ====================
    public function updateBankAccount(Request $request)
    {
        if ($request->user()->role !== 'expert') {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $request->validate([
            'bank_name'      => 'required|string|max:100',
            'account_holder' => 'required|string|max:100',
            'account_number' => 'required|string|max:50',
        ]);

        $profile = ExpertProfile::where('user_id', $request->user()->id)->first();

        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Expert profile not found',
            ], 404);
        }

        $profile->update([
            'bank_name'      => $request->bank_name,
            'account_holder' => $request->account_holder,
            'account_number' => $request->account_number,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Bank account updated successfully',
            'data'    => $profile,
        ]);
    }

    // ==================== UPLOAD CERTIFICATE (EXPERT) ====================
    public function uploadCertificate(Request $request)
    {
        if ($request->user()->role !== 'expert') {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $request->validate([
            'certificate' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120',
        ]);

        $profile = ExpertProfile::where('user_id', $request->user()->id)->first();

        // Hapus sertifikat lama
        if ($profile->certificate) {
            Storage::disk('public')->delete($profile->certificate);
        }

        $path = $request->file('certificate')
            ->store('experts/certificates', 'public');

        $profile->update(['certificate' => $path]);

        return response()->json([
            'success' => true,
            'message' => 'Certificate uploaded successfully',
            'data'    => [
                'certificate' => $path,
                'url'         => asset('storage/' . $path),
            ],
        ]);
    }
}