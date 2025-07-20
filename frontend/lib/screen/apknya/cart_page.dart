import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import 'transaksi_page.dart';
import '../apknya/cart_item_cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    double totalHarga = cart.items.fold(
        0, (total, item) => total + (item.obat.hargaJual * item.quantity));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.blue),
            const SizedBox(width: 8),
            Text('Keranjang',
                style: TextStyle(
                    color: Colors.blue[800], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text('Keranjang kosong',
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return CartItemCard(item: item);
              },
            ),
      bottomNavigationBar: cart.items.isNotEmpty
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total: Rp${totalHarga.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.payment, size: 20),
                    label:
                        const Text('Beli Obat', style: TextStyle(fontSize: 16)),
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content:
                              const Text('Anda yakin melakukan pembelian?'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TransaksiPage(cartItems: cart.items)),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
