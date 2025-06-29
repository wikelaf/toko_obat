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

/* List checkbox style */
.checkbox-list {
  list-style: none;
  padding-left: 0;
  margin-bottom: 1rem;
}

.checkbox-list li {
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
}

.checkbox-list input[type="checkbox"] {
  margin-right: 0.5rem;
  width: 18px;
  height: 18px;
}

.checkbox-list label {
  cursor: pointer;
  margin: 0;
  font-weight: 500;
  user-select: none;
}

/* Table styling */
.table-custom {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 0 8px rgb(0 0 0 / 0.1);
}

.table-custom thead {
  background-color: #007bff;
  color: white;
  text-align: center;
}

.table-custom th, .table-custom td {
  vertical-align: middle !important;
}

.btn-group {
  margin-bottom: 1.5rem;
}
</style>

<div class="container text-center mb-4">
    <h2 class="fw-bold">Toko Obat Abadi</h2>
    <p class="text-muted mb-0">Jl. Padang Pasir 1</p>
    <hr class="mt-2 mb-4" style="border-top: 3px solid #007bff; width: 150px; margin-left:auto; margin-right:auto;">
</div>

<div class="container">
    <h3 class="mb-4">Laporan Data Obat</h3>

    <form method="GET" action="{{ route('obat.laporan') }}" class="no-print d-flex flex-column flex-sm-row align-items-start align-items-sm-center gap-3 mb-4">
      
      <ul class="checkbox-list mb-0 d-flex flex-column flex-sm-row gap-4">
        <li>
          <input type="checkbox" name="stok_hampir_habis" id="stok_hampir_habis" {{ request('stok_hampir_habis') ? 'checked' : '' }}>
          <label for="stok_hampir_habis">Obat Hampir Habis (stok &lt; 10)</label>
        </li>
        <li>
          <input type="checkbox" name="expired_akan" id="expired_akan" {{ request('expired_akan') ? 'checked' : '' }}>
          <label for="expired_akan">Obat Mendekati Expired (30 hari)</label>
        </li>
      </ul>

      <div class="col-auto mb-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i></button>
            <button type="button" onclick="window.print()" class="btn btn-success"><i class="fas fa-print"></i></button>
            <a href="{{ route('obat.laporan') }}" class="btn btn-secondary"><i class="fas fa-sync-alt"></i></a>
        </div>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-striped table-hover table-custom">
          <thead>
              <tr>
                  <th>Nama Obat</th>
                  <th>Stok Tersedia</th>
                  <th>Harga Beli (Rp)</th>
                  <th>Harga Jual (Rp)</th>
                  <th>Expired Date</th>
              </tr>
          </thead>
          <tbody>
              @forelse ($obats as $obat)
              <tr>
                  <td>{{ $obat->nama_obat }}</td>
                  <td class="text-center">{{ $obat->stok }}</td>
                  <td class="text-end">{{ number_format($obat->harga_beli, 0, ',', '.') }}</td>
                  <td class="text-end">{{ number_format($obat->harga_jual, 0, ',', '.') }}</td>
                  <td class="text-center">{{ \Carbon\Carbon::parse($obat->expired_date)->format('d-m-Y') }}</td>
              </tr>
              @empty
              <tr>
                  <td colspan="5" class="text-center">Data obat tidak ditemukan.</td>
              </tr>
              @endforelse
          </tbody>
      </table>
    </div>
</div>
@endsection
