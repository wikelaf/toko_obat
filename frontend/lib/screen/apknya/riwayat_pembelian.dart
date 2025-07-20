import 'package:flutter/material.dart';
import '../../services/api_penjualan.dart';
import '../../models/Penjualan_Model.dart';

class RiwayatPembelianScreen extends StatefulWidget {
  const RiwayatPembelianScreen({super.key});

  @override
  State<RiwayatPembelianScreen> createState() => _RiwayatPembelianScreenState();
}

class _RiwayatPembelianScreenState extends State<RiwayatPembelianScreen> {
  late Future<List<PenjualanModel>> _futureRiwayat;

  @override
  void initState() {
    super.initState();
    _futureRiwayat = ApiPenjualan.fetchRiwayatByPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<PenjualanModel>>(
        future: _futureRiwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat pembelian.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final transaksi = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${transaksi.tanggal}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),

                      // List obat yang dibeli (nama, jumlah, harga, foto)
                      Column(
                        children: transaksi.penjualanDetails.map((detail) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: detail.obat?.fullFotoUrl != null &&
                                    detail.obat!.fullFotoUrl.isNotEmpty
                                ? Image.network(
                                    detail.obat!.fullFotoUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.image_not_supported),
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                            title: Text(detail.obat?.namaObat ?? 'Obat tidak diketahui'),
                            subtitle:
                                Text('Jumlah: ${detail.jumlah} x Rp${detail.hargaSatuan.toStringAsFixed(0)}'),
                            trailing: Text(
                                'Subtotal: Rp${detail.subtotal.toStringAsFixed(0)}'),
                          );
                        }).toList(),
                      ),

                      const Divider(),

                      Text(
                        'Total Harga: Rp${transaksi.totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Bayar: Rp${transaksi.bayar.toStringAsFixed(0)}'),
                      // Text('Kembalian: Rp${transaksi.kembalian.toStringAsFixed(0)}'),

                      // Jika ada info metode pembayaran, misal:
                      // Text('Pembayaran via: COD'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
