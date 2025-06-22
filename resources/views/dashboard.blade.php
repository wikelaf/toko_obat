@extends('layouts.app')

@section('content')
<div class="container-fluid mt-4"> 
    <div class="page-inner">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h4 class="page-title mb-0">Dashboard</h4>
        </div>

        {{-- Ringkasan Data --}}
        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow border-left-primary">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Obat</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">{{ $totalObat }}</div>
                        </div>
                        <i class="fas fa-capsules fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow border-left-success">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total Pelanggan</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">{{ $totalPelanggan }}</div>
                        </div>
                        <i class="fas fa-users fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow border-left-info">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Total Pemasok</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">{{ $totalPemasok }}</div>
                        </div>
                        <i class="fas fa-truck fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>

        {{-- Quick Actions --}}
        <div class="row">
            <div class="col-md-6">
                <a href="{{ route('pembelian.create') }}" class="btn btn-outline-primary btn-block">
                    <i class="fas fa-cart-plus"></i> Tambah Pembelian
                </a>
            </div>
            <div class="col-md-6">
                <a href="{{ route('penjualan.create') }}" class="btn btn-outline-success btn-block">
                    <i class="fas fa-cash-register"></i> Tambah Penjualan
                </a>
            </div>
        </div>

        {{-- Welcome Message --}}
        <div class="card mt-4">
            <div class="card-header bg-light">
                <h5 class="mb-0">Selamat Datang</h5>
            </div>
            <div class="card-body">
                <p>Selamat datang di <strong>Sistem Informasi Toko Obat Abadi</strong>. Gunakan menu navigasi untuk mengelola data, transaksi pembelian dan penjualan obat. Pastikan stok selalu terpantau dan data selalu akurat.</p>
            </div>
        </div>
    </div>
</div>
@endsection
