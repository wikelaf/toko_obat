import 'package:flutter/material.dart';
import '../../models/Pemasok_Model.dart';
import '../../services/api_pemasok.dart';

class HapusPemasokScreen extends StatelessWidget {
  final PemasokModel pemasok;
  const HapusPemasokScreen({Key? key, required this.pemasok}) : super(key: key);

  Future<void> _hapusPemasok(BuildContext context) async {
    bool success = await ApiPemasok.deletePemasok(pemasok.idPemasok);
    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pemasok berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pemasok')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus Pemasok'),
      content: Text('Apakah Anda yakin ingin menghapus pemasok "${pemasok.nama}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => _hapusPemasok(context),
          child: Text('Hapus'),
        ),
      ],
    );
  }
}
