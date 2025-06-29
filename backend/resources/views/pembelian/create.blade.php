@extends('layouts.app')

@section('content')
<div class="container">
    <h3>Tambah Pembelian Obat</h3>

    @if ($errors->any())
        <div class="alert alert-danger">
            <ul>@foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach</ul>
        </div>
    @endif

    <form action="{{ route('pembelian.store') }}" method="POST">
        @csrf

        <div class="mb-3">
            <label for="tanggal">Tanggal</label>
            <input type="date" name="tanggal" value="{{ old('tanggal', date('Y-m-d')) }}" class="form-control" required max="{{ date('Y-m-d') }}">

        </div>

        <div class="mb-3">
            <label for="id_pemasok">Pemasok</label>
            <select name="id_pemasok" class="form-control" required>
                <option value="">-- Pilih Pemasok --</option>
                @foreach($pemasoks as $pemasok)
                    <option value="{{ $pemasok->id_pemasok }}" {{ old('id_pemasok') == $pemasok->id_pemasok ? 'selected' : '' }}>
                        {{ $pemasok->nama }}
                    </option>
                @endforeach
            </select>
        </div>

        <hr>
        <h5>Detail Obat</h5>

        <div id="detail-obat">
            <div class="row mb-2">
                <div class="col-md-4">
                    <select name="obat_id[]" class="form-control obat-select" required>
                        <option value="">-- Pilih Obat --</option>
                        @foreach($obats as $obat)
                            <option value="{{ $obat->id_obat }}">{{ $obat->nama_obat }}</option>
                        @endforeach
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="number" name="jumlah[]" class="form-control" placeholder="Jumlah" required min="1" value="{{ old('jumlah.0') }}">
                </div>
                <div class="col-md-3">
                    <input type="number" step="0.01" name="harga_satuan[]" class="form-control harga-satuan" placeholder="Harga Satuan" required min="0" value="{{ old('harga_satuan.0') }}">
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn btn-danger remove-detail">Hapus</button>
                </div>
            </div>
        </div>

        <button type="button" class="btn btn-secondary mb-3" id="tambah-detail">+ Tambah Obat</button>

        <div class="mb-3">
            <button type="submit" class="btn btn-primary">Simpan</button>
            <a href="{{ route('pembelian.index') }}" class="btn btn-secondary">Kembali</a>
        </div>
    </form>
</div>

<script>
    // Buat objek harga obat dari data server
    const hargaObat = {
        @foreach($obats as $obat)
            "{{ $obat->id_obat }}": {{ $obat->harga_beli ?? 0 }},
        @endforeach
    };

    // Fungsi update harga saat obat dipilih
    function updateHargaSatuan(selectEl) {
        const row = selectEl.closest('.row');
        const hargaInput = row.querySelector('.harga-satuan');
        const selectedObatId = selectEl.value;
        if (selectedObatId && hargaObat[selectedObatId] !== undefined) {
            hargaInput.value = hargaObat[selectedObatId];
        } else {
            hargaInput.value = '';
        }
    }

    // Event listener untuk pilihan obat pertama dan yang baru ditambah
    document.querySelectorAll('.obat-select').forEach(select => {
        select.addEventListener('change', function () {
            updateHargaSatuan(this);
        });
    });

    // Tambah baris detail obat baru
    document.getElementById('tambah-detail').addEventListener('click', function () {
        const row = `
        <div class="row mb-2">
            <div class="col-md-4">
                <select name="obat_id[]" class="form-control obat-select" required>
                    <option value="">-- Pilih Obat --</option>
                    @foreach($obats as $obat)
                        <option value="{{ $obat->id_obat }}">{{ $obat->nama_obat }}</option>
                    @endforeach
                </select>
            </div>
            <div class="col-md-2">
                <input type="number" name="jumlah[]" class="form-control" placeholder="Jumlah" required min="1">
            </div>
            <div class="col-md-3">
                <input type="number" step="0.01" name="harga_satuan[]" class="form-control harga-satuan" placeholder="Harga Satuan" required min="0">
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-danger remove-detail">Hapus</button>
            </div>
        </div>`;
        document.getElementById('detail-obat').insertAdjacentHTML('beforeend', row);

        // Pasang event listener pada select yang baru ditambahkan
        const newSelect = document.querySelector('#detail-obat .row:last-child .obat-select');
        newSelect.addEventListener('change', function () {
            updateHargaSatuan(this);
        });
    });

    // Event untuk tombol hapus detail
    document.addEventListener('click', function (e) {
        if (e.target && e.target.classList.contains('remove-detail')) {
            e.target.closest('.row').remove();
        }
    });
</script>
@endsection
