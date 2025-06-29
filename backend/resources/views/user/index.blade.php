<!-- filepath: resources/views/user/index.blade.php -->
@extends('layouts.app')

@section('content')
<div class="row">
    <div class="col-lg-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary">Daftar User</h6>
                <a href="{{ route('user.create') }}" class="btn btn-primary btn-sm">Tambah User</a>
            </div>
            <div class="card-body">
                @if(session('success'))
                    <div class="alert alert-success">{{ session('success') }}</div>
                @endif
                <div class="table-responsive">
                    <table class="table table-bordered" width="100%" cellspacing="0">
                        <thead class="thead-light">
                            <tr>
                                <th>No</th>
                                <th>Nama</th>
                                <th>Email</th>
                                <th>Dibuat</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($users as $no => $user)
                            <tr>
                                <td>{{ $no + 1 }}</td>
                                <td>{{ $user->name }}</td>
                                <td>{{ $user->email }}</td>
                                <td>{{ $user->created_at->format('d-m-Y') }}</td>
                                <td>
                                    <a href="{{ route('user.edit', $user->id) }}" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i></a>
                                    <!-- <form action="{{ route('user.destroy', $user->id) }}" method="POST" class="d-inline">
                                        @csrf @method('DELETE')
                                        <button class="btn btn-danger btn-sm" onclick="return confirm('Yakin hapus user ini?')">Hapus</button>
                                    </form> -->
                                    <form action="{{ route('user.destroy', $user->id) }}" method="POST" style="display:inline-block;" class="form-hapus">
                                @csrf
                                @method('DELETE')
                                <button type="button" class="btn btn-sm btn-danger btn-hapus">
                                    <i class="fas fa-trash"></i> 
                                </button>
                            </form>
                                </td>
                            </tr>
                            @empty
                            <tr>
                                <td colspan="5" class="text-center">Tidak ada data user</td>
                            </tr>
                            @endforelse
                        </tbody>
                    </table>
                    {{-- Jika pakai pagination, tambahkan: --}}
                    {{-- {{ $users->links() }} --}}
                </div>
            </div>
        </div>
    </div>
</div>
@endsection