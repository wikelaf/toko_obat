@extends('layouts.app')
@section('content')
<div class="container">
    <h2>Data Obat</h2>
    <a href="{{ route('obat.create') }}" class="btn btn-success mb-3">Tambah Obat</a>
    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>No</th>
                <th>Nama Obat</th>
                <th>Stok</th>
                <th>Harga Beli</th>
                <th>Harga Jual</th>
                <th>Expired Date</th>
                <th>Foto</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($obats as $obat)
            <tr>
                <td>{{ $loop->iteration }}</td>
                <td>{{ $obat->nama_obat }}</td>
                <td>{{ $obat->stok }}</td>
                <td>Rp {{ number_format($obat->harga_beli,0,',','.') }}</td>
                <td>Rp {{ number_format($obat->harga_jual,0,',','.') }}</td>
                <td>{{ $obat->expired_date }}</td>
                <td>
                    @if($obat->foto)
                        <img src="{{ asset('storage/' . $obat->foto) }}" alt="Foto Obat" width="80">
                    @else
                        -
                    @endif
                </td>
                <td>
                    <a href="{{ route('obat.edit', $obat->id_obat) }}" class="btn btn-warning btn-sm">
                    <i class="fas fa-edit"></i>
                    </a>
                    <!-- <form action="{{ route('obat.destroy', $obat->id_obat) }}" method="POST" style="display:inline-block;">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Yakin ingin menghapus?')">Hapus</button>
                    </form> -->
                    <form action="{{ route('obat.destroy', $obat->id_obat) }}" method="POST" style="display:inline-block;" class="form-hapus">
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
</div>
@endsection
