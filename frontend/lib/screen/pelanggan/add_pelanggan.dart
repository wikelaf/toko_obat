import 'package:flutter/material.dart';
import '../../models/Pelanggan_Model.dart';
import '../../services/api_pelanggan.dart';

class AddPelangganScreen extends StatefulWidget {
  @override
  _AddPelangganScreenState createState() => _AddPelangganScreenState();
}

class _AddPelangganScreenState extends State<AddPelangganScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final pelanggan = PelangganModel(
          idPelanggan: 0,
          nama: _namaController.text,
          email: _emailController.text,
          password: _passwordController.text,
          alamat: _alamatController.text,
          telepon: _teleponController.text,
          createdAt: '',
          updatedAt: '',
        );

        final success = await ApiPelanggan.createPelanggan(pelanggan);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pelanggan berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan pelanggan')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pelanggan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: 'Nama'),
                  validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? 'Email wajib diisi' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.length < 6 ? 'Password minimal 6 karakter' : null,
                ),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) => value == null || value.isEmpty ? 'Alamat wajib diisi' : null,
                ),
                TextFormField(
                  controller: _teleponController,
                  decoration: InputDecoration(labelText: 'Telepon'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Telepon wajib diisi' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Simpan Pelanggan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
