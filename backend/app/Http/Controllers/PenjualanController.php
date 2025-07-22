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

    // public function store(Request $request)
    // {
    //     $request->validate([
    //         'tanggal' => 'required|date',
    //         'id_pelanggan' => 'required|exists:pelanggans,id_pelanggan',
    //         'obat_id' => 'required|array',
    //         'obat_id.*' => 'required|exists:obats,id_obat',
    //         'jumlah' => 'required|array',
    //         'jumlah.*' => 'required|integer|min:1',
    //         'harga_satuan' => 'required|array',
    //         'harga_satuan.*' => 'required|numeric|min:0',
    //         'bayar' => 'required|numeric|min:0',
    //         'kembalian' => 'required|numeric|min:0',
    //     ]);

    //     DB::beginTransaction();

    //     try {
    //         $total_harga = 0;
    //         foreach ($request->jumlah as $key => $jumlah) {
    //             $harga_satuan = $request->harga_satuan[$key];
    //             $subtotal = $jumlah * $harga_satuan;
    //             $total_harga += $subtotal;
    //         }

    //         // Optional: cek apakah bayar cukup
    //         if ($request->bayar < $total_harga) {
    //             return back()->withErrors('Jumlah bayar kurang dari total harga')->withInput();
    //         }

    //         $penjualan = Penjualan::create([
    //             'tanggal' => $request->tanggal,
    //             'id_pelanggan' => $request->id_pelanggan,
    //             'total_harga' => $total_harga,
    //             'bayar' => $request->bayar,
    //             'kembalian' => $request->kembalian,
    //         ]);

    //         foreach ($request->obat_id as $key => $obat_id) {
    //             $jumlah = $request->jumlah[$key];
    //             $harga_satuan = $request->harga_satuan[$key];
    //             $subtotal = $jumlah * $harga_satuan;

    //             PenjualanDetail::create([
    //                 'id_penjualan' => $penjualan->id_penjualan,
    //                 'id_obat' => $obat_id,
    //                 'jumlah' => $jumlah,
    //                 'harga_satuan' => $harga_satuan,
    //                 'subtotal' => $subtotal,
    //             ]);

    //             // Kurangi stok obat
    //             Obat::where('id_obat', $obat_id)->decrement('stok', $jumlah);
    //         }

    //         DB::commit();

    //         return redirect()->route('penjualan.index')->with('success', 'Penjualan berhasil disimpan.');
    //     } catch (\Exception $e) {
    //         DB::rollBack();
    //         return back()->withErrors('Gagal menyimpan penjualan: ' . $e->getMessage())->withInput();
    //     }
    // }
    public function store(Request $request)
{
    $request->validate([
        // 'tanggal' => 'required|date', // baris ini DIHAPUS karena kita pakai now()
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

        // SIMPAN TANGGAL DAN JAM OTOMATIS
        $penjualan = Penjualan::create([
            'tanggal' => now(), // menyimpan tanggal dan waktu saat ini
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


public function laporan(Request $request)
{
    $query = Penjualan::with(['pelanggan', 'penjualanDetails.obat']);

    // Filter tanggal
    if ($request->start_date) {
        $query->whereDate('tanggal', '>=', $request->start_date);
    }
    if ($request->end_date) {
        $query->whereDate('tanggal', '<=', $request->end_date);
    }

    // Filter pelanggan
    if ($request->id_pelanggan) {
        $query->where('id_pelanggan', $request->id_pelanggan);
    }

    $periode = $request->periode;

    if ($periode == 'hari') {
        $penjualans = Penjualan::selectRaw('DATE(tanggal) as periode, SUM(total_harga) as total')
            ->when($request->start_date, fn($q) => $q->whereDate('tanggal', '>=', $request->start_date))
            ->when($request->end_date, fn($q) => $q->whereDate('tanggal', '<=', $request->end_date))
            ->when($request->id_pelanggan, fn($q) => $q->where('id_pelanggan', $request->id_pelanggan))
            ->groupByRaw('DATE(tanggal)')
            ->orderBy('periode', 'desc')
            ->get();
    } elseif ($periode == 'bulan') {
        $penjualans = Penjualan::selectRaw("DATE_FORMAT(tanggal, '%Y-%m') as periode, SUM(total_harga) as total")
            ->when($request->start_date, fn($q) => $q->whereDate('tanggal', '>=', $request->start_date))
            ->when($request->end_date, fn($q) => $q->whereDate('tanggal', '<=', $request->end_date))
            ->when($request->id_pelanggan, fn($q) => $q->where('id_pelanggan', $request->id_pelanggan))
            ->groupByRaw("DATE_FORMAT(tanggal, '%Y-%m')")
            ->orderBy('periode', 'desc')
            ->get();
    } elseif ($periode == 'tahun') {
        $penjualans = Penjualan::selectRaw("YEAR(tanggal) as periode, SUM(total_harga) as total")
            ->when($request->start_date, fn($q) => $q->whereDate('tanggal', '>=', $request->start_date))
            ->when($request->end_date, fn($q) => $q->whereDate('tanggal', '<=', $request->end_date))
            ->when($request->id_pelanggan, fn($q) => $q->where('id_pelanggan', $request->id_pelanggan))
            ->groupByRaw("YEAR(tanggal)")
            ->orderBy('periode', 'desc')
            ->get();
    } else {
        $penjualans = $query->orderBy('tanggal', 'desc')->get();
    }

    // Kirim data pelanggan untuk filter
    $pelanggans = Pelanggan::all();

    return view('penjualan.laporan', compact('penjualans', 'pelanggans'));
}
}
