import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'register_pelanggan.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  String error = '';

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = '';
    });

    final email = emailController.text.trim();
    final password = passwordController.text;
    final prefs = await SharedPreferences.getInstance();

    try {
      // 1. Coba login sebagai Admin/User
      final userResponse = await http.post(
        Uri.parse('http://192.168.241.67:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (userResponse.statusCode == 200) {
        final data = jsonDecode(userResponse.body);
        await prefs.setString('token', data['token']);
        await prefs.setString('role', 'admin');
        await prefs.setString('user_name', data['user']['name']);
          await prefs.setString('user_email', data['user']['email'] ?? '');
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      // 2. Jika gagal, coba login sebagai pelanggan
      final pelangganResponse = await http.post(
        Uri.parse('http://192.168.241.67:8000/api/login-pelanggan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (pelangganResponse.statusCode == 200) {
        final data = jsonDecode(pelangganResponse.body);
        await prefs.setString('token', data['token']);
        await prefs.setString('role', 'pelanggan');
        final pelanggan = data['pelanggan'];
        await prefs.setInt('pelanggan_id', pelanggan['id_pelanggan']);
        await prefs.setString('pelanggan_nama', pelanggan['nama'] ?? '');
        await prefs.setString('pelanggan_email', pelanggan['email'] ?? '');
        await prefs.setString('pelanggan_alamat', pelanggan['alamat'] ?? '');
        await prefs.setString('pelanggan_telepon', pelanggan['telepon'] ?? '');
        Navigator.pushReplacementNamed(context, '/homePelanggan');
        return;
      }

      setState(() => error = 'Email atau password tidak dikenali');
    } catch (e) {
      setState(() => error = 'Terjadi kesalahan. Periksa koneksi dan coba lagi.');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, size: 64, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),

                    /// Email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    /// Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password wajib diisi';
                        if (value.length < 6) return 'Password minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {}, // Buat halaman lupa password jika dibutuhkan
                        child: const Text("Lupa password?"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Tombol Login
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ),

                    const SizedBox(height: 12),

                      /// Tombol Daftar
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPelangganPage()),
                          );
                        },
                        child: const Text("Belum punya akun? Daftar di sini"),
                      ),

                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(error, style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
