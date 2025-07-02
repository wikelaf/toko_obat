import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_item.dart';
import '../../services/api_penjualan.dart';
import '../../models/cart_model.dart';
import '../../models/Obat_Provider.dart';

class TransaksiPage extends StatefulWidget {
  final List<CartItem> cartItems;
  const TransaksiPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  String alamat = '';
  late TextEditingController alamatController;
  String metodePembayaran = 'COD';
  bool showStruk = false;
  bool showDanaInfo = false;

  double totalHargaStruk = 0;

  int get totalHarga => widget.cartItems.fold(
      0, (total, item) => total + (item.obat.hargaJual * item.quantity).toInt());

  @override
  void initState() {
    super.initState();
    alamatController = TextEditingController();
    _loadAlamat();
  }

  Future<void> _loadAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    String savedAlamat = prefs.getString('pelanggan_alamat') ?? '';
    setState(() {
      alamat = savedAlamat;
      alamatController.text = savedAlamat;
    });
  }

  @override
  void dispose() {
    alamatController.dispose();
    super.dispose();
  }

  Future<void> _submitTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    final idPelanggan = prefs.getInt('pelanggan_id');

    if (idPelanggan == null || alamat.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID pelanggan atau alamat tidak valid')),
      );
      return;
    }

    final tanggal = DateTime.now().toIso8601String();
    final obatId = widget.cartItems.map((item) => item.obat.idObat).toList();
    final jumlah = widget.cartItems.map((item) => item.quantity).toList();
    final hargaSatuan =
        widget.cartItems.map((item) => item.obat.hargaJual.toDouble()).toList();
    final bayar = totalHarga.toDouble();
    final kembalian = bayar - totalHarga;

    try {
      final result = await ApiPenjualan.createPenjualan(
        tanggal: tanggal,
        idPelanggan: idPelanggan,
        obatId: obatId,
        jumlah: jumlah,
        hargaSatuan: hargaSatuan,
        bayar: bayar,
        kembalian: kembalian,
      );

      if (result['message'] == 'Penjualan berhasil disimpan') {
        final cart = Provider.of<CartModel>(context, listen: false);
        final obatProvider = Provider.of<ObatProvider>(context, listen: false);

        cart.clearCart();
        await obatProvider.fetchObat();

        setState(() {
          totalHargaStruk = bayar;
          showStruk = true;
          showDanaInfo = metodePembayaran == 'DANA';
        });

        await prefs.setString('pelanggan_alamat', alamat);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(result['message'] ?? 'Terjadi kesalahan saat menyimpan transaksi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan transaksi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showStruk) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blue),
          title:
              const Text('Struk Pembelian', style: TextStyle(color: Colors.blue)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.receipt_long, color: Colors.blue, size: 32),
                      SizedBox(width: 10),
                      Text('Struk Pembelian',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ],
                  ),
                  const Divider(height: 32),
                  ...widget.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text('${item.obat.namaObat} x${item.quantity}',
                                    style: const TextStyle(fontSize: 16))),
                            Text(
                                'Rp${(item.obat.hargaJual * item.quantity).toStringAsFixed(0)}',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Rp${totalHargaStruk.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('Alamat: $alamat',
                              style: const TextStyle(fontSize: 15))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.payment, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Metode: $metodePembayaran',
                          style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                  if (showDanaInfo)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Silahkan bayar ke nomor DANA berikut ini:\n081268012191\nJika tidak membayar dalam 2 hari, pesanan batal.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text('Transaksi', style: TextStyle(color: Colors.blue)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.blue, size: 28),
                      SizedBox(width: 8),
                      Text('Obat yang Dibeli:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...widget.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text('${item.obat.namaObat} x${item.quantity}',
                                    style: const TextStyle(fontSize: 15))),
                            Text('Rp${item.obat.hargaJual.toStringAsFixed(0)}',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Rp$totalHarga',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Alamat Pengiriman:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: alamatController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan alamat anda',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() => alamat = val),
                  ),
                  const SizedBox(height: 16),
                  const Text('Metode Pembayaran:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'COD',
                        groupValue: metodePembayaran,
                        onChanged: (val) => setState(() => metodePembayaran = val!),
                      ),
                      const Text('COD'),
                      Radio<String>(
                        value: 'DANA',
                        groupValue: metodePembayaran,
                        onChanged: (val) => setState(() => metodePembayaran = val!),
                      ),
                      const Text('DANA'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                      icon: const Icon(Icons.check_circle, size: 22),
                      label:
                          const Text('Konfirmasi Pembelian', style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Konfirmasi Alamat'),
                            content: const Text('Apakah alamat sudah benar?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Iya'),
                              ),
                            ],
                          ),
                        );
                        if (result == true) {
                          await _submitTransaksi();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
