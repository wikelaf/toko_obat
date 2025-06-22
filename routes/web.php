<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ObatController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\PelangganController;
use App\Http\Controllers\PemasokController;
use App\Http\Controllers\PembelianController;
use App\Http\Controllers\PenjualanController;
use App\Http\Controllers\DashboardController;

// Route::get('/', function () {
//     return view('welcome');
// });
// Route::get('/', function () {
//     return view('dashboard'); // arahkan ke tampilan dashboard
// })->name('dashboard');

Route::get('/', function () {
    return redirect()->route('login');
});

// Route login
Route::get('/login', [LoginController::class, 'showLoginForm'])->name('login');
Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

Route::middleware(['auth'])->group(function () {
    Route::resource('user', UserController::class);
    Route::resource('obat', ObatController::class);
    Route::resource('pelanggan', PelangganController::class);
    Route::resource('pemasok', PemasokController::class);
    Route::resource('pembelian', PembelianController::class);
    Route::resource('penjualan', PenjualanController::class);
    Route::get('/obat/harga/{id}', function ($id) {
    $obat = \App\Models\Obat::find($id);
    return response()->json(['harga_jual' => $obat ? $obat->harga_jual : 0]);
});

    Route::get('/penjualan/faktur/{id}', [PenjualanController::class, 'faktur'])->name('penjualan.faktur');
    // Route::get('/dashboard', function () {
    //     return view('dashboard');
    // })->name('dashboard');
    // Route lain yang hanya boleh diakses setelah login
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

});