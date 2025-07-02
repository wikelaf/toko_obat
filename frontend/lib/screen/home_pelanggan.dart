import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Obat_Provider.dart';
import '../models/cart_model.dart';
import 'apknya/cart_page.dart';
import 'apknya/profile_pelanggan.dart';
import 'apknya/info_toko.dart';
import 'apknya/riwayat_pembelian.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePelangganScreen extends StatefulWidget {
  const HomePelangganScreen({super.key});

  @override
  State<HomePelangganScreen> createState() => _HomePelangganScreenState();
}

class _HomePelangganScreenState extends State<HomePelangganScreen> {
  String? namaPelanggan;

  @override
  void initState() {
    super.initState();
    _loadPelangganData();
    final obatProvider = Provider.of<ObatProvider>(context, listen: false);
    obatProvider.fetchObat(); // fetch data saat awal buka halaman
  }

  Future<void> _loadPelangganData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaPelanggan = prefs.getString('pelanggan_nama') ?? 'Pelanggan';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final obatProvider = Provider.of<ObatProvider>(context);
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: Row(
          children: [
            const Icon(Icons.local_pharmacy, color: Colors.blue),
            const SizedBox(width: 8),
            Text('Toko Obat', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.blue),
            onPressed: () async {
              // Setelah kembali dari cart page, refresh obat agar stok terupdate
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
              await obatProvider.fetchObat();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text('Selamat datang,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(namaPelanggan ?? '', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Profile'),
              onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePelangganScreen()),
              );

              if (result == true) {
                await _loadPelangganData(); // Refresh nama dari SharedPreferences
                setState(() {});            // Memicu rebuild UI
              }
            },

            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('Riwayat Pembelian'),
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RiwayatPembelianScreen()),
              );
            },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('Info Toko'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoTokoScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Selamat datang di Toko Obat, $namaPelanggan! Temukan dan beli obat dengan mudah.',
                        style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Daftar Obat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            Expanded(
              child: obatProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: obatProvider.listObat.length,
                      itemBuilder: (context, index) {
                        final obat = obatProvider.listObat[index];
                        final quantity = cart.getQuantity(obat);

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: obat.foto.isNotEmpty
                                        ? Image.network(obat.foto, height: 90, width: double.infinity, fit: BoxFit.cover)
                                        : Container(
                                            height: 90,
                                            width: double.infinity,
                                            color: Colors.blue[100],
                                            child: const Icon(Icons.medical_services, size: 40, color: Colors.blue),
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    obat.namaObat,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Harga: Rp${obat.hargaJual}', style: const TextStyle(color: Colors.black54)),
                                  Text('Expired: ${obat.expiredDate}', style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                                  Text('Stok: ${obat.stok}', style: const TextStyle(color: Colors.green, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: quantity == 0
                                        ? CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.blue,
                                            child: IconButton(
                                              icon: const Icon(Icons.add, size: 18, color: Colors.white),
                                              onPressed: () {
                                                cart.addToCart(obat);
                                              },
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove, size: 18),
                                                  onPressed: () {
                                                    cart.decreaseQuantity(obat);
                                                  },
                                                ),
                                                Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                IconButton(
                                                  icon: const Icon(Icons.add, size: 18),
                                                  onPressed: () {
                                                    cart.addToCart(obat);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
