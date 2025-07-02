import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/Pembelian_Model.dart';
import '../../services/api_pembelian.dart';
import 'add_pembelian.dart';
import 'hapus_pembelian.dart';

class HomePembelianScreen extends StatefulWidget {
  const HomePembelianScreen({Key? key}) : super(key: key);

  @override
  State<HomePembelianScreen> createState() => _HomePembelianScreenState();
}

class _HomePembelianScreenState extends State<HomePembelianScreen> {
  late Future<List<PembelianModel>> futurePembelian;

  @override
  void initState() {
    super.initState();
    futurePembelian = ApiPembelian.fetchPembelian();
  }

  void refreshData() {
    setState(() {
      futurePembelian = ApiPembelian.fetchPembelian();
    });
  }

  void showDetailDialog(PembelianModel pembelian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pembelian'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pembelian.pembelianDetails.length,
            itemBuilder: (context, index) {
              final detail = pembelian.pembelianDetails[index];
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
                  'Jumlah: ${detail.jumlah}\nHarga: Rp ${detail.hargaSatuan.toStringAsFixed(0)}\nSubtotal: Rp ${detail.subtotal.toStringAsFixed(0)}',
                ),
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
        title: const Text('Data Pembelian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<PembelianModel>>(
        future: futurePembelian,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data pembelian kosong'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pembelian = data[index];
              return Slidable(
                key: ValueKey(pembelian.idPembelian),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => HapusPembelianScreen(pembelian: pembelian),
                        );
                        if (result == true) refreshData();
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Hapus',
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      'Tanggal: ${pembelian.tanggal}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pemasok: ${pembelian.pemasok?.nama ?? '-'}'),
                          Text('Total: Rp ${pembelian.totalHarga.toStringAsFixed(0)}'),
                        ],
                      ),
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () => showDetailDialog(pembelian),
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
            MaterialPageRoute(builder: (context) => const AddPembelianScreen()),
          );
          if (result == true) refreshData();
        },
      ),
    );
  }
}
