@extends('layouts.app')

@section('content')
<div class="container">
    <h3>Tambah Penjualan Obat</h3>

    @if ($errors->any())
        <div class="alert alert-danger">
            <ul>@foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach</ul>
        </div>
    @endif

    <form action="{{ route('penjualan.store') }}" method="POST" id="form-penjualan">
        @csrf

        <div class="mb-3">
            <label for="tanggal">Tanggal</label>
            <input type="date" name="tanggal" value="{{ old('tanggal', date('Y-m-d')) }}" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="id_pelanggan">Pelanggan</label>
            <select name="id_pelanggan" class="form-control" required>
                <option value="">-- Pilih Pelanggan --</option>
                @foreach($pelanggans as $pelanggan)
                    <option value="{{ $pelanggan->id_pelanggan }}" {{ old('id_pelanggan') == $pelanggan->id_pelanggan ? 'selected' : '' }}>
                        {{ $pelanggan->nama }}
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
                    <input type="number" name="jumlah[]" class="form-control jumlah-input" placeholder="Jumlah" required min="1" value="{{ old('jumlah.0') }}">
                </div>
                <div class="col-md-3">
                    <input type="number" step="0.01" name="harga_satuan[]" class="form-control harga-satuan" placeholder="Harga Satuan" required min="0" readonly value="{{ old('harga_satuan.0') }}">
                </div>
                <div class="col-md-3">
                    <input type="number" step="0.01" class="form-control subtotal" placeholder="Subtotal" readonly>
                </div>
                <div class="col-md-1">
                    <button type="button" class="btn btn-danger remove-detail">Hapus</button>
                </div>
            </div>
        </div>

        <button type="button" class="btn btn-secondary mb-3" id="tambah-detail">+ Tambah Obat</button>

        <hr>

        <div class="mb-3 row">
            <label for="total_harga" class="col-sm-2 col-form-label font-weight-bold">Total Harga</label>
            <div class="col-sm-4">
                <input type="number" step="0.01" name="total_harga" id="total_harga" class="form-control" readonly value="{{ old('total_harga', 0) }}">
            </div>
        </div>

        <div class="mb-3 row">
            <label for="bayar" class="col-sm-2 col-form-label">Bayar</label>
            <div class="col-sm-4">
                <input type="number" step="0.01" name="bayar" id="bayar" class="form-control" required min="0" value="{{ old('bayar', 0) }}">
            </div>
        </div>

        <div class="mb-3 row">
            <label for="kembalian" class="col-sm-2 col-form-label font-weight-bold">Kembalian</label>
            <div class="col-sm-4">
                <input type="number" step="0.01" name="kembalian" id="kembalian" class="form-control" readonly value="{{ old('kembalian', 0) }}">
            </div>
        </div>

        <div class="mb-3">
            <button type="submit" class="btn btn-primary">Simpan</button>
            <a href="{{ route('penjualan.index') }}" class="btn btn-secondary">Kembali</a>
        </div>
    </form>
</div>

{{-- Load jQuery --}}
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
$(document).ready(function() {

    function updateHargaJual(selectObat) {
        let obatId = selectObat.val();
        let hargaInput = selectObat.closest('.row').find('.harga-satuan');

        if (obatId) {
            $.ajax({
                url: '/obat/harga/' + obatId,
                type: 'GET',
                success: function(response) {
                    hargaInput.val(response.harga_jual);
                    updateSubtotal(hargaInput);
                    updateTotalHarga();
                },
                error: function() {
                    hargaInput.val('');
                    updateSubtotal(hargaInput);
                    updateTotalHarga();
                }
            });
        } else {
            hargaInput.val('');
            updateSubtotal(hargaInput);
            updateTotalHarga();
        }
    }

    function updateSubtotal(hargaInput) {
        let row = hargaInput.closest('.row');
        let jumlah = parseFloat(row.find('.jumlah-input').val()) || 0;
        let harga = parseFloat(hargaInput.val()) || 0;
        let subtotal = jumlah * harga;
        row.find('.subtotal').val(subtotal.toFixed(2));
    }

    function updateTotalHarga() {
        let total = 0;
        $('.subtotal').each(function() {
            total += parseFloat($(this).val()) || 0;
        });
        $('#total_harga').val(total.toFixed(2));
        updateKembalian();
    }

    function updateKembalian() {
        let bayar = parseFloat($('#bayar').val()) || 0;
        let total = parseFloat($('#total_harga').val()) || 0;
        let kembalian = bayar - total;
        $('#kembalian').val(kembalian >= 0 ? kembalian.toFixed(2) : 0);
    }

    // Event: saat halaman pertama load (jika ada old value)
    $('.obat-select').each(function(){
        updateHargaJual($(this));
    });

    // Event: pilih obat
    $(document).on('change', '.obat-select', function() {
        updateHargaJual($(this));
    });

    // Event: ubah jumlah
    $(document).on('input', '.jumlah-input', function() {
        let hargaInput = $(this).closest('.row').find('.harga-satuan');
        updateSubtotal(hargaInput);
        updateTotalHarga();
    });

    // Event: input bayar
    $('#bayar').on('input', function() {
        updateKembalian();
    });

    // Tambah baris detail obat
    $('#tambah-detail').click(function() {
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
                <input type="number" name="jumlah[]" class="form-control jumlah-input" placeholder="Jumlah" required min="1">
            </div>
            <div class="col-md-3">
                <input type="number" step="0.01" name="harga_satuan[]" class="form-control harga-satuan" placeholder="Harga Satuan" required min="0" readonly>
            </div>
            <div class="col-md-3">
                <input type="number" step="0.01" class="form-control subtotal" placeholder="Subtotal" readonly>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-danger remove-detail">Hapus</button>
            </div>
        </div>
        `;
        $('#detail-obat').append(row);
    });

    // Hapus baris detail obat
    $(document).on('click', '.remove-detail', function() {
        $(this).closest('.row').remove();
        updateTotalHarga();
    });

});
</script>
@endsection
