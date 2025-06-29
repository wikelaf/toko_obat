@extends('layouts.app')

@section('content')
<h1 class="h3 mb-4 text-gray-800">Detail Pembelian</h1>

<a href="{{ route('pembelian.index') }}" class="btn btn-secondary mb-3">Kembali</a>

<table class="table table-bordered">
    <tr>
        <th>Tanggal</th>
        <td>{{ \Carbon\Carbon::parse($pembelian->tanggal)->format('d-m-Y') }}</td>
    </tr>
    <tr>
        <th>Pemasok</th>
        <td>{{ $pembelian->pemasok->nama ?? '-' }}</td>
    </tr>
    <tr>
        <th>Total Harga</th>
        <td>Rp {{ number_format($pembelian->total_harga,0,',','.') }}</td>
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
        </tr>
    </thead>
    <tbody>
        @foreach($pembelian->pembelianDetails as $no => $detail)
        <tr>
            <td>{{ $no + 1 }}</td>
            <td>{{ $detail->obat->nama_obat ?? '-' }}</td>
            <td>{{ $detail->jumlah }}</td>
            <td>Rp {{ number_format($detail->harga_satuan, 0, ',', '.') }}</td>
            <td>Rp {{ number_format($detail->subtotal, 0, ',', '.') }}</td>
        </tr>
        @endforeach
    </tbody>
</table>
@endsection
