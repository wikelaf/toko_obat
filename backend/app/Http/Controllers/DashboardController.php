<?php

namespace App\Http\Controllers;

use App\Models\Obat;
use App\Models\Pelanggan;
use App\Models\Pemasok;
use App\Models\User;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        $totalObat = Obat::count();
        $totalPelanggan = Pelanggan::count();
        $totalPemasok = Pemasok::count();
        $totalUser = User::count();


        return view('dashboard', compact(
            'totalObat',
            'totalPelanggan',
            'totalPemasok',
            'totalUser'
        ));
    }
}
