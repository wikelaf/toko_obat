@extends('layouts.app')

@section('content')
<h1 class="h3 mb-4 text-gray-800">Data Pembelian</h1>

<a href="{{ route('pembelian.create') }}" class="btn btn-primary mb-3">+ Tambah Pembelian</a>

@if(session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
@endif

@if($errors->any())
    <div class="alert alert-danger">
        <ul>@foreach($errors->all() as $error)
            <li>{{ $error }}</li>
        @endforeach</ul>
    </div>
@endif

<table class="table table-bordered table-striped">
    <thead class="thead-dark">
        <tr>
            <th>No</th>
            <th>Tanggal</th>
            <th>Pemasok</th>
            <th>Total Harga</th>
            <th>Aksi</th>
        </tr>
    </thead>
    <tbody>
    @foreach($pembelians as $no => $pembelian)
        <tr>
            <td>{{ $no + 1 }}</td>
            <td>{{ \Carbon\Carbon::parse($pembelian->tanggal)->format('d-m-Y') }}</td>
            <td>{{ $pembelian->pemasok->nama ?? '-' }}</td>
            <td>Rp {{ number_format($pembelian->total_harga,0,',','.') }}</td>
            <td>
                <a href="{{ route('pembelian.show', $pembelian->id_pembelian) }}" class="btn btn-info btn-sm">Detail</a>

                <form action="{{ route('pembelian.destroy', $pembelian->id_pembelian) }}" method="POST" style="display:inline-block;" class="form-hapus">
                        @csrf
                        @method('DELETE')
                        <button type="button" class="btn btn-sm btn-danger btn-hapus">
                            <i class="fas fa-trash"></i> Hapus
                        </button>
                    </form>
            </td>
        </tr>
    @endforeach
    </tbody>
</table>
@endsection
