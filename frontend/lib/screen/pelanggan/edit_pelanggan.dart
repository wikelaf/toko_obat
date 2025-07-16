import 'package:flutter/material.dart';
import '../../models/Pelanggan_Model.dart';
import '../../services/api_pelanggan.dart';

class EditPelangganScreen extends StatefulWidget {
  final PelangganModel pelanggan;
  const EditPelangganScreen({Key? key, required this.pelanggan}) : super(key: key);

  @override
  State<EditPelangganScreen> createState() => _EditPelangganScreenState();
}

class _EditPelangganScreenState extends State<EditPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pelanggan.nama);
    _emailController = TextEditingController(text: widget.pelanggan.email);
    _alamatController = TextEditingController(text: widget.pelanggan.alamat);
    _teleponController = TextEditingController(text: widget.pelanggan.telepon);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _editPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final updatedPelanggan = PelangganModel(
        idPelanggan: widget.pelanggan.idPelanggan,
        nama: _namaController.text,
        email: _emailController.text,
        password: _passwordController.text,
        alamat: _alamatController.text,
        telepon: _teleponController.text,
        createdAt: widget.pelanggan.createdAt,
        updatedAt: widget.pelanggan.updatedAt,
      );

      final success = await ApiPelanggan.updatePelanggan(
        updatedPelanggan,
        password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data pelanggan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Pelanggan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password (kosongkan jika tidak diubah)',
                ),
                obscureText: true,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              TextFormField(
                controller: _teleponController,
                decoration: InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _editPelanggan,
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
