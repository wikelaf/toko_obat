import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/Obat_Model.dart';
import '../../services/api_service.dart';

class EditObatScreen extends StatefulWidget {
  final ObatModel obat;
  const EditObatScreen({Key? key, required this.obat}) : super(key: key);

  @override
  State<EditObatScreen> createState() => _EditObatScreenState();
}

class _EditObatScreenState extends State<EditObatScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _stokController;
  late TextEditingController _hargaBeliController;
  late TextEditingController _hargaJualController;
  late TextEditingController _expiredDateController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.obat.namaObat);
    _stokController = TextEditingController(text: widget.obat.stok.toString());
    _hargaBeliController = TextEditingController(text: widget.obat.hargaBeli.toString());
    _hargaJualController = TextEditingController(text: widget.obat.hargaJual.toString());
    _expiredDateController = TextEditingController(text: widget.obat.expiredDate);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _editObat() async {
    if (_formKey.currentState!.validate()) {
      ObatModel updatedObat = ObatModel(
        idObat: widget.obat.idObat,
        namaObat: _namaController.text,
        stok: int.parse(_stokController.text),
        hargaBeli: double.parse(_hargaBeliController.text),
        hargaJual: double.parse(_hargaJualController.text),
        expiredDate: _expiredDateController.text,
        foto: widget.obat.foto,
        updatedAt: widget.obat.updatedAt,
        createdAt: widget.obat.createdAt,
      );
      bool success = await ApiService.updateObat(updatedObat, _imageFile);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengedit data obat')),
        );
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _showImageSourceActionSheet,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (widget.obat.foto.isNotEmpty
                          ? NetworkImage(widget.obat.foto) as ImageProvider
                          : null),
                  child: _imageFile == null && widget.obat.foto.isEmpty
                      ? Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Obat'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama obat tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(labelText: 'Stok'),
                validator: (value) =>
                    value!.isEmpty ? 'Stok tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _hargaBeliController,
                decoration: InputDecoration(labelText: 'Harga Beli'),
                validator: (value) =>
                    value!.isEmpty ? 'Harga beli tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _hargaJualController,
                decoration: InputDecoration(labelText: 'Harga Jual'),
                validator: (value) =>
                    value!.isEmpty ? 'Harga jual tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _expiredDateController,
                decoration: InputDecoration(labelText: 'Tanggal Expired (YYYY-MM-DD)'),
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal expired tidak boleh kosong' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _editObat,
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _expiredDateController.dispose();
    super.dispose();
  }
}
