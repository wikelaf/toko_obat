@extends('layouts.app')

@section('content')
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Profil Saya</h4>
                </div>

                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label font-weight-bold">Nama Lengkap</label>
                        <p class="form-control-plaintext">{{ $user->name }}</p>
                    </div>

                    <div class="mb-3">
                        <label class="form-label font-weight-bold">Email</label>
                        <p class="form-control-plaintext">{{ $user->email }}</p>
                    </div>

                    <!-- Contoh tambahan info -->
                    {{-- 
                    <div class="mb-3">
                        <label class="form-label font-weight-bold">No. Telepon</label>
                        <p class="form-control-plaintext">{{ $user->phone ?? '-' }}</p>
                    </div>
                    --}}

                    <a href="{{ route('user.edit', $user->id) }}" class="btn btn-outline-primary">
                        <i class="fas fa-edit"></i> Edit Profil
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>
@endsection
