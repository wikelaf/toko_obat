import 'package:flutter/material.dart';
import '../../models/Pemasok_Model.dart';
import '../../services/api_pemasok.dart';

class AddPemasokScreen extends StatefulWidget {
  @override
  _AddPemasokScreenState createState() => _AddPemasokScreenState();
}

class _AddPemasokScreenState extends State<AddPemasokScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final pemasok = PemasokModel(
          idPemasok: 0,
          nama: _namaController.text,
          alamat: _alamatController.text,
          telepon: _teleponController.text,
          createdAt: '',
          updatedAt: '',
        );

        final success = await ApiPemasok.createPemasok(pemasok);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pemasok berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan pemasok')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kesalahan input: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pemasok'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pemasok'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Simpan Pemasok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
