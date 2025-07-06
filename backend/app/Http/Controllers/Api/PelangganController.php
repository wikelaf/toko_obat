<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PelangganController extends Controller
{
    // GET /api/pelanggan
    public function index()
    {
        $pelanggans = Pelanggan::all();
        return response()->json($pelanggans, 200);
    }

    // POST /api/pelanggan
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama'     => 'required|string|max:100',
            'email'    => 'required|email|unique:pelanggans,email',
            'password' => 'required|string|min:6',
            'alamat'   => 'required|string',
            'telepon'  => 'required|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $pelanggan = Pelanggan::create([
            'nama'     => $request->nama,
            'email'    => $request->email,
            'password' => bcrypt($request->password),
            'alamat'   => $request->alamat,
            'telepon'  => $request->telepon,
        ]);

        return response()->json([
            'message' => 'Pelanggan berhasil ditambahkan.',
            'data'    => $pelanggan
        ], 201);
    }

    // GET /api/pelanggan/{id}
    public function show($id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan.'], 404);
        }

        return response()->json($pelanggan, 200);
    }

    // PUT /api/pelanggan/{id}
    public function update(Request $request, $id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan.'], 404);
        }

        $validator = Validator::make($request->all(), [
            'nama'     => 'required|string|max:100',
            'email'    => 'required|email|unique:pelanggans,email,' . $id . ',id_pelanggan',
            'alamat'   => 'required|string',
            'telepon'  => 'required|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $pelanggan->update($request->only(['nama', 'email', 'alamat', 'telepon']));

        return response()->json([
            'message' => 'Pelanggan berhasil diupdate.',
            'data'    => $pelanggan
        ], 200);
    }

    // DELETE /api/pelanggan/{id}
    public function destroy($id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan.'], 404);
        }

        $pelanggan->delete();

        return response()->json(['message' => 'Pelanggan berhasil dihapus.'], 200);
    }
}
