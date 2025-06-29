@extends('layouts.app')

@section('content')
<style>
@media print {
  header, nav, footer, .btn, .no-print, 
  .sidebar,
  #accordionSidebar,
  #content-wrapper .topbar {
    display: none !important;
  }

  #content-wrapper, 
  #content, 
  .container-fluid, 
  .container {
    width: 100% !important;
    margin: 0 !important;
    padding: 0 !important;
    box-shadow: none !important;
  }
}
</style>

<div class="container text-center mb-4">
    <h2>Toko Obat Abadi</h2>
    <p>Jl. Padang Pasir 1</p>
     <hr class="mt-2 mb-4" style="border-top: 3px solid #007bff; width: 150px; margin-left:auto; margin-right:auto;">
</div>

<div class="container">
    <h3>Laporan Data Penjualan</h3>
    
<form method="GET" action="{{ route('penjualan.laporan') }}" class="mb-3 no-print">
    <div class="form-row align-items-end flex-wrap">
        <div class="col-auto mb-2">
            <label for="start_date">Tanggal Mulai</label>
            <input type="date" id="start_date" name="start_date" class="form-control" value="{{ request('start_date') }}">
        </div>

        <div class="col-auto mb-2">
            <label for="end_date">Tanggal Akhir</label>
            <input type="date" id="end_date" name="end_date" class="form-control" value="{{ request('end_date') }}">
        </div>

        <div class="col-auto mb-2">
            <label for="id_pelanggan">Pelanggan</label>
            <select name="id_pelanggan" id="id_pelanggan" class="form-control">
                <option value="">-- Semua Pelanggan --</option>
                @foreach($pelanggans as $pelanggan)
                    <option value="{{ $pelanggan->id_pelanggan }}" {{ request('id_pelanggan') == $pelanggan->id_pelanggan ? 'selected' : '' }}>
                        {{ $pelanggan->nama }}
                    </option>
                @endforeach
            </select>
        </div>

        <div class="col-auto mb-2">
            <label for="periode">Periode</label>
            <select name="periode" id="periode" class="form-control">
                <option value="">-- Semua Transaksi --</option>
                <option value="hari" {{ request('periode') == 'hari' ? 'selected' : '' }}>Per Hari</option>
                <option value="bulan" {{ request('periode') == 'bulan' ? 'selected' : '' }}>Per Bulan</option>
                <option value="tahun" {{ request('periode') == 'tahun' ? 'selected' : '' }}>Per Tahun</option>
            </select>
        </div>

        <div class="col-auto mb-2 d-flex gap-2">
            <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i></button>
            <button type="button" onclick="window.print()" class="btn btn-success"><i class="fas fa-print"></i></button>
            <a href="{{ route('penjualan.laporan') }}" class="btn btn-secondary"><i class="fas fa-sync-alt"></i></a>
        </div>
    </div>
</form>


    @if (in_array(request('periode'), ['hari','bulan','tahun']))
    {{-- Tampilan Ringkasan Periode --}}
    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>Periode</th>
                <th>Total Transaksi</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($penjualans as $laporan)
                <tr>
                    <td>{{ $laporan->periode }}</td>
                    <td>{{ number_format($laporan->total, 0, ',', '.') }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="2" class="text-center">Data tidak ditemukan.</td>
                </tr>
            @endforelse
        </tbody>
    </table>

    @else
    {{-- Tampilan Detail --}}
    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>ID Penjualan</th>
                <th>Tanggal</th>
                <th>Pelanggan</th>
                <th>Obat yang dibeli</th>
                <th>Harga Jual</th>
                <th>Jumlah</th>
                <th>Subtotal (Rp)</th>
            </tr>
        </thead>
        <tbody>
            @forelse($penjualans as $penjualan)
                @php $rowspan = $penjualan->penjualanDetails->count(); @endphp
                @foreach($penjualan->penjualanDetails as $key => $detail)
                <tr>
                    @if($key == 0)
                        <td rowspan="{{ $rowspan }}">{{ $penjualan->id_penjualan }}</td>
                        <td rowspan="{{ $rowspan }}">{{ \Carbon\Carbon::parse($penjualan->tanggal)->format('d-m-Y') }}</td>
                        <td rowspan="{{ $rowspan }}">{{ $penjualan->pelanggan->nama ?? '-' }}</td>
                    @endif
                    <td>{{ $detail->obat->nama_obat ?? 'Obat Tidak Ditemukan' }}</td>
                    <td>{{ number_format($detail->harga_satuan, 0, ',', '.') }}</td>
                    <td>{{ $detail->jumlah }}</td>
                    <td>{{ number_format($detail->subtotal, 0, ',', '.') }}</td>
                </tr>
                @endforeach
                <tr>
                    <td colspan="6" class="text-right font-weight-bold">Total Bayar:</td>
                    <td class="font-weight-bold">{{ number_format($penjualan->total_harga, 0, ',', '.') }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" class="text-center">Data penjualan tidak ditemukan.</td>
                </tr>
            @endforelse
        </tbody>
        <tfoot>
            <tr>
                <th colspan="6" class="text-right">Total Keseluruhan:</th>
                <th class="font-weight-bold">
                    {{ number_format($penjualans->sum('total_harga'), 0, ',', '.') }}
                </th>
            </tr>
        </tfoot>
    </table>
    @endif
</div>
@endsection
