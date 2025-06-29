@extends('layouts.app')

@section('content')
<style>
@media print {
  header, nav, footer, .btn, .no-print, 
  .sidebar, #accordionSidebar, 
  #content-wrapper .topbar {
    display: none !important;
  }

  #content-wrapper, #content, 
  .container-fluid, .container {
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
    <h3>Laporan Data Pembelian Obat</h3>

    <form method="GET" action="{{ route('pembelian.laporan') }}" class="mb-3 no-print">
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
                <label for="id_pemasok">Pemasok</label>
                <select name="id_pemasok" id="id_pemasok" class="form-control">
                    <option value="">-- Semua Pemasok --</option>
                    @foreach($pemasoks as $pemasok)
                        <option value="{{ $pemasok->id_pemasok }}" {{ request('id_pemasok') == $pemasok->id_pemasok ? 'selected' : '' }}>
                            {{ $pemasok->nama }}
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
    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>Periode</th>
                <th>Total Pembelian (Rp)</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($pembelians as $laporan)
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
    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>ID Pembelian</th>
                <th>Tanggal</th>
                <th>Pemasok</th>
                <th>Obat yang dibeli</th>
                <th>Harga Beli</th>
                <th>Jumlah Unit</th>
                <th>Subtotal (Rp)</th>
            </tr>
        </thead>
        <tbody>
            @forelse($pembelians as $pembelian)
                @php $rowspan = $pembelian->pembelianDetails->count(); @endphp
                @foreach($pembelian->pembelianDetails as $key => $detail)
                <tr>
                    @if($key == 0)
                        <td rowspan="{{ $rowspan }}">{{ $pembelian->id_pembelian }}</td>
                        <td rowspan="{{ $rowspan }}">{{ \Carbon\Carbon::parse($pembelian->tanggal)->format('d-m-Y') }}</td>
                        <td rowspan="{{ $rowspan }}">{{ $pembelian->pemasok->nama ?? '-' }}</td>
                    @endif
                    <td>{{ $detail->obat->nama_obat ?? 'Obat Tidak Ditemukan' }}</td>
                    <td>{{ number_format($detail->harga_satuan, 0, ',', '.') }}</td>
                    <td>{{ $detail->jumlah }}</td>
                    <td>{{ number_format($detail->subtotal, 0, ',', '.') }}</td>
                </tr>
                @endforeach
                <tr>
                    <td colspan="6" class="text-right font-weight-bold">Total Harga Pembelian:</td>
                    <td class="font-weight-bold">{{ number_format($pembelian->total_harga, 0, ',', '.') }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" class="text-center">Data pembelian tidak ditemukan.</td>
                </tr>
            @endforelse
        </tbody>
        <tfoot>
            <tr>
                <th colspan="6" class="text-right">Total Keseluruhan:</th>
                <th>{{ number_format($pembelians->sum('total_harga'), 0, ',', '.') }}</th>
            </tr>
        </tfoot>
    </table>
    @endif
</div>
@endsection
