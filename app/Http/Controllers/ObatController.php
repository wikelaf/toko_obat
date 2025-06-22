<?php

namespace App\Http\Controllers;

use App\Models\Obat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ObatController extends Controller
{
    // Tampilkan semua data obat
    public function index()
    {
        $obats = Obat::all();
        return view('obat.index', compact('obats'));
    }

    // Tampilkan form tambah obat
    public function create()
    {
        return view('obat.create');
    }

    // Simpan data obat baru
    public function store(Request $request)
    {
        $request->validate([
            'nama_obat' => 'required',
            'stok' => 'required|integer|min:0',
            'harga_beli' => 'required|numeric|min:0',
            'expired_date' => 'required|date',
            'foto' => 'nullable|image|mimes:jpeg,png,jpg|max:5048',
        ]);

        // Hitung harga jual otomatis (misalnya 20% lebih tinggi dari harga beli)
        $harga_beli = $request->harga_beli;
        $harga_jual = $harga_beli * 1.2;

        // Proses foto (jika ada)
        $path = null;
        if ($request->hasFile('foto')) {
            $path = $request->file('foto')->store('foto_obat', 'public');
        }

        Obat::create([
            'nama_obat' => $request->nama_obat,
            'stok' => $request->stok,
            'harga_beli' => $harga_beli,
            'harga_jual' => $harga_jual,
            'expired_date' => $request->expired_date,
            'foto' => $path,
        ]);

        return redirect()->route('obat.index')->with('success', 'Obat berhasil ditambahkan');
    }

    // Tampilkan detail obat
    public function show(Obat $obat)
    {
        return view('obat.show', compact('obat'));
    }

    // Tampilkan form edit obat
    public function edit(Obat $obat)
    {
        return view('obat.edit', compact('obat'));
    }

    // Update data obat
    public function update(Request $request, Obat $obat)
    {
        $request->validate([
            'nama_obat' => 'required',
            'stok' => 'required|integer|min:0',
            'harga_beli' => 'required|numeric|min:0',
            'expired_date' => 'required|date',
            'foto' => 'nullable|image|mimes:jpeg,png,jpg|max:5048',
        ]);

        // Hitung ulang harga jual otomatis
        $harga_beli = $request->harga_beli;
        $harga_jual = $harga_beli * 1.2;

        // Proses update foto
        $path = $obat->foto;
        if ($request->hasFile('foto')) {
            if ($path && Storage::disk('public')->exists($path)) {
                Storage::disk('public')->delete($path);
            }
            $path = $request->file('foto')->store('foto_obat', 'public');
        }

        $obat->update([
            'nama_obat' => $request->nama_obat,
            'stok' => $request->stok,
            'harga_beli' => $harga_beli,
            'harga_jual' => $harga_jual,
            'expired_date' => $request->expired_date,
            'foto' => $path,
        ]);

        return redirect()->route('obat.index')->with('success', 'Obat berhasil diperbarui');
    }

    // Hapus data obat
    public function destroy(Obat $obat)
    {
        if ($obat->foto && Storage::disk('public')->exists($obat->foto)) {
            Storage::disk('public')->delete($obat->foto);
        }

        $obat->delete();

        return redirect()->route('obat.index')->with('success', 'Obat berhasil dihapus');
    }
}
