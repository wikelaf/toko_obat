@extends('layouts.app')

@section('content')
<div class="container">
    <h2>Ganti Password</h2>

    @if (session('status'))
        <div class="alert alert-success">{{ session('status') }}</div>
    @endif

    <form method="POST" action="{{ route('password.update') }}">
        @csrf

        <div class="form-group">
            <label>Password Saat Ini</label>
            <input type="password" name="current_password" class="form-control">
            @error('current_password') <small class="text-danger">{{ $message }}</small> @enderror
        </div>

        <div class="form-group">
            <label>Password Baru</label>
            <input type="password" name="new_password" class="form-control">
            @error('new_password') <small class="text-danger">{{ $message }}</small> @enderror
        </div>

        <div class="form-group">
            <label>Konfirmasi Password Baru</label>
            <input type="password" name="new_password_confirmation" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary mt-3">Ubah Password</button>
    </form>
</div>
@endsection
