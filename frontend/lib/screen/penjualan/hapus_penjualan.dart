import 'package:flutter/material.dart';
import '../../models/Penjualan_Model.dart';
import '../../services/api_penjualan.dart';

class HapusPenjualanScreen extends StatelessWidget {
  final PenjualanModel penjualan;
  const HapusPenjualanScreen({Key? key, required this.penjualan}) : super(key: key);

  Future<void> _hapusPenjualan(BuildContext context) async {
    bool success = await ApiPenjualan.deletePenjualan(penjualan.idPenjualan);
    if (success) {
      Navigator.pop(context, true);  // kirim true sebagai tanda berhasil hapus
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Penjualan berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus penjualan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus Penjualan'),
      content: Text('Apakah Anda yakin ingin menghapus penjualan tanggal "${penjualan.tanggal}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // batal hapus
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => _hapusPenjualan(context),
          child: Text('Hapus'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
