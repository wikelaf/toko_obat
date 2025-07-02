import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_pelanggan.dart'; // Pastikan ada method updatePelanggan

class ProfilePelangganScreen extends StatefulWidget {
  const ProfilePelangganScreen({Key? key}) : super(key: key);

  @override
  State<ProfilePelangganScreen> createState() => _ProfilePelangganScreenState();
}

class _ProfilePelangganScreenState extends State<ProfilePelangganScreen> {
  bool isEdit = false;
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController alamatController;
  late TextEditingController teleponController;
  int? idPelanggan;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idPelanggan = prefs.getInt('pelanggan_id');
      namaController = TextEditingController(text: prefs.getString('pelanggan_nama') ?? '');
      emailController = TextEditingController(text: prefs.getString('pelanggan_email') ?? '');
      alamatController = TextEditingController(text: prefs.getString('pelanggan_alamat') ?? '');
      teleponController = TextEditingController(text: prefs.getString('pelanggan_telepon') ?? '');
    });
  }

  Future<void> _simpanProfile() async {
    // Panggil API update pelanggan
    final success = await ApiPelanggan.updatePelangganById(
      id: idPelanggan!,
      nama: namaController.text,
      email: emailController.text,
      alamat: alamatController.text,
      telepon: teleponController.text,
    );
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pelanggan_nama', namaController.text);
      await prefs.setString('pelanggan_email', emailController.text);
      await prefs.setString('pelanggan_alamat', alamatController.text);
      await prefs.setString('pelanggan_telepon', teleponController.text);
      setState(() => isEdit = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil diperbarui')));
       Navigator.pop(context, true); // Kembalikan true agar halaman sebelumnya bisa refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text('Profil Saya', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan gradient dan avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.blue[400]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    namaController.text,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    emailController.text,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProfileField('Nama', namaController, isEdit, Icons.person),
                      const SizedBox(height: 12),
                      _buildProfileField('Email', emailController, isEdit, Icons.email),
                      const SizedBox(height: 12),
                      _buildProfileField('Alamat', alamatController, isEdit, Icons.home, maxLines: 2),
                      const SizedBox(height: 12),
                      _buildProfileField('Telepon', teleponController, isEdit, Icons.phone),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isEdit ? Colors.green : Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            icon: Icon(isEdit ? Icons.save : Icons.edit),
                            label: Text(isEdit ? 'Simpan' : 'Edit Data'),
                            onPressed: () {
                              if (isEdit) {
                                _simpanProfile();
                              } else {
                                setState(() => isEdit = true);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            ),
                            icon: const Icon(Icons.lock_reset),
                            label: const Text('Ubah Password'),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => _UbahPasswordDialog(idPelanggan: idPelanggan!),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool enabled, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? null : Colors.blue[50],
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

class _UbahPasswordDialog extends StatefulWidget {
  final int idPelanggan;
  const _UbahPasswordDialog({required this.idPelanggan});

  @override
  State<_UbahPasswordDialog> createState() => _UbahPasswordDialogState();
}

class _UbahPasswordDialogState extends State<_UbahPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool isLoading = false;

  Future<void> _ubahPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    // Panggil API ubah password, sesuaikan endpoint dan parameter dengan backend Anda
    final success = await ApiPelanggan.ubahPassword(
      id: widget.idPelanggan,
      oldPassword: _oldPassController.text,
      newPassword: _newPassController.text,
    );
    setState(() => isLoading = false);
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password berhasil diubah')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _oldPassController,
              decoration: const InputDecoration(labelText: 'Password Lama'),
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _newPassController,
              decoration: const InputDecoration(labelText: 'Password Baru'),
              obscureText: true,
              validator: (v) => v == null || v.length < 6 ? 'Min 6 karakter' : null,
            ),
            TextFormField(
              controller: _confirmPassController,
              decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
              obscureText: true,
              validator: (v) => v != _newPassController.text ? 'Password tidak sama' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _ubahPassword,
          child: isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Simpan'),
        ),
      ],
    );
  }
}
