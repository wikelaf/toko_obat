<?php

namespace App\Http\Controllers;

use App\Models\Pembelian;
use App\Models\PembelianDetail;
use App\Models\Pemasok;
use App\Models\Obat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PembelianController extends Controller
{
    public function index()
    {
        // Ambil semua pembelian dengan relasi pemasok, urut terbaru
        $pembelians = Pembelian::with('pemasok')->orderBy('tanggal', 'desc')->get();
        return view('pembelian.index', compact('pembelians'));
    }

    public function create()
    {
        $pemasoks = Pemasok::all();
        $obats = Obat::all();
        return view('pembelian.create', compact('pemasoks', 'obats'));
    }

    public function store(Request $request)
    {
        // Validasi input
        $request->validate([
            'tanggal' => 'required|date',
            'id_pemasok' => 'required|exists:pemasoks,id_pemasok',
            'obat_id' => 'required|array',
            'obat_id.*' => 'required|exists:obats,id_obat',
            'jumlah' => 'required|array',
            'jumlah.*' => 'required|integer|min:1',
            'harga_satuan' => 'required|array',
            'harga_satuan.*' => 'required|numeric|min:0',
        ]);

        DB::beginTransaction();

        try {
            // Hitung total harga pembelian
            $total_harga = 0;
            foreach ($request->jumlah as $key => $jumlah) {
                $harga_satuan = $request->harga_satuan[$key];
                $subtotal = $jumlah * $harga_satuan;
                $total_harga += $subtotal;
            }

            // Simpan data pembelian
            $pembelian = Pembelian::create([
                'tanggal' => $request->tanggal,
                'id_pemasok' => $request->id_pemasok,
                'total_harga' => $total_harga,
            ]);

            // Simpan detail pembelian & update stok obat
            foreach ($request->obat_id as $key => $obat_id) {
                $jumlah = $request->jumlah[$key];
                $harga_satuan = $request->harga_satuan[$key];
                $subtotal = $jumlah * $harga_satuan;

                PembelianDetail::create([
                    'id_pembelian' => $pembelian->id_pembelian,
                    'id_obat' => $obat_id,
                    'jumlah' => $jumlah,
                    'harga_satuan' => $harga_satuan,
                    'subtotal' => $subtotal,
                ]);

                 // Update stok obat
                $obat = Obat::find($obat_id);
                if ($obat) {
                    $obat->stok += $jumlah;
                    $obat->harga_beli = $harga_satuan;

                    // Otomatis update harga jual (misal 20% dari harga beli)
                    $markup = 0.20; // 20%
                    $obat->harga_jual = round($harga_satuan * (1 + $markup), 2);

                    $obat->save();
                }
            }

            DB::commit();

            return redirect()->route('pembelian.index')->with('success', 'Pembelian berhasil disimpan.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors('Gagal menyimpan pembelian: ' . $e->getMessage())->withInput();
        }
    }

    public function show($id)
    {
        $pembelian = Pembelian::with('pemasok', 'pembelianDetails.obat')->findOrFail($id);
        return view('pembelian.show', compact('pembelian'));
    }

    public function destroy($id)
    {
        DB::beginTransaction();
        try {
            $pembelian = Pembelian::findOrFail($id);

            // Kembalikan stok obat
            foreach ($pembelian->pembelianDetails as $detail) {
                Obat::where('id_obat', $detail->id_obat)->decrement('stok', $detail->jumlah);
            }

            // Hapus detail dan pembelian
            PembelianDetail::where('id_pembelian', $pembelian->id_pembelian)->delete();
            $pembelian->delete();

            DB::commit();

            return redirect()->route('pembelian.index')->with('success', 'Data pembelian berhasil dihapus.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors('Gagal menghapus data pembelian: ' . $e->getMessage());
        }
    }

    
public function laporan(Request $request)
{
    $periode = $request->periode;

    if (in_array($periode, ['hari', 'bulan', 'tahun'])) {
        // Tampilan ringkasan
        $pembelians = Pembelian::selectRaw(
                $periode === 'hari' ? 'DATE(tanggal) as periode' :
                ($periode === 'bulan' ? "DATE_FORMAT(tanggal, '%Y-%m') as periode" :
                "YEAR(tanggal) as periode")
            )
            ->selectRaw('SUM(total_harga) as total')
            ->when($request->start_date, fn($q) => $q->whereDate('tanggal', '>=', $request->start_date))
            ->when($request->end_date, fn($q) => $q->whereDate('tanggal', '<=', $request->end_date))
            ->when($request->id_pemasok, fn($q) => $q->where('id_pemasok', $request->id_pemasok))
            ->groupBy('periode')
            ->orderBy('periode', 'desc')
            ->get();
    } else {
        // Tampilan detail
        $pembelians = Pembelian::with(['pemasok', 'pembelianDetails.obat'])
            ->when($request->start_date, fn($q) => $q->whereDate('tanggal', '>=', $request->start_date))
            ->when($request->end_date, fn($q) => $q->whereDate('tanggal', '<=', $request->end_date))
            ->when($request->id_pemasok, fn($q) => $q->where('id_pemasok', $request->id_pemasok))
            ->orderBy('tanggal', 'desc')
            ->get();
    }

    $pemasoks = Pemasok::all();

    return view('pembelian.laporan', compact('pembelians', 'pemasoks'));
}

}
