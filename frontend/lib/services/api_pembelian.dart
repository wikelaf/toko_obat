import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Pembelian_Model.dart';

class ApiPembelian {
  static const String baseUrl = 'http://10.22.112.67:8000/api/pembelian';

  // Ambil semua data pembelian
  static Future<List<PembelianModel>> fetchPembelian() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Jika data dibungkus dalam objek, misalnya: { "data": [ ... ] }
        if (data is Map && data.containsKey('data')) {
          final List<dynamic> pembelianList = data['data'];
          return pembelianList.map((json) => PembelianModel.fromJson(json)).toList();
        }

        // Jika langsung berupa list
        if (data is List) {
          return data.map((json) => PembelianModel.fromJson(json)).toList();
        }

        throw Exception('Format data tidak dikenali');
      } else {
        throw Exception('Gagal memuat data pembelian: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data pembelian: $e');
    }
  }

  // Ambil detail pembelian berdasarkan ID
  static Future<Map<String, dynamic>> fetchPembelianById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Data pembelian tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil detail pembelian: $e');
    }
  }

  // Tambah pembelian baru
  static Future<Map<String, dynamic>> createPembelian({
    required int idPemasok,
    required String tanggal,
    required List<int> idObat,
    required List<int> jumlah,
    required List<double> hargaSatuan,
  }) async {
    try {
      final body = jsonEncode({
        'id_pemasok': idPemasok,
        'tanggal': tanggal,
        'id_obat': idObat,
        'jumlah': jumlah,
        'harga_satuan': hargaSatuan,
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal menambahkan pembelian: ${response.body}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan pembelian: $e');
    }
  }

  // Hapus pembelian berdasarkan ID
  static Future<bool> deletePembelian(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Gagal menghapus pembelian: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saat hapus pembelian: $e');
      return false;
    }
  }
}
