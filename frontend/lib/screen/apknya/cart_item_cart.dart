import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  const CartItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.obat.foto.isNotEmpty
              ? Image.network(item.obat.fullFotoUrl,
                  width: 60, height: 60, fit: BoxFit.cover)
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.blue[100],
                  child: const Icon(Icons.medical_services,
                      size: 32, color: Colors.blue),
                ),
        ),
        title: Text(item.obat.namaObat,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga: Rp${item.obat.hargaJual.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.black54)),
            Text('Expired: ${item.obat.expiredDate}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            Text('Jumlah: ${item.quantity}',
                style: const TextStyle(color: Colors.blue)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            cart.removeFromCart(item.obat);
          },
        ),
      ),
    );
  }
}
