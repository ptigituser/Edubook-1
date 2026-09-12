<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Conversation;
use App\Models\Institution;
use App\Models\Message;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    /**
     * Get or start conversation and list messages with an institution.
     */
    public function getMessages(Request $request, int $institutionId)
    {
        $user = $request->user();
        $institution = Institution::findOrFail($institutionId);

        $conversation = Conversation::firstOrCreate(
            [
                'institution_id' => $institution->id,
                'user_id'        => $user->id,
            ],
            [
                'last_message_at' => now(),
            ]
        );

        // Mark messages sent by the institution as read
        Message::where('conversation_id', $conversation->id)
            ->where('sender_type', 'institution')
            ->where('is_read', false)
            ->update(['is_read' => true]);

        $conversation->update(['user_unread_count' => 0]);

        $messages = $conversation->messages()->get();

        return response()->json([
            'success' => true,
            'data'    => [
                'conversation_id' => $conversation->id,
                'institution'     => [
                    'id'   => $institution->id,
                    'name' => $institution->nku,
                    'logo' => $institution->logo,
                    'city' => $institution->city,
                ],
                'messages' => $messages,
            ],
        ]);
    }

    /**
     * Send a message to an institution.
     */
    public function sendMessage(Request $request, int $institutionId)
    {
        $request->validate([
            'message' => 'required|string|max:3000',
        ]);

        $user = $request->user();
        $institution = Institution::findOrFail($institutionId);

        $conversation = Conversation::firstOrCreate(
            [
                'institution_id' => $institution->id,
                'user_id'        => $user->id,
            ]
        );

        $text = trim($request->input('message'));

        $msg = Message::create([
            'conversation_id' => $conversation->id,
            'sender_type'     => 'user',
            'sender_id'       => $user->id,
            'message'         => $text,
            'is_read'         => false,
        ]);

        $conversation->update([
            'last_message'             => $text,
            'last_message_at'          => now(),
            'institution_unread_count' => $conversation->institution_unread_count + 1,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'نامەکەت نێردرا.',
            'data'    => $msg,
        ], 201);
    }

    /**
     * List conversations of the authenticated user.
     */
    public function myConversations(Request $request)
    {
        $user = $request->user();

        $conversations = Conversation::where('user_id', $user->id)
            ->with(['institution' => function ($q) {
                $q->select('id', 'nku', 'logo', 'city', 'type');
            }])
            ->latest('last_message_at')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $conversations,
        ]);
    }
}
