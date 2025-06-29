<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Pelanggan;

class LoginController extends Controller
{
    // ==============================
    // Login Admin/User Biasa
    // ==============================
    public function login(Request $request)
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'message' => 'Email atau password salah'
            ], 401);
        }

        $user = Auth::user();
        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'user'    => $user,
            'token'   => $token,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout berhasil'
        ]);
    }

    // ==============================
    // Register Pelanggan
    // ==============================
   public function registerPelanggan(Request $request)
{
    $validated = $request->validate([
        'nama'     => 'required|string|max:255',
        'alamat'   => 'required|string',
        'telepon'  => 'required|string|max:20',
        'email'    => 'required|email|unique:pelanggans,email',
        'password' => 'required|string|min:6|confirmed',
    ]);

    $pelanggan = Pelanggan::create([
        'nama'     => $validated['nama'],
        'alamat'   => $validated['alamat'],
        'telepon'  => $validated['telepon'],
        'email'    => $validated['email'],
        'password' => Hash::make($validated['password']),
    ]);

    $token = $pelanggan->createToken('pelanggan-token')->plainTextToken;

    return response()->json([
        'message'   => 'Registrasi pelanggan berhasil',
        'pelanggan' => $pelanggan,
        'token'     => $token,
    ]);


    }

    // ==============================
    // Login Pelanggan
    // ==============================
    public function loginPelanggan(Request $request)
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        $pelanggan = Pelanggan::where('email', $request->email)->first();

        if (!$pelanggan || !Hash::check($request->password, $pelanggan->password)) {
            return response()->json([
                'message' => 'Email atau password salah'
            ], 401);
        }

        $token = $pelanggan->createToken('pelanggan-token')->plainTextToken;

        return response()->json([
            'message'   => 'Login pelanggan berhasil',
            'pelanggan' => $pelanggan,
            'token'     => $token,
        ]);
    }

    // ==============================
    // Logout Pelanggan
    // ==============================
    public function logoutPelanggan(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout pelanggan berhasil'
        ]);
    }
}