import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/Pelanggan_Model.dart';
import '../../models/Obat_Model.dart';
import '../../models/Penjualan_Model.dart';
import '../../services/api_pelanggan.dart';
import '../../services/api_service.dart';
import '../../services/api_penjualan.dart';

class AddPenjualanScreen extends StatefulWidget {
  @override
  _AddPenjualanScreenState createState() => _AddPenjualanScreenState();
}

class _AddPenjualanScreenState extends State<AddPenjualanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bayarController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  PelangganModel? _selectedPelanggan;
  List<ObatModel> _listObat = [];
  List<PelangganModel> _listPelanggan = [];
  List<PenjualanItem> _items = [];

  double get totalHarga =>
      _items.fold(0, (sum, item) => sum + (item.jumlah * item.hargaSatuan));

  double get kembalian {
    double bayar = double.tryParse(_bayarController.text) ?? 0;
    double kembali = bayar - totalHarga;
    return kembali < 0 ? 0 : kembali;
  }

  @override
  void initState() {
    super.initState();
    _fetchObat();
    _fetchPelanggan();
  }

  Future<void> _fetchObat() async {
    try {
      final data = await ApiService.fetchObat();
      setState(() => _listObat = data);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data obat')));
    }
  }

  Future<void> _fetchPelanggan() async {
    try {
      final data = await ApiPelanggan.fetchPelanggan();
      setState(() => _listPelanggan = data);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data pelanggan')));
    }
  }

  void _addItem() {
    setState(() => _items.add(PenjualanItem()));
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPelanggan == null || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lengkapi data terlebih dahulu')));
      return;
    }

    List<int> obatId = [];
    List<int> jumlah = [];
    List<double> hargaSatuan = [];

    for (var item in _items) {
      if (item.obat == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pilih semua obat')));
        return;
      }
      obatId.add(item.obat!.idObat);
      jumlah.add(item.jumlah);
      hargaSatuan.add(item.hargaSatuan);
    }

    double bayar = double.tryParse(_bayarController.text) ?? 0;
    double kembali = bayar - totalHarga;
    if (kembali < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bayar kurang dari total harga')));
      return;
    }

    final result = await ApiPenjualan.createPenjualan(
      tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate),
      idPelanggan: _selectedPelanggan!.idPelanggan,
      obatId: obatId,
      jumlah: jumlah,
      hargaSatuan: hargaSatuan,
      bayar: bayar,
      kembalian: kembali,
    );

    if (result.containsKey('data')) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Penjualan berhasil disimpan')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan')));
    }
  }

  @override
  void dispose() {
    _bayarController.dispose();
    _items.forEach((item) => item.hargaSatuanController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Penjualan')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              DropdownButtonFormField<PelangganModel>(
                decoration: InputDecoration(labelText: 'Pilih Pelanggan'),
                value: _selectedPelanggan,
                items: _listPelanggan.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.nama),
                )).toList(),
                onChanged: (val) => setState(() => _selectedPelanggan = val),
                validator: (val) => val == null ? 'Pelanggan harus dipilih' : null,
              ),
              SizedBox(height: 16),
              Text('Obat yang dibeli', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._items.asMap().entries.map((entry) {
                int index = entry.key;
                PenjualanItem item = entry.value;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<ObatModel>(
                          decoration: InputDecoration(labelText: 'Pilih Obat'),
                          value: item.obat,
                          items: _listObat.map((obat) => DropdownMenuItem(
                            value: obat,
                            child: Text('${obat.namaObat} (Stok: ${obat.stok})'),
                          )).toList(),
                          onChanged: (val) {
                            setState(() {
                              item.obat = val;
                              item.hargaSatuan = val?.hargaJual ?? 0;
                              item.hargaSatuanController.text =
                                  item.hargaSatuan.toStringAsFixed(2);
                            });
                          },
                          validator: (val) => val == null ? 'Obat harus dipilih' : null,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Jumlah'),
                          keyboardType: TextInputType.number,
                          initialValue: item.jumlah.toString(),
                          onChanged: (val) {
                            final parsed = int.tryParse(val) ?? 1;
                            setState(() => item.jumlah = parsed < 1 ? 1 : parsed);
                          },
                        ),
                        TextFormField(
                          controller: item.hargaSatuanController,
                          decoration: InputDecoration(labelText: 'Harga Satuan'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0;
                            setState(() => item.hargaSatuan = parsed);
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
              ElevatedButton.icon(
                onPressed: _addItem,
                icon: Icon(Icons.add),
                label: Text('Tambah Obat'),
              ),
              SizedBox(height: 12),
              Text('Total Harga: Rp ${totalHarga.toStringAsFixed(2)}'),
              TextFormField(
                controller: _bayarController,
                decoration: InputDecoration(labelText: 'Jumlah Bayar'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 8),
              Text('Kembalian: Rp ${kembalian.toStringAsFixed(2)}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Simpan Penjualan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PenjualanItem {
  ObatModel? obat;
  int jumlah;
  double hargaSatuan;
  TextEditingController hargaSatuanController;

  PenjualanItem({
    this.obat,
    this.jumlah = 1,
    this.hargaSatuan = 0,
  }) : hargaSatuanController = TextEditingController(text: hargaSatuan.toStringAsFixed(2));
}
