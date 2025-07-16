import 'package:flutter/material.dart';
import '../../models/Pemasok_Model.dart';
import '../../models/Obat_Model.dart';
import '../../services/api_pemasok.dart';
import '../../services/api_service.dart';
import '../../services/api_pembelian.dart';
import 'package:intl/intl.dart';

class AddPembelianScreen extends StatefulWidget {
  const AddPembelianScreen({super.key});

  @override
  State<AddPembelianScreen> createState() => _AddPembelianScreenState();
}
class _AddPembelianScreenState extends State<AddPembelianScreen> {
  final _formKey = GlobalKey<FormState>();

  List<ObatModel> obatList = [];
  List<PemasokModel> pemasokList = [];

  int? selectedPemasokId;
  DateTime selectedTanggal = DateTime.now();

  // Untuk masing-masing detail field, simpan juga controller harga satuan agar bisa update otomatis
  List<Map<String, dynamic>> detailPembelian = [];
  List<TextEditingController> hargaSatuanControllers = [];
  List<TextEditingController> jumlahControllers = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  @override
  void dispose() {
    // Dispose semua controller
    for (var c in hargaSatuanControllers) {
      c.dispose();
    }
    for (var c in jumlahControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> fetchDropdownData() async {
    final obat = await ApiService.fetchObat();
    final pemasok = await ApiPemasok.fetchPemasok();
    setState(() {
      obatList = obat;
      pemasokList = pemasok;
      // Buat detail pertama default
      detailPembelian.add({
        'id_obat': null,
      });
      hargaSatuanControllers.add(TextEditingController());
      jumlahControllers.add(TextEditingController());
    });
  }

  void addDetailField() {
    setState(() {
      detailPembelian.add({'id_obat': null});
      hargaSatuanControllers.add(TextEditingController());
      jumlahControllers.add(TextEditingController());
    });
  }

  void removeDetailField(int index) {
    setState(() {
      if (detailPembelian.length > 1) {
        detailPembelian.removeAt(index);
        hargaSatuanControllers[index].dispose();
        jumlahControllers[index].dispose();
        hargaSatuanControllers.removeAt(index);
        jumlahControllers.removeAt(index);
      }
    });
  }

  void onObatChanged(int? obatId, int index) {
    setState(() {
      detailPembelian[index]['id_obat'] = obatId;

      if (obatId != null) {
        final obat = obatList.firstWhere((o) => o.idObat == obatId);
        // Set harga satuan ke harga beli obat otomatis
        hargaSatuanControllers[index].text = obat.hargaBeli.toStringAsFixed(0);
        // Juga update harga beli pada objek obatList supaya sinkron (UI lokal saja)
        obatList[obatList.indexWhere((o) => o.idObat == obatId)] =
            obat.copyWith(hargaBeli: obat.hargaBeli);
      } else {
        hargaSatuanControllers[index].text = '';
      }
    });
  }

  void onHargaSatuanChanged(String val, int index) {
    // Jika harga satuan diubah manual, update juga hargaBeli pada obatList (lokal)
    final obatId = detailPembelian[index]['id_obat'];
    if (obatId != null) {
      double? hargaBaru = double.tryParse(val);
      if (hargaBaru != null) {
        final obatIndex = obatList.indexWhere((o) => o.idObat == obatId);
        if (obatIndex != -1) {
          final obatLama = obatList[obatIndex];
          obatList[obatIndex] = obatLama.copyWith(hargaBeli: hargaBaru);
        }
      }
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && selectedPemasokId != null) {
      try {
        setState(() => isLoading = true);

        List<int> idObat = [];
        List<int> jumlah = [];
        List<double> hargaSatuan = [];

        for (int i = 0; i < detailPembelian.length; i++) {
          idObat.add(detailPembelian[i]['id_obat']);
          jumlah.add(int.parse(jumlahControllers[i].text));
          hargaSatuan.add(double.parse(hargaSatuanControllers[i].text));
        }

        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedTanggal);

        final result = await ApiPembelian.createPembelian(
          idPemasok: selectedPemasokId!,
          tanggal: formattedDate,
          idObat: idObat,
          jumlah: jumlah,
          hargaSatuan: hargaSatuan,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Berhasil')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTanggal = DateFormat('yyyy-MM-dd').format(selectedTanggal);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pembelian')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedTanggal,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != selectedTanggal) {
                          setState(() {
                            selectedTanggal = picked;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Tanggal (yyyy-MM-dd)',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(text: formattedTanggal),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Tanggal wajib diisi' : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Pilih Pemasok'),
                      items: pemasokList
                          .map((p) => DropdownMenuItem(
                                value: p.idPemasok,
                                child: Text(p.nama),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedPemasokId = val),
                      validator: (val) => val == null ? 'Pemasok wajib dipilih' : null,
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    const Text('Detail Obat', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    ...detailPembelian.asMap().entries.map((entry) {
                      final index = entry.key;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DropdownButtonFormField<int>(
                                value: detailPembelian[index]['id_obat'],
                                decoration: const InputDecoration(labelText: 'Obat'),
                                items: obatList
                                    .map((obat) => DropdownMenuItem(
                                          value: obat.idObat,
                                          child: Text(obat.namaObat),
                                        ))
                                    .toList(),
                                onChanged: (val) => onObatChanged(val, index),
                                validator: (val) =>
                                    val == null ? 'Obat wajib dipilih' : null,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Jumlah'),
                                keyboardType: TextInputType.number,
                                controller: jumlahControllers[index],
                                validator: (val) =>
                                    val == null || val.isEmpty ? 'Jumlah wajib diisi' : null,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Harga Satuan'),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                controller: hargaSatuanControllers[index],
                                onChanged: (val) => onHargaSatuanChanged(val, index),
                                validator: (val) =>
                                    val == null || val.isEmpty ? 'Harga wajib diisi' : null,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeDetailField(index),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    ElevatedButton.icon(
                      onPressed: addDetailField,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Obat'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Simpan Pembelian'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
