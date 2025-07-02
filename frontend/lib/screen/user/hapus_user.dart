import 'package:flutter/material.dart';
import '../../models/User_Model.dart';
import '../../services/api_user.dart';

class HapusUserDialog extends StatelessWidget {
  final UserModel user;
  const HapusUserDialog({Key? key, required this.user}) : super(key: key);

  Future<void> _hapusUser(BuildContext context) async {
    bool success = await ApiUser.deleteUser(user.id!);
    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus User'),
      content: Text('Apakah Anda yakin ingin menghapus user "${user.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => _hapusUser(context),
          child: Text('Hapus'),
        ),
      ],
    );
  }
}
