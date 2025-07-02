import 'package:flutter/material.dart';
import '../../models/Obat_Model.dart';
import '../../services/api_service.dart';

class HapusObatScreen extends StatelessWidget {
  final ObatModel obat;
  const HapusObatScreen({Key? key, required this.obat}) : super(key: key);

  Future<void> _hapusObat(BuildContext context) async {
    bool success = await ApiService.deleteObat(obat.idObat);
    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Obat berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus obat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus Obat'),
      content: Text('Apakah Anda yakin ingin menghapus obat "${obat.namaObat}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => _hapusObat(context),
          child: Text('Hapus'),
        ),
      ],
    );
  }
}
