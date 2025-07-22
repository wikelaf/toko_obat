import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Pelanggan_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiPelanggan {
  static const String baseUrl = 'http://10.98.206.67:8000/api/pelanggan';

 
  // Ambil semua data pelanggan
  static Future<List<PelangganModel>> fetchPelanggan() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => PelangganModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data pelanggan');
    }
  }

  // Tambah pelanggan baru (wajib password)
  static Future<bool> createPelanggan(PelangganModel pelanggan) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': pelanggan.nama,
        'email': pelanggan.email,
        'password': pelanggan.password,
        'alamat': pelanggan.alamat,
        'telepon': pelanggan.telepon,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Gagal menambahkan pelanggan: ${response.body}');
      return false;
    }
  }

  // Update pelanggan (password opsional)
  static Future<bool> updatePelanggan(PelangganModel pelanggan, {String? password}) async {
    final Map<String, dynamic> bodyData = {
      'nama': pelanggan.nama,
      'email': pelanggan.email,
      'alamat': pelanggan.alamat,
      'telepon': pelanggan.telepon,
    };

    if (password != null && password.isNotEmpty) {
      bodyData['password'] = password;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${pelanggan.idPelanggan}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Update pelanggan gagal: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  // Update pelanggan by id
  static Future<bool> updatePelangganById({
    required int id,
    required String nama,
    required String email,
    required String alamat,
    required String telepon,
  }) async {
    final response = await http.put(
      Uri.parse('http://10.98.206.67:8000/api/pelanggan/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'alamat': alamat,
        'telepon': telepon,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Update pelanggan gagal: \\${response.body}');
      return false;
    }
  }

  // Hapus pelanggan
  static Future<bool> deletePelanggan(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal menghapus pelanggan: ${response.body}');
      return false;
    }
  }

  // Ubah password pelanggan
 static Future<bool> ubahPassword({
  required int id,
  required String oldPassword,
  required String newPassword,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) return false;

  final response = await http.put(
    Uri.parse('http://10.98.206.67:8000/api/change-password'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'current_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPassword,
    }),
  );

  print("Status: ${response.statusCode}");
  print("Body: ${response.body}");

  return response.statusCode == 200;
}

  // Fungsi lain seperti updatePelangganById() kamu taruh di sini juga
}


