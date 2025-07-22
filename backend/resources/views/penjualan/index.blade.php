@extends('layouts.app')

@section('content')
<h1 class="h3 mb-4 text-gray-800">Data Penjualan</h1>

<a href="{{ route('penjualan.create') }}" class="btn btn-primary mb-3">+ Tambah Penjualan</a>

@if(session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
@endif

@if($errors->any())
    <div class="alert alert-danger">
        <ul>
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<table class="table table-bordered table-striped">
    <thead class="thead-dark">
        <tr>
            <th>No</th>
            <th>Tanggal & Jam</th>
            <th>Pelanggan</th>
            <th>Total Harga</th>
            <th>Aksi</th>
        </tr>
    </thead>
    <tbody>
        @foreach($penjualans as $no => $penjualan)
            <tr>
                <td>{{ $no + 1 }}</td>
                <td>{{ \Carbon\Carbon::parse($penjualan->tanggal)->format('d-m-Y H:i:s') }}</td>
                <td>{{ $penjualan->pelanggan->nama ?? '-' }}</td>
                <td>Rp {{ number_format($penjualan->total_harga, 0, ',', '.') }}</td>
                <td>
                    <a href="{{ route('penjualan.show', $penjualan->id_penjualan) }}" class="btn btn-info btn-sm">
                        <i class="fas fa-search"></i>
                    </a>
                    <a href="{{ route('penjualan.faktur', $penjualan->id_penjualan) }}" class="btn btn-secondary btn-sm" target="_blank">
                        <i class="fas fa-clipboard-list"></i>
                    </a>
                    <form action="{{ route('penjualan.destroy', $penjualan->id_penjualan) }}" method="POST" style="display:inline-block;" class="form-hapus">
                        @csrf
                        @method('DELETE')
                        <button type="button" class="btn btn-sm btn-danger btn-hapus">
                            <i class="fas fa-trash"></i> 
                        </button>
                    </form>
                </td>
            </tr>
        @endforeach
    </tbody>
</table>
@endsection
