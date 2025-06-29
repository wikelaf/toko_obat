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
use App\Http\Controllers\ChangePasswordController;

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
        Route::get('/obat/laporan', [ObatController::class, 'laporan'])->name('obat.laporan');
    Route::resource('obat', ObatController::class);
        Route::get('/pelanggan/laporan', [PelangganController::class, 'laporan'])->name('pelanggan.laporan');
    Route::resource('pelanggan', PelangganController::class);
         Route::get('/pemasok/laporan', [PemasokController::class, 'laporan'])->name('pemasok.laporan');  
    Route::resource('pemasok', PemasokController::class);
        Route::get('/pembelian/laporan', [PembelianController::class, 'laporan'])->name('pembelian.laporan');
    Route::resource('pembelian', PembelianController::class);
           Route::get('/penjualan/laporan', [PenjualanController::class, 'laporan'])->name('penjualan.laporan');
    Route::resource('penjualan', PenjualanController::class);
    Route::get('/obat/harga/{id}', function ($id) {
    $obat = \App\Models\Obat::find($id);
    return response()->json(['harga_jual' => $obat ? $obat->harga_jual : 0]);
    });

    Route::get('/penjualan/faktur/{id}', [PenjualanController::class, 'faktur'])->name('penjualan.faktur');
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    Route::get('/change-password', [ChangePasswordController::class, 'index'])->name('password.change');
    Route::post('/change-password', [ChangePasswordController::class, 'update'])->name('password.update');
    Route::get('/profile', [UserController::class, 'profile'])->name('profile');
});