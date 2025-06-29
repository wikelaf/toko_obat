@extends('layouts.app')

@section('content')
<div class="container">
    <h2>Tambah Obat</h2>

    {{-- Tampilkan pesan error global jika ada --}}
    @if ($errors->any())
        <div class="alert alert-danger">
            <strong>Periksa kembali data yang Anda masukkan:</strong>
        </div>
    @endif

    <form action="{{ route('obat.store') }}" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="mb-3">
            <label for="nama_obat" class="form-label">Nama Obat</label>
            <input type="text" class="form-control @error('nama_obat') is-invalid @enderror" id="nama_obat" name="nama_obat" value="{{ old('nama_obat') }}" required>
            @error('nama_obat')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="stok" class="form-label">Stok</label>
            <input type="number" class="form-control @error('stok') is-invalid @enderror" id="stok" name="stok" value="{{ old('stok') }}" required min="0">
            @error('stok')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="harga_beli" class="form-label">Harga Beli</label>
            <input type="number" step="0.01" class="form-control @error('harga_beli') is-invalid @enderror" id="harga_beli" name="harga_beli" value="{{ old('harga_beli') }}" required min="0">
            @error('harga_beli')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="harga_jual" class="form-label">Harga Jual (otomatis)</label>
            <input type="number" step="0.01" class="form-control @error('harga_jual') is-invalid @enderror" id="harga_jual" name="harga_jual" value="{{ old('harga_jual') }}" readonly>
            @error('harga_jual')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="expired_date" class="form-label">Expired Date</label>
            <input type="date" class="form-control @error('expired_date') is-invalid @enderror" id="expired_date" name="expired_date" value="{{ old('expired_date') }}" required>
            @error('expired_date')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="foto" class="form-label">Foto (opsional)</label>
            <input type="file" class="form-control @error('foto') is-invalid @enderror" id="foto" name="foto" accept="image/*" onchange="previewFoto(event)">
            @error('foto')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror

            <img id="preview-image" class="img-thumbnail mt-2" style="display:none; max-width:150px;" alt="Preview Foto">
        </div>

        <button type="submit" class="btn btn-primary">Simpan</button>
        <a href="{{ route('obat.index') }}" class="btn btn-secondary">Batal</a>
    </form>
</div>

<script>
    function previewFoto(event) {
        const input = event.target;
        const file = input.files[0];
        const previewImage = document.getElementById('preview-image');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                previewImage.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            previewImage.src = '';
            previewImage.style.display = 'none';
        }
    }

    // Update harga jual otomatis saat harga beli diubah
    document.getElementById('harga_beli').addEventListener('input', function () {
        const hargaBeli = parseFloat(this.value);
        const hargaJualInput = document.getElementById('harga_jual');
        if (!isNaN(hargaBeli)) {
            const markup = 0.2; // 20%
            hargaJualInput.value = (hargaBeli * (1 + markup)).toFixed(2);
        } else {
            hargaJualInput.value = '';
        }
    });
</script>
@endsection
