<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use Illuminate\Http\Request;

class PelangganController extends Controller
{
    // GET /api/pelanggan
    public function index()
    {
        $data = Pelanggan::all();
        return response()->json($data, 200);
    }

    // POST /api/pelanggan
    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:100',
            'alamat' => 'nullable|string',
            'telepon' => 'nullable|string|max:20',
        ]);

        $pelanggan = Pelanggan::create($request->all());

        return response()->json([
            'message' => 'Pelanggan berhasil ditambahkan.',
            'data' => $pelanggan
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

        $request->validate([
            'nama' => 'required|string|max:100',
            'alamat' => 'nullable|string',
            'telepon' => 'nullable|string|max:20',
        ]);

        $pelanggan->update($request->all());

        return response()->json([
            'message' => 'Pelanggan berhasil diupdate.',
            'data' => $pelanggan
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
