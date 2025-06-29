@extends('layouts.app')

@section('content')
<style>
@media print {
  /* Sembunyikan elemen-elemen template saat print */
  header, nav, footer, .btn, .no-print, 
  /* Sidebar SB Admin 2 */
  .sidebar,
  #accordionSidebar,
  /* Topbar SB Admin 2 */
  #content-wrapper .topbar {
    display: none !important;
  }

  /* Bikin konten laporan full width */
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
    <h3>Laporan Data Pelanggan</h3>

    {{-- Jika mau filter, bisa tambahkan form filter di sini --}}
    {{-- <form method="GET" action="{{ route('pelanggan.laporan') }}" class="form-inline mb-3 no-print">
        <!-- contoh filter jika diperlukan -->
    </form> --}}

    <button onclick="window.print()" class="btn btn-primary no-print mb-3">Cetak Laporan</button>

    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>ID Pelanggan</th>
                <th>Nama</th>
                 <th>Email</th>
                <th>Alamat</th>
                <th>Telepon</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($pelanggans as $pelanggan)
            <tr>
                <td>{{ $pelanggan->id_pelanggan }}</td>
                <td>{{ $pelanggan->nama }}</td>
                <td>{{ $pelanggan->email }}</td>
                <td>{{ $pelanggan->alamat }}</td>
                <td>{{ $pelanggan->telepon }}</td>
            </tr>
            @empty
            <tr>
                <td colspan="4" class="text-center">Data pelanggan tidak ditemukan.</td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>
@endsection
