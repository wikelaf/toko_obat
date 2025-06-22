<?php

namespace App\Http\Controllers;

use App\Models\Penjualan;
use App\Models\PenjualanDetail;
use App\Models\Pelanggan;
use App\Models\Obat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PenjualanController extends Controller
{
    public function index()
    {
        $penjualans = Penjualan::with('pelanggan')->orderBy('tanggal', 'desc')->get();
        return view('penjualan.index', compact('penjualans'));
    }

    public function create()
    {
        $pelanggans = Pelanggan::all();
        $obats = Obat::all();
        return view('penjualan.create', compact('pelanggans', 'obats'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'tanggal' => 'required|date',
            'id_pelanggan' => 'required|exists:pelanggans,id_pelanggan',
            'obat_id' => 'required|array',
            'obat_id.*' => 'required|exists:obats,id_obat',
            'jumlah' => 'required|array',
            'jumlah.*' => 'required|integer|min:1',
            'harga_satuan' => 'required|array',
            'harga_satuan.*' => 'required|numeric|min:0',
            'bayar' => 'required|numeric|min:0',
            'kembalian' => 'required|numeric|min:0',
        ]);

        DB::beginTransaction();

        try {
            $total_harga = 0;
            foreach ($request->jumlah as $key => $jumlah) {
                $harga_satuan = $request->harga_satuan[$key];
                $subtotal = $jumlah * $harga_satuan;
                $total_harga += $subtotal;
            }

            // Optional: cek apakah bayar cukup
            if ($request->bayar < $total_harga) {
                return back()->withErrors('Jumlah bayar kurang dari total harga')->withInput();
            }

            $penjualan = Penjualan::create([
                'tanggal' => $request->tanggal,
                'id_pelanggan' => $request->id_pelanggan,
                'total_harga' => $total_harga,
                'bayar' => $request->bayar,
                'kembalian' => $request->kembalian,
            ]);

            foreach ($request->obat_id as $key => $obat_id) {
                $jumlah = $request->jumlah[$key];
                $harga_satuan = $request->harga_satuan[$key];
                $subtotal = $jumlah * $harga_satuan;

                PenjualanDetail::create([
                    'id_penjualan' => $penjualan->id_penjualan,
                    'id_obat' => $obat_id,
                    'jumlah' => $jumlah,
                    'harga_satuan' => $harga_satuan,
                    'subtotal' => $subtotal,
                ]);

                // Kurangi stok obat
                Obat::where('id_obat', $obat_id)->decrement('stok', $jumlah);
            }

            DB::commit();

            return redirect()->route('penjualan.index')->with('success', 'Penjualan berhasil disimpan.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors('Gagal menyimpan penjualan: ' . $e->getMessage())->withInput();
        }
    }

    public function show($id)
    {
        $penjualan = Penjualan::with('pelanggan', 'penjualanDetails.obat')->findOrFail($id);
        return view('penjualan.show', compact('penjualan'));
    }

    public function destroy($id)
    {
        DB::beginTransaction();
        try {
            $penjualan = Penjualan::findOrFail($id);

            // Kembalikan stok obat (jika penjualan dibatalkan)
            foreach ($penjualan->penjualanDetails as $detail) {
                Obat::where('id_obat', $detail->id_obat)->increment('stok', $detail->jumlah);
            }

            PenjualanDetail::where('id_penjualan', $penjualan->id_penjualan)->delete();
            $penjualan->delete();

            DB::commit();

            return redirect()->route('penjualan.index')->with('success', 'Data penjualan berhasil dihapus.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors('Gagal menghapus data penjualan: ' . $e->getMessage());
        }
    }
    public function faktur($id)
{
    $penjualan = Penjualan::with('pelanggan', 'penjualanDetails.obat')->findOrFail($id);
    return view('penjualan.faktur', compact('penjualan'));
}

}
