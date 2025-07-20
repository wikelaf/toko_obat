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

    String baseUrl = 'http://10.98.206.67:8000';
    String url;

    if (role == 'admin') {
      url = '$baseUrl/api/change-password-user';
    } else if (role == 'pelanggan') {
      url = '$baseUrl/api/change-password';
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
      backgroundColor: Color(0xFFEFF4FF), // Background soft blue
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text('Ganti Password', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.lock_reset, size: 64, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    'Perbarui Password Anda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  _buildPasswordField(
                    controller: currentPasswordController,
                    label: 'Password Saat Ini',
                    icon: Icons.lock_outline,
                  ),
                  SizedBox(height: 16),
                  _buildPasswordField(
                    controller: newPasswordController,
                    label: 'Password Baru',
                    icon: Icons.lock_reset,
                  ),
                  SizedBox(height: 16),
                  _buildPasswordField(
                    controller: confirmNewPasswordController,
                    label: 'Konfirmasi Password Baru',
                    icon: Icons.verified_user_outlined,
                    validator: (value) =>
                        value != newPasswordController.text ? 'Password tidak sama' : null,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator ??
          (value) =>
              value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: label,
        filled: true,
        fillColor: Color(0xFFF7F7F7),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}