<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pembelian;
use App\Models\PembelianDetail;
use App\Models\Obat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PembelianController extends Controller
{
    public function index()
    {
        $pembelian = Pembelian::with('pemasok', 'pembelianDetails.obat')->orderBy('tanggal', 'desc')->get();
        return response()->json($pembelian, 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'id_pemasok' => 'required|exists:pemasoks,id_pemasok',
            'tanggal' => 'required|date',
            'id_obat' => 'required|array|min:1',
            'id_obat.*' => 'required|exists:obats,id_obat',
            'jumlah' => 'required|array|min:1',
            'jumlah.*' => 'required|integer|min:1',
            'harga_satuan' => 'required|array|min:1',
            'harga_satuan.*' => 'required|numeric|min:0',
        ]);

        DB::beginTransaction();

        try {
            $total = 0;
            foreach ($request->jumlah as $i => $qty) {
                $total += $qty * $request->harga_satuan[$i];
            }

            $pembelian = Pembelian::create([
                'tanggal' => $request->tanggal,
                'id_pemasok' => $request->id_pemasok,
                'total_harga' => $total
            ]);

            foreach ($request->id_obat as $i => $id_obat) {
                $jumlah = $request->jumlah[$i];
                $harga = $request->harga_satuan[$i];
                $subtotal = $jumlah * $harga;

                PembelianDetail::create([
                    'id_pembelian' => $pembelian->id_pembelian,
                    'id_obat' => $id_obat,
                    'jumlah' => $jumlah,
                    'harga_satuan' => $harga,
                    'subtotal' => $subtotal,
                ]);

                // Update stok dan harga obat
                $obat = Obat::find($id_obat);
                if ($obat) {
                    $obat->stok += $jumlah;
                    $obat->harga_beli = $harga;
                    $obat->harga_jual = round($harga * 1.2, 2); // markup 20%
                    $obat->save();
                }
            }

            DB::commit();

            // ambil ulang data dengan relasi untuk ditampilkan
            $data = Pembelian::with('pemasok', 'pembelianDetails.obat')->find($pembelian->id_pembelian);

            return response()->json([
                'message' => 'Pembelian berhasil ditambahkan',
                'data' => $data
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        $pembelian = Pembelian::with('pemasok', 'pembelianDetails.obat')->find($id);
        if (!$pembelian) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }
        return response()->json($pembelian, 200);
    }

    public function destroy($id)
    {
        $pembelian = Pembelian::find($id);
        if (!$pembelian) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        DB::beginTransaction();
        try {
            // Kurangi stok obat
            foreach ($pembelian->pembelianDetails as $detail) {
                Obat::where('id_obat', $detail->id_obat)->decrement('stok', $detail->jumlah);
            }

            PembelianDetail::where('id_pembelian', $pembelian->id_pembelian)->delete();
            $pembelian->delete();

            DB::commit();

            return response()->json(['message' => 'Data berhasil dihapus'], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Gagal menghapus: ' . $e->getMessage()], 500);
        }
    }
}
