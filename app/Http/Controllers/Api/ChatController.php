<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ChatMessage;
use App\Models\Consultation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ChatController extends Controller
{
    // ==================== GET MESSAGES ====================
    public function getMessages(Request $request, $consultationId)
    {
        // Cek apakah user adalah bagian dari konsultasi ini
        $consultation = Consultation::where('id', $consultationId)
            ->where(function ($q) use ($request) {
                $q->where('user_id', $request->user()->id)
                  ->orWhere('expert_id', $request->user()->id);
            })->first();

        if (!$consultation) {
            return response()->json([
                'success' => false,
                'message' => 'Consultation not found',
            ], 404);
        }

        // Cek apakah konsultasi sudah aktif
        if (!in_array($consultation->status, ['active', 'completed'])) {
            return response()->json([
                'success' => false,
                'message' => 'Consultation is not active yet',
            ], 403);
        }

        // Tandai semua pesan sebagai sudah dibaca
        ChatMessage::where('consultation_id', $consultationId)
            ->where('sender_id', '!=', $request->user()->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        $messages = ChatMessage::with('sender')
            ->where('consultation_id', $consultationId)
            ->oldest()
            ->paginate(50);

        return response()->json([
            'success' => true,
            'data'    => [
                'consultation' => $consultation,
                'messages'     => $messages,
            ],
        ]);
    }

    // ==================== SEND MESSAGE ====================
    public function sendMessage(Request $request, $consultationId)
    {
        // Cek apakah user adalah bagian dari konsultasi ini
        $consultation = Consultation::where('id', $consultationId)
            ->where(function ($q) use ($request) {
                $q->where('user_id', $request->user()->id)
                  ->orWhere('expert_id', $request->user()->id);
            })->first();

        if (!$consultation) {
            return response()->json([
                'success' => false,
                'message' => 'Consultation not found',
            ], 404);
        }

        // Cek apakah konsultasi masih aktif
        if ($consultation->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Consultation is not active',
            ], 403);
        }

        $request->validate([
            'message'      => 'nullable|string',
            'attachment'   => 'nullable|file|mimes:jpg,jpeg,png,mp4|max:10240',
            'message_type' => 'nullable|in:text,image,video',
        ]);

        // Minimal salah satu harus ada
        if (!$request->message && !$request->hasFile('attachment')) {
            return response()->json([
                'success' => false,
                'message' => 'Message or attachment is required',
            ], 422);
        }

        $attachmentPath = null;
        $messageType    = 'text';

        if ($request->hasFile('attachment')) {
            $file        = $request->file('attachment');
            $mimeType    = $file->getMimeType();

            if (str_contains($mimeType, 'video')) {
                $messageType    = 'video';
                $attachmentPath = $file->store('chat/videos', 'public');
            } else {
                $messageType    = 'image';
                $attachmentPath = $file->store('chat/images', 'public');
            }
        }

        $chatMessage = ChatMessage::create([
            'consultation_id' => $consultationId,
            'sender_id'       => $request->user()->id,
            'message'         => $request->message,
            'attachment'      => $attachmentPath,
            'message_type'    => $messageType,
            'is_read'         => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Message sent successfully',
            'data'    => $chatMessage->load('sender'),
        ], 201);
    }

    // ==================== MARK AS READ ====================
    public function markAsRead(Request $request, $consultationId)
    {
        $consultation = Consultation::where('id', $consultationId)
            ->where(function ($q) use ($request) {
                $q->where('user_id', $request->user()->id)
                  ->orWhere('expert_id', $request->user()->id);
            })->first();

        if (!$consultation) {
            return response()->json([
                'success' => false,
                'message' => 'Consultation not found',
            ], 404);
        }

        // Tandai semua pesan dari lawan bicara sebagai sudah dibaca
        $updated = ChatMessage::where('consultation_id', $consultationId)
            ->where('sender_id', '!=', $request->user()->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json([
            'success'          => true,
            'message'          => 'Messages marked as read',
            'messages_updated' => $updated,
        ]);
    }

    // ==================== GET UNREAD COUNT ====================
    public function unreadCount(Request $request)
    {
        $unreadCount = ChatMessage::whereHas('consultation', function ($q) use ($request) {
            $q->where('user_id', $request->user()->id)
              ->orWhere('expert_id', $request->user()->id);
        })
        ->where('sender_id', '!=', $request->user()->id)
        ->where('is_read', false)
        ->count();

        return response()->json([
            'success' => true,
            'data'    => [
                'unread_count' => $unreadCount,
            ],
        ]);
    }

    // ==================== DELETE MESSAGE ====================
    public function deleteMessage(Request $request, $messageId)
    {
        $message = ChatMessage::where('id', $messageId)
            ->where('sender_id', $request->user()->id)
            ->first();

        if (!$message) {
            return response()->json([
                'success' => false,
                'message' => 'Message not found',
            ], 404);
        }

        // Hapus attachment kalau ada
        if ($message->attachment) {
            Storage::disk('public')->delete($message->attachment);
        }

        $message->delete();

        return response()->json([
            'success' => true,
            'message' => 'Message deleted successfully',
        ]);
    }
}