<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ObatController;
use App\Http\Controllers\PelangganController;
use App\Http\Controllers\PemasokController;
use App\Http\Controllers\PembelianController;
use App\Http\Controllers\PenjualanController;
use App\Http\Controllers\Api\LoginController;



Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('obat', App\Http\Controllers\Api\ObatController::class);
Route::apiResource('pelanggan', App\Http\Controllers\Api\PelangganController::class);
Route::apiResource('pemasok', App\Http\Controllers\Api\PemasokController::class);
Route::apiResource('pembelian', App\Http\Controllers\Api\PembelianController::class);
Route::apiResource('penjualan', App\Http\Controllers\Api\PenjualanController::class);

Route::post('/login', [LoginController::class, 'login']);
Route::middleware('auth:sanctum')->post('/logout', [LoginController::class, 'logout']);







