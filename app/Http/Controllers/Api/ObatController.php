<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Obat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ObatController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $data = Obat::all()->map(function ($obat) {
            $obat->foto = $obat->foto ? asset('storage/' . $obat->foto) : null;
            return $obat;
        });

        return response()->json($data);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_obat' => 'required|unique:obats,nama_obat',
            'stok' => 'required|integer|min:0',
            'harga_beli' => 'required|numeric|min:0',
            'harga_jual' => 'required|numeric|min:0',
            'expired_date' => 'required|date',
            'foto' => 'nullable|image|max:2048',
        ]);

        $data = $request->only(['nama_obat', 'stok', 'harga_beli', 'harga_jual', 'expired_date']);

        if ($request->hasFile('foto')) {
            $data['foto'] = $request->file('foto')->store('foto_obat', 'public');
        }

        $obat = Obat::create($data);

        return response()->json([
            'message' => 'Obat berhasil ditambahkan',
            'obat' => $obat,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $obat = Obat::find($id);

        if (!$obat) {
            return response()->json(['message' => 'Obat tidak ditemukan'], 404);
        }

        $obat->foto = $obat->foto ? asset('storage/' . $obat->foto) : null;

        return response()->json($obat, 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $obat = Obat::find($id);

        if (!$obat) {
            return response()->json(['message' => 'Obat tidak ditemukan'], 404);
        }

        $request->validate([
            'nama_obat' => 'required|string|max:100',
            'stok' => 'required|integer|min:0',
            'harga_beli' => 'required|numeric|min:0',
            'harga_jual' => 'required|numeric|min:0',
            'expired_date' => 'required|date',
            'foto' => 'nullable|image|max:5048',
        ]);

        $data = $request->only(['nama_obat', 'stok', 'harga_beli', 'harga_jual', 'expired_date']);

        if ($request->hasFile('foto')) {
            // Hapus foto lama jika ada
            if ($obat->foto) {
                Storage::disk('public')->delete($obat->foto);
            }
            $data['foto'] = $request->file('foto')->store('foto_obat', 'public');
        }

        $obat->update($data);

        return response()->json([
            'message' => 'Obat berhasil diupdate',
            'obat' => $obat,
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $obat = Obat::find($id);

        if (!$obat) {
            return response()->json(['message' => 'Obat tidak ditemukan'], 404);
        }

        // Hapus foto jika ada
        if ($obat->foto) {
            Storage::disk('public')->delete($obat->foto);
        }

        $obat->delete();

        return response()->json(['message' => 'Obat berhasil dihapus'], 200);
    }
}
