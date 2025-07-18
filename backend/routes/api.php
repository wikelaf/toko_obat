<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ObatController;
use App\Http\Controllers\Api\PelangganController;
use App\Http\Controllers\Api\PemasokController;
use App\Http\Controllers\Api\PembelianController;
use App\Http\Controllers\Api\PenjualanController;
use App\Http\Controllers\Api\LoginController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\ChangePasswordController;



Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('obat', App\Http\Controllers\Api\ObatController::class);
Route::apiResource('pelanggan', App\Http\Controllers\Api\PelangganController::class);
Route::apiResource('pemasok', App\Http\Controllers\Api\PemasokController::class);
Route::apiResource('pembelian', App\Http\Controllers\Api\PembelianController::class);
Route::apiResource('penjualan', App\Http\Controllers\Api\PenjualanController::class);
Route::apiResource('user', App\Http\Controllers\Api\UserController::class);

Route::post('/login', [LoginController::class, 'login']);
Route::middleware('auth:sanctum')->post('/logout', [LoginController::class, 'logout']);

// Pelanggan login/register/logout
Route::post('/register-pelanggan', [LoginController::class, 'registerPelanggan']);
Route::post('/login-pelanggan', [LoginController::class, 'loginPelanggan']);
Route::middleware('auth:sanctum')->post('/logout-pelanggan', [LoginController::class, 'logoutPelanggan']);

Route::middleware('auth:sanctum')->put('/change-password-user', [ChangePasswordController::class, 'updateUser']);
Route::middleware('auth:pelanggan-api')->put('/change-password', [ChangePasswordController::class, 'updatePelanggan']);
Route::get('/penjualan/pelanggan/{id}', [PenjualanController::class, 'riwayatByPelanggan']);






