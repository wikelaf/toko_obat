import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/Penjualan_Model.dart';
import '../../services/api_penjualan.dart';
import 'add_penjualan.dart';
import 'hapus_penjualan.dart';

class HomePenjualanScreen extends StatefulWidget {
  const HomePenjualanScreen({Key? key}) : super(key: key);

  @override
  State<HomePenjualanScreen> createState() => _HomePenjualanScreenState();
}

class _HomePenjualanScreenState extends State<HomePenjualanScreen> {
  late Future<List<PenjualanModel>> futurePenjualan;

  @override
  void initState() {
    super.initState();
    futurePenjualan = ApiPenjualan.fetchPenjualan();
  }

  void refreshData() {
    setState(() {
      futurePenjualan = ApiPenjualan.fetchPenjualan();
    });
  }

  void showDetailDialog(PenjualanModel penjualan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Penjualan'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: penjualan.penjualanDetails.length,
            itemBuilder: (context, index) {
              final detail = penjualan.penjualanDetails[index];
              final fotoUrl = detail.obat?.fullFotoUrl;

              return ListTile(
                leading: fotoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          fotoUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 40),
                        ),
                      )
                    : const Icon(Icons.medical_services),
                title: Text(detail.obat?.namaObat ?? 'Obat tidak tersedia'),
                subtitle: Text(
                  'Jumlah: ${detail.jumlah}\nHarga Satuan: Rp ${detail.hargaSatuan.toStringAsFixed(0)}\nSubtotal: Rp ${detail.subtotal.toStringAsFixed(0)}\nBayar: Rp ${penjualan.bayar.toStringAsFixed(0)}\nKembalian: Rp ${penjualan.kembalian.toStringAsFixed(0)}'),
                
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Penjualan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<PenjualanModel>>(
        future: futurePenjualan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data penjualan kosong'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final penjualan = data[index];
              return Slidable(
                key: ValueKey(penjualan.idPenjualan),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => HapusPenjualanScreen(penjualan: penjualan),
                        );
                        if (result == true) refreshData();
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Hapus',
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      'Tanggal: ${penjualan.tanggal}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pelanggan: ${penjualan.pelanggan?.nama ?? '-'}'),
                        Text('Total Harga: Rp ${penjualan.totalHarga.toStringAsFixed(0)}'),
                       
                      ],
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () => showDetailDialog(penjualan),
                      icon: const Icon(Icons.info, size: 18),
                      label: const Text('Detail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) =>  AddPenjualanScreen()),
          );
          if (result == true) refreshData();
        },
      ),
    );
  }
}
