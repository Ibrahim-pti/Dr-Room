<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class IsNurse
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (!auth()->check() || !auth()->user()->is_nurse) {
            if ($request->expectsJson()) {
                return response()->json(['message' => 'Access denied. Nurse account required.'], 403);
            }
            return redirect('/nurse/login');
        }

        return $next($request);
    }
}
