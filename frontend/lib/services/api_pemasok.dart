import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Pemasok_Model.dart';

class ApiPemasok {
  static const String baseUrl = 'http://10.22.112.67:8000/api/pemasok';

  // Ambil semua data pemasok
  static Future<List<PemasokModel>> fetchPemasok() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => PemasokModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data pemasok');
    }
  }

  // Tambah pemasok baru
  static Future<bool> createPemasok(PemasokModel pemasok) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': pemasok.nama,
        'alamat': pemasok.alamat,
        'telepon': pemasok.telepon,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Gagal menambahkan pemasok: ${response.body}');
      return false;
    }
  }

  // Update pemasok
  static Future<bool> updatePemasok(PemasokModel pemasok) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${pemasok.idPemasok}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': pemasok.nama,
        'alamat': pemasok.alamat,
        'telepon': pemasok.telepon,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Update gagal: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  // Hapus pemasok
  static Future<bool> deletePemasok(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal menghapus pemasok: ${response.body}');
      return false;
    }
  }
}
