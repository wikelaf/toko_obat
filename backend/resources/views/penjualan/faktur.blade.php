<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Faktur Penjualan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #000; padding: 8px; text-align: left; }
        .no-border { border: none; }
        .text-right { text-align: right; }
    </style>
</head>
<body>
   <!-- resources/views/penjualan/faktur.blade.php -->
<div>
    <h4 class="text-center mb-3">FAKTUR PENJUALAN</h4>
    <h4 class="text-center mb-3">Toko Obat Abadi</h4>
    <p><strong>Tanggal:</strong> {{ \Carbon\Carbon::parse($penjualan->tanggal)->format('d-m-Y') }}</p>
    <p><strong>Nama Pelanggan:</strong> {{ $penjualan->pelanggan->nama ?? '-' }}</p>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>No</th>
                <th>Nama Obat</th>
                <th>Jumlah</th>
                <th>Harga Satuan</th>
                <th>Subtotal</th>
            </tr>
        </thead>
        <tbody>
            @php $total = 0; @endphp
            @foreach($penjualan->penjualanDetails as $i => $detail)
                @php
                    $subtotal = $detail->jumlah * $detail->harga_satuan;
                    $total += $subtotal;
                @endphp
                <tr>
                    <td>{{ $i + 1 }}</td>
                    <td>{{ $detail->obat->nama_obat }}</td>
                    <td>{{ $detail->jumlah }}</td>
                    <td>Rp {{ number_format($detail->harga_satuan, 0, ',', '.') }}</td>
                    <td>Rp {{ number_format($subtotal, 0, ',', '.') }}</td>
                </tr>
            @endforeach
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4" class="text-right"><strong>Total</strong></td>
                <td><strong>Rp {{ number_format($total, 0, ',', '.') }}</strong></td>
            </tr>
        </tfoot>
    </table>
    <p>Terima kasih atas pembelian Anda.</p>
</div>
    <script>
        window.print();
    </script>
</body>
</html>
