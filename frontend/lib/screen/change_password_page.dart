import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');

    if (token == null || role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token atau role tidak ditemukan. Silakan login ulang.')),
      );
      return;
    }

    String baseUrl = 'http://192.168.241.67:8000';
    String url;

    if (role == 'admin') {
      url = '$baseUrl/api/change-password';
    } else if (role == 'pelanggan') {
      url = '$baseUrl/api/pelanggan/change-password';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role tidak dikenali')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'current_password': currentPasswordController.text,
        'new_password': newPasswordController.text,
        'new_password_confirmation': confirmNewPasswordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Password berhasil diubah')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']?.toString() ?? 'Gagal mengubah password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ganti Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(labelText: 'Password Saat Ini'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 8 ? 'Minimal 8 karakter' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(labelText: 'Konfirmasi Password Baru'),
                obscureText: true,
                validator: (value) =>
                    value != newPasswordController.text ? 'Password tidak sama' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _changePassword,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
