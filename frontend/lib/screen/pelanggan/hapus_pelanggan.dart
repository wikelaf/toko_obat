import 'package:flutter/material.dart';
import '../../models/Pelanggan_Model.dart';
import '../../services/api_pelanggan.dart';

class HapusPelangganScreen extends StatelessWidget {
  final PelangganModel pelanggan;
  const HapusPelangganScreen({Key? key, required this.pelanggan}) : super(key: key);

  Future<void> _hapusPelanggan(BuildContext context) async {
    bool success = await ApiPelanggan.deletePelanggan(pelanggan.idPelanggan);
    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pelanggan berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pelanggan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus Pelanggan'),
      content: Text('Apakah Anda yakin ingin menghapus pelanggan "${pelanggan.nama}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => _hapusPelanggan(context),
          child: Text('Hapus'),
        ),
      ],
    );
  }
}
