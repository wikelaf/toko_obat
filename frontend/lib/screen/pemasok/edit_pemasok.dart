import 'package:flutter/material.dart';
import '../../models/Pemasok_Model.dart';
import '../../services/api_pemasok.dart';

class EditPemasokScreen extends StatefulWidget {
  final PemasokModel pemasok;
  const EditPemasokScreen({Key? key, required this.pemasok}) : super(key: key);

  @override
  State<EditPemasokScreen> createState() => _EditPemasokScreenState();
}

class _EditPemasokScreenState extends State<EditPemasokScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pemasok.nama);
    _alamatController = TextEditingController(text: widget.pemasok.alamat);
    _teleponController = TextEditingController(text: widget.pemasok.telepon);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _editPemasok() async {
    if (_formKey.currentState!.validate()) {
      final updatedPemasok = PemasokModel(
        idPemasok: widget.pemasok.idPemasok,
        nama: _namaController.text,
        alamat: _alamatController.text,
        telepon: _teleponController.text,
        createdAt: widget.pemasok.createdAt,
        updatedAt: widget.pemasok.updatedAt,
      );

      final success = await ApiPemasok.updatePemasok(updatedPemasok);

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data pemasok')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Pemasok')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _editPemasok,
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
