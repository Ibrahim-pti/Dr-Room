<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AppNotification;

class NotificationController extends Controller
{
    public function index()
    {
        return AppNotification::latest()->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'message' => 'required|string',
            'type' => 'nullable|string',
            'user_id' => 'nullable|exists:users,id'
        ]);

        $notification = AppNotification::create([
            'title' => $request->title,
            'message' => $request->message,
            'type' => $request->type ?? 'general',
            'user_id' => $request->user_id,
        ]);

        // Here we would trigger Firebase Cloud Messaging (FCM) or APNS to send the push notification to mobile devices.

        return response()->json($notification, 201);
    }

    public function show(string $id)
    {
        return AppNotification::findOrFail($id);
    }

    public function update(Request $request, string $id)
    {
        $notification = AppNotification::findOrFail($id);
        
        $request->validate([
            'title' => 'nullable|string',
            'message' => 'nullable|string',
            'type' => 'nullable|string',
            'user_id' => 'nullable|exists:users,id'
        ]);

        $notification->update($request->all());

        return response()->json($notification);
    }

    public function destroy(string $id)
    {
        $notification = AppNotification::findOrFail($id);
        $notification->delete();

        return response()->json(null, 204);
    }
}
