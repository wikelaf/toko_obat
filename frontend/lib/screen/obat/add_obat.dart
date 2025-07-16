import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/Obat_Model.dart';
import '../../services/api_service.dart';

class AddObatScreen extends StatefulWidget {
  @override
  _AddObatScreenState createState() => _AddObatScreenState();
}

class _AddObatScreenState extends State<AddObatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaObatController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _expiredDateController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Margin dalam persen (misalnya 30%)
  double marginPersen = 30.0;

  @override
  void initState() {
    super.initState();

    // Hitung harga jual otomatis ketika harga beli diubah
    _hargaBeliController.addListener(() {
      final hargaBeli = double.tryParse(_hargaBeliController.text) ?? 0;
      final hargaJual = hargaBeli + (hargaBeli * (marginPersen / 100));
      _hargaJualController.text = hargaJual.toStringAsFixed(0);
    });

    // Default tanggal expired = hari ini
    _expiredDateController.text = DateTime.now().toIso8601String().split('T').first;
  }

  @override
  void dispose() {
    _namaObatController.dispose();
    _stokController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _expiredDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final obat = ObatModel(
          idObat: 0,
          namaObat: _namaObatController.text,
          stok: int.parse(_stokController.text),
          hargaBeli: double.parse(_hargaBeliController.text),
          hargaJual: double.parse(_hargaJualController.text),
          expiredDate: _expiredDateController.text,
          foto: '',
          createdAt: '',
          updatedAt: '',
        );
        final success = await ApiService.createObat(obat, _imageFile);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Obat berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan obat')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Format input salah: $e')),
        );
      }
    }
  }

  Future<void> _selectExpiredDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now, // hanya hari ini dan ke belakang
    );
    if (picked != null) {
      _expiredDateController.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Obat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Pilih dari Galeri'),
                              onTap: () async {
                                Navigator.pop(context);
                                await _pickImage();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Ambil dari Kamera'),
                              onTap: () async {
                                Navigator.pop(context);
                                await _takePhoto();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null ? Icon(Icons.camera_alt, size: 50) : null,
                  ),
                ),
                TextFormField(
                  controller: _namaObatController,
                  decoration: InputDecoration(labelText: 'Nama Obat'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Nama obat tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _stokController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Stok'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Stok tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _hargaBeliController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Harga Beli'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harga beli tidak boleh kosong' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hargaJualController,
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Harga Jual (otomatis)'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: marginPersen.toString(),
                        decoration: InputDecoration(labelText: 'Margin (%)'),
                        onChanged: (value) {
                          setState(() {
                            marginPersen = double.tryParse(value) ?? 30.0;
                            final beli = double.tryParse(_hargaBeliController.text) ?? 0;
                            final jual = beli + (beli * marginPersen / 100);
                            _hargaJualController.text = jual.toStringAsFixed(0);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _expiredDateController,
                  readOnly: true,
                  onTap: _selectExpiredDate,
                  decoration: InputDecoration(labelText: 'Expired Date (YYYY-MM-DD)'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Tanggal expired tidak boleh kosong' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Simpan Obat'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
