import 'package:flutter/material.dart';
import '../../models/Pembelian_Model.dart';
import '../../services/api_pembelian.dart';

class HapusPembelianScreen extends StatelessWidget {
  final PembelianModel pembelian;

  const HapusPembelianScreen({Key? key, required this.pembelian}) : super(key: key);

  Future<void> _hapusPembelian(BuildContext context) async {
    final success = await ApiPembelian.deletePembelian(pembelian.idPembelian);
    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembelian berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pembelian')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Pembelian'),
      content: Text('Yakin ingin menghapus pembelian tanggal "${pembelian.tanggal}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => _hapusPembelian(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
