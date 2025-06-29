<?php

namespace App\Http\Controllers;

use App\Models\Pelanggan;
use Illuminate\Http\Request;

class PelangganController extends Controller
{
    // Tampilkan semua pelanggan
    public function index()
    {
        $pelanggans = Pelanggan::all();
        return view('pelanggan.index', compact('pelanggans'));
    }

    // Tampilkan form tambah pelanggan
    public function create()
    {
        return view('pelanggan.create');
    }

    // Simpan pelanggan baru
    public function store(Request $request)
    {
        $request->validate([
            'nama'     => 'required',
            'email'    => 'required|email|unique:pelanggans,email',
            'password' => 'required|min:6',
            'alamat'   => 'required',
            'telepon'  => 'required',
        ]);

        Pelanggan::create([
            'nama'     => $request->nama,
            'email'    => $request->email,
            'password' => bcrypt($request->password),
            'alamat'   => $request->alamat,
            'telepon'  => $request->telepon,
        ]);

        return redirect()->route('pelanggan.index')->with('success', 'Pelanggan berhasil ditambahkan');
    }

    // Tampilkan form edit pelanggan
    public function edit($id)
    {
        $pelanggan = Pelanggan::findOrFail($id);
        return view('pelanggan.edit', compact('pelanggan'));
    }

    // Update pelanggan
    public function update(Request $request, $id)
    {
        $pelanggan = Pelanggan::findOrFail($id);

        $request->validate([
            'nama'   => 'required',
            'email'  => 'required|email|unique:pelanggans,email,' . $id . ',id_pelanggan',
            'alamat' => 'required',
            'telepon'=> 'required',
        ]);

        $pelanggan->update([
            'nama'   => $request->nama,
            'email'  => $request->email,
            'alamat' => $request->alamat,
            'telepon'=> $request->telepon,
        ]);

        return redirect()->route('pelanggan.index')->with('success', 'Pelanggan berhasil diupdate');
    }

    // Hapus pelanggan
    public function destroy($id)
    {
        $pelanggan = Pelanggan::findOrFail($id);
        $pelanggan->delete();

        return redirect()->route('pelanggan.index')->with('success', 'Pelanggan berhasil dihapus');
    }

    // Laporan pelanggan
    public function laporan()
    {
        $pelanggans = Pelanggan::all();
        return view('pelanggan.laporan', compact('pelanggans'));
    }
}
