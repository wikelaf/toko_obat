import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'User';
  String _email = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';

    setState(() {
      if (role == 'pelanggan') {
        _userName = prefs.getString('pelanggan_nama') ?? 'User';
        _email = prefs.getString('pelanggan_email') ?? 'Email tidak tersedia';
      } else if (role == 'admin') {
        _userName = prefs.getString('user_name') ?? 'Admin';
        _email = prefs.getString('user_email') ?? 'Email tidak tersedia';
      } else {
        _userName = 'User';
        _email = 'Email tidak tersedia';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.primaryColor.withOpacity(0.15),
                    child: Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1, height: 32),
                  const ListTile(
                    leading: Icon(Icons.person, color: Colors.blueGrey),
                    title: Text('Profil Pengguna'),
                    subtitle: Text('Lihat dan kelola data akun Anda'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.email, color: Colors.blueGrey),
                    title: Text('Email'),
                    subtitle: Text('Alamat email terdaftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
