import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Obat_Model.dart'; // class ObatModel yang berisi struktur data satuan obat

class ObatProvider extends ChangeNotifier {
  List<ObatModel> _listObat = [];
  bool _isLoading = false;

  List<ObatModel> get listObat => _listObat;
  bool get isLoading => _isLoading;

  Future<void> fetchObat() async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await http.get(Uri.parse('http://192.168.241.67:8000/api/obat'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _listObat = data.map((json) => ObatModel.fromJson(json)).toList();
    } else {
      _listObat = [];
      // Bisa tambahkan log error atau throw exception
    }
  } catch (e) {
    _listObat = [];
    // Bisa log error: print('Error fetchObat: $e');
  }

  _isLoading = false;
  notifyListeners();
}

}
