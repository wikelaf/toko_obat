import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPelangganPage extends StatefulWidget {
  @override
  _RegisterPelangganPageState createState() => _RegisterPelangganPageState();
}

class _RegisterPelangganPageState extends State<RegisterPelangganPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerPelanggan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final url = Uri.parse('http://10.98.206.67:8000/api/register-pelanggan'); // ganti IP sesuai server kamu

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': namaController.text,
        'alamat': alamatController.text,
        'telepon': teleponController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      }),
    );

    setState(() => isLoading = false);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context); // kembali ke halaman login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message'] ?? 'Registrasi gagal'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrasi Pelanggan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(namaController, 'Nama'),
              buildTextField(alamatController, 'Alamat'),
              buildTextField(teleponController, 'Telepon', keyboardType: TextInputType.phone),
              buildTextField(emailController, 'Email', keyboardType: TextInputType.emailAddress),
              buildTextField(passwordController, 'Password', obscureText: true),
              buildTextField(confirmPasswordController, 'Konfirmasi Password', obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _registerPelanggan,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }
}
