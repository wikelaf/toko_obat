<?php

namespace App\Http\Controllers;

use App\Models\Obat;
use App\Models\Pelanggan;
use App\Models\Pemasok;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        $totalObat = Obat::count();
        $totalPelanggan = Pelanggan::count();
        $totalPemasok = Pemasok::count();

        return view('dashboard', compact(
            'totalObat',
            'totalPelanggan',
            'totalPemasok'
        ));
    }
}
