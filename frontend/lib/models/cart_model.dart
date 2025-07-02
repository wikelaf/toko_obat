import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'Obat_Model.dart';

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Tambah ke keranjang
  void addToCart(ObatModel obat) {
    final index = _items.indexWhere((item) => item.obat.idObat == obat.idObat);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(obat: obat, quantity: 1));
    }
    notifyListeners();
  }

  // Hapus dari keranjang
  void removeFromCart(ObatModel obat) {
    _items.removeWhere((item) => item.obat.idObat == obat.idObat);
    notifyListeners();
  }

  // Menghapus semua isi keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // 🔽 Mendapatkan jumlah item tertentu
  int getQuantity(ObatModel obat) {
    final index = _items.indexWhere((item) => item.obat.idObat == obat.idObat);
    return index >= 0 ? _items[index].quantity : 0;
  }

  // 🔽 Mengurangi quantity
  void decreaseQuantity(ObatModel obat) {
    final index = _items.indexWhere((item) => item.obat.idObat == obat.idObat);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
}
