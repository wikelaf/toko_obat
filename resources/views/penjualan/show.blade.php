@extends('layouts.app')

@section('content')
<h1 class="h3 mb-4 text-gray-800">Detail Penjualan</h1>

<a href="{{ route('penjualan.index') }}" class="btn btn-secondary mb-3">Kembali</a>

<table class="table table-bordered">
    <tr>
        <th>Tanggal</th>
        <td>{{ \Carbon\Carbon::parse($penjualan->tanggal)->format('d-m-Y') }}</td>
    </tr>
    <tr>
        <th>Pelanggan</th>
        <td>{{ $penjualan->pelanggan->nama ?? '-' }}</td>
    </tr>
    <tr>
        <th>Total Harga</th>
        <td>Rp {{ number_format($penjualan->total_harga,0,',','.') }}</td>
    </tr>
</table>

<h5>Detail Obat</h5>
<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>No</th>
            <th>Nama Obat</th>
            <th>Jumlah</th>
            <th>Harga Satuan</th>
            <th>Subtotal</th>
            <th>Bayar</th>
            <th>Kembalian</th>

            
        </tr>
    </thead>
    <tbody>
        @foreach($penjualan->penjualanDetails as $no => $detail)
        <tr>
            <td>{{ $no + 1 }}</td>
            <td>{{ $detail->obat->nama_obat ?? '-' }}</td>
            <td>{{ $detail->jumlah }}</td>
            <td>Rp {{ number_format($detail->harga_satuan, 0, ',', '.') }}</td>
            <td>Rp {{ number_format($detail->subtotal, 0, ',', '.') }}</td>
            <td>Rp {{ number_format($penjualan->bayar, 0, ',', '.') }}</td>
            <td>Rp {{ number_format($penjualan->kembalian, 0, ',', '.') }}</td>
        </tr>
        @endforeach
    </tbody>
</table>
@endsection
