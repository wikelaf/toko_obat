@extends('layouts.app')
@section('content')
<div class="container">
    <h2>Data Pemasok</h2>
    <a href="{{ route('pemasok.create') }}" class="btn btn-success mb-3">Tambah Pemasok</a>
    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>No</th>
                <th>Nama</th>
                <th>Alamat</th>
                <th>Telepon</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($pemasoks as $pemasok)
            <tr>
                <td>{{ $loop->iteration }}</td>
                <td>{{ $pemasok->nama }}</td>
                <td>{{ $pemasok->alamat }}</td>
                <td>{{ $pemasok->telepon }}</td>
                <td>
                    <a href="{{ route('pemasok.edit', $pemasok->id_pemasok) }}" class="btn btn-warning btn-sm">Edit</a>
                    <!-- <form action="{{ route('pemasok.destroy', $pemasok->id_pemasok) }}" method="POST" style="display:inline-block;">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Yakin ingin menghapus?')">Hapus</button>
                    </form> -->
                    <form action="{{ route('pemasok.destroy', $pemasok->id_pemasok) }}" method="POST" style="display:inline-block;" class="form-hapus">
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
</div>
@endsection
