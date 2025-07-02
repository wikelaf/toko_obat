import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import '../models/Obat_Model.dart';




class ApiService {
  static const String baseUrl = 'http://192.168.241.67:8000/api/obat';

  // Get all obat
  static Future<List<ObatModel>> fetchObat() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => ObatModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data obat: ${response.statusCode}');
    }
  }

  // Add obat
  static Future<bool> createObat(ObatModel obat, File? foto) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields['nama_obat'] = obat.namaObat;
    request.fields['stok'] = obat.stok.toString();
    request.fields['harga_beli'] = obat.hargaBeli.toString();
    request.fields['harga_jual'] = obat.hargaJual.toString();
    request.fields['expired_date'] = obat.expiredDate;

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    request.headers['Accept'] = 'application/json';

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = await response.stream.bytesToString();
      print('Gagal create obat: ${response.statusCode}, Body: $body');
      return false;
    }
  }

  // Edit obat
  static Future<bool> updateObat(ObatModel obat, File? foto) async {
    final uri = Uri.parse('$baseUrl/${obat.idObat}');
    var request = http.MultipartRequest('POST', uri);

    request.fields['nama_obat'] = obat.namaObat;
    request.fields['stok'] = obat.stok.toString();
    request.fields['harga_beli'] = obat.hargaBeli.toString();
    request.fields['harga_jual'] = obat.hargaJual.toString();
    request.fields['expired_date'] = obat.expiredDate;
    request.fields['_method'] = 'PUT';

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'foto',
        foto.path,
        filename: foto.path.split(Platform.pathSeparator).last,
      ));
    }

    request.headers['Accept'] = 'application/json';

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = await response.stream.bytesToString();
      print('Gagal update obat: ${response.statusCode}, Body: $body');
      return false;
    }
  }

  // Delete obat
  static Future<bool> deleteObat(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal delete obat: ${response.statusCode}, Body: ${response.body}');
      return false;
    }
  }

  // Login user
  static Future<String?> login(String email, String password) async {
    final url = 'http://192.168.241.67:8000/api/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  print('Login response data: $data');  // Tambahkan ini

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', data['token']);

  if (data.containsKey('user') && data['user'] != null) {
    print('User info: ${data['user']}'); // Tambahan print
    await prefs.setString('user_name', data['user']['name'] ?? 'User');
    await prefs.setString('user_email', data['user']['email'] ?? 'user@example.com');
  } else {
    await prefs.setString('user_name', 'User');
    await prefs.setString('user_email', 'user@example.com');
  }

  return data['token'];
}
else {
      print('Login gagal: ${response.statusCode}, Body: ${response.body}');
      return null;
    }
  }

  // Login pelanggan
  static Future<Map<String, dynamic>?> loginPelanggan(String email, String password) async {
    const url = 'http://192.168.241.67:8000/api/login-pelanggan';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'pelanggan': data['pelanggan'],
      };
    } else {
      print('Login pelanggan gagal: ${response.body}');
      return null;
    }
  }

  // Create Penjualan (Transaksi)
  static Future<bool> createPenjualan({
    required int idPelanggan,
    required String alamat,
    required String totalHarga,
    required String bayar,
    required String kembalian,
    required String metode,
    required List<Map<String, dynamic>> penjualanDetails,
  }) async {
    final url = 'http://192.168.241.67:8000/api/penjualan';
    final body = jsonEncode({
      'id_pelanggan': idPelanggan,
      'alamat': alamat,
      'total_harga': totalHarga,
      'bayar': bayar,
      'kembalian': kembalian,
      'metode': metode,
      'penjualan_details': penjualanDetails,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Gagal simpan penjualan:\nStatus: ${response.statusCode}\nBody: ${response.body}');
      return false;
    }
  }
}
