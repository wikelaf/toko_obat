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
    <h3>Laporan Data Pemasok</h3>

    <button onclick="window.print()" class="btn btn-primary no-print mb-3">Cetak Laporan</button>

    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>ID Pemasok</th>
                <th>Nama</th>
                <th>Alamat</th>
                <th>Telepon</th>
            </tr>
        </thead>
        <tbody>
            @foreach($pemasoks as $pemasok)
            <tr>
                <td>{{ $pemasok->id_pemasok }}</td>
                <td>{{ $pemasok->nama }}</td>
                <td>{{ $pemasok->alamat }}</td>
                <td>{{ $pemasok->telepon }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
