<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Penjualan;
use App\Models\PenjualanDetail;
use App\Models\Obat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PenjualanController extends Controller
{
    public function index()
    {
        $penjualan = Penjualan::with('pelanggan', 'penjualanDetails.obat')->orderBy('tanggal', 'desc')->get();
        return response()->json($penjualan, 200);
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
                $harga = $request->harga_satuan[$key];
                $total_harga += $jumlah * $harga;
            }

            if ($request->bayar < $total_harga) {
                return response()->json(['message' => 'Jumlah bayar kurang dari total harga'], 400);
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
                $harga = $request->harga_satuan[$key];
                $subtotal = $jumlah * $harga;

                PenjualanDetail::create([
                    'id_penjualan' => $penjualan->id_penjualan,
                    'id_obat' => $obat_id,
                    'jumlah' => $jumlah,
                    'harga_satuan' => $harga,
                    'subtotal' => $subtotal,
                ]);

                // Kurangi stok
                Obat::where('id_obat', $obat_id)->decrement('stok', $jumlah);
            }

            DB::commit();

            // ambil data lengkap untuk respon
            $data = Penjualan::with('pelanggan', 'penjualanDetails.obat')->find($penjualan->id_penjualan);

            return response()->json([
                'message' => 'Penjualan berhasil disimpan',
                'data' => $data
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        $penjualan = Penjualan::with('pelanggan', 'penjualanDetails.obat')->find($id);
        if (!$penjualan) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }
        return response()->json($penjualan, 200);
    }

    public function destroy($id)
    {
        $penjualan = Penjualan::with('penjualanDetails')->find($id);
        if (!$penjualan) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        DB::beginTransaction();
        try {
            // Kembalikan stok
            foreach ($penjualan->penjualanDetails as $detail) {
                Obat::where('id_obat', $detail->id_obat)->increment('stok', $detail->jumlah);
            }

            PenjualanDetail::where('id_penjualan', $penjualan->id_penjualan)->delete();
            $penjualan->delete();

            DB::commit();
            return response()->json(['message' => 'Data berhasil dihapus'], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Gagal menghapus: ' . $e->getMessage()], 500);
        }
    }
}
