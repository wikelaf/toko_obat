import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User_Model.dart';

class ApiUser {
  static const String baseUrl = 'http://192.168.241.67:8000/api/user';

  // Ambil semua data user
  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data user');
    }
  }

  // Tambah user baru, password dikirim terpisah
  static Future<bool> createUser(UserModel user, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Gagal menambahkan user: ${response.body}');
      return false;
    }
  }

  // Update user, password opsional (kalau null tidak dikirim)
  static Future<bool> updateUser(UserModel user, String? password) async {
    final Map<String, dynamic> bodyData = {
      'name': user.name,
      'email': user.email,
    };

    if (password != null && password.isNotEmpty) {
      bodyData['password'] = password;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Update gagal: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  // Hapus user
  static Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal menghapus user: ${response.body}');
      return false;
    }
  }
}
