<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pemasok;
use Illuminate\Http\Request;

class PemasokController extends Controller
{
    // GET /api/pemasok
    public function index()
    {
        $data = Pemasok::all();
        return response()->json($data, 200);
    }

    // POST /api/pemasok
    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:100',
            'alamat' => 'nullable|string',
            'telepon' => 'nullable|string|max:20',
        ]);

        $pemasok = Pemasok::create($request->all());

        return response()->json([
            'message' => 'Pemasok berhasil ditambahkan.',
            'data' => $pemasok
        ], 201);
    }

    // GET /api/pemasok/{id}
    public function show($id)
    {
        $pemasok = Pemasok::find($id);

        if (!$pemasok) {
            return response()->json(['message' => 'Pemasok tidak ditemukan.'], 404);
        }

        return response()->json($pemasok, 200);
    }

    // PUT /api/pemasok/{id}
    public function update(Request $request, $id)
    {
        $pemasok = Pemasok::find($id);

        if (!$pemasok) {
            return response()->json(['message' => 'Pemasok tidak ditemukan.'], 404);
        }

        $request->validate([
            'nama' => 'required|string|max:100',
            'alamat' => 'nullable|string',
            'telepon' => 'nullable|string|max:20',
        ]);

        $pemasok->update($request->all());

        return response()->json([
            'message' => 'Pemasok berhasil diupdate.',
            'data' => $pemasok
        ], 200);
    }

    // DELETE /api/pemasok/{id}
    public function destroy($id)
    {
        $pemasok = Pemasok::find($id);

        if (!$pemasok) {
            return response()->json(['message' => 'Pemasok tidak ditemukan.'], 404);
        }

        $pemasok->delete();

        return response()->json(['message' => 'Pemasok berhasil dihapus.'], 200);
    }
}
