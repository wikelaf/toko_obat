import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Penjualan_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiPenjualan {
  static const String baseUrl = 'http://10.98.206.67:8000/api/penjualan';

  // Ambil semua data penjualan
  static Future<List<PenjualanModel>> fetchPenjualan() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => PenjualanModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data penjualan');
    }
  }

  // Tambah data penjualan baru
  static Future<Map<String, dynamic>> createPenjualan({
    required String tanggal,
    required int idPelanggan,
    required List<int> obatId,
    required List<int> jumlah,
    required List<double> hargaSatuan,
    required double bayar,
    required double kembalian,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tanggal': tanggal,
        'id_pelanggan': idPelanggan,
        'obat_id': obatId,
        'jumlah': jumlah,
        'harga_satuan': hargaSatuan,
        'bayar': bayar,
        'kembalian': kembalian,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Gagal menambahkan penjualan: ${response.body}');
      return {'message': 'Gagal menambahkan penjualan'};
    }
  }

  // Hapus data penjualan
  static Future<bool> deletePenjualan(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal menghapus penjualan: ${response.body}');
      return false;
    }
  }

  // Detail penjualan berdasarkan ID
  static Future<PenjualanModel> getPenjualanDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return PenjualanModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil detail penjualan');
    }
  }

   // Ambil riwayat pembelian berdasarkan pelanggan
  static Future<List<PenjualanModel>> fetchRiwayatByPelanggan() async {
  final prefs = await SharedPreferences.getInstance();
  final idPelanggan = prefs.getInt('pelanggan_id'); // pastikan ini key yang benar

  if (idPelanggan == null) {
    throw Exception('ID pelanggan tidak ditemukan di SharedPreferences');
  }

  final response = await http.get(
    Uri.parse('http://10.98.206.67:8000/api/penjualan/pelanggan/$idPelanggan'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => PenjualanModel.fromJson(json)).toList();
  } else {
    throw Exception('Gagal memuat riwayat pembelian');
  }
}

}
