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
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    setState(() {
      _role = role;
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

  Future<void> _editField(String title, String currentValue, Function(String) onSave) async {
    final controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Masukkan $title baru',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    if (_role == 'pelanggan') {
      await prefs.setString('pelanggan_nama', newName);
    } else if (_role == 'admin') {
      await prefs.setString('user_name', newName);
    }
    setState(() {
      _userName = newName;
    });
  }

  Future<void> _updateEmail(String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    if (_role == 'pelanggan') {
      await prefs.setString('pelanggan_email', newEmail);
    } else if (_role == 'admin') {
      await prefs.setString('user_email', newEmail);
    }
    setState(() {
      _email = newEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0ECFF), Color(0xFFF7F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Text(
                    'Profil Saya',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 10,
                    shadowColor: Colors.blueGrey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            child: Text(
                              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Divider(thickness: 1.2, color: Colors.grey[300]),
                          const SizedBox(height: 12),

                          // Nama
                          ListTile(
                            leading: const Icon(Icons.person_outline, color: Colors.blueAccent),
                            title: const Text('Nama'),
                            subtitle: Text(_userName),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _editField('Nama', _userName, _updateName),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            tileColor: Colors.blueAccent.withOpacity(0.04),
                          ),
                          const SizedBox(height: 12),

                          // Email
                          ListTile(
                            leading: const Icon(Icons.email_outlined, color: Colors.blueAccent),
                            title: const Text('Email'),
                            subtitle: Text(_email),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _editField('Email', _email, _updateEmail),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            tileColor: Colors.blueAccent.withOpacity(0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Versi Aplikasi 1.0.0',
                    style: TextStyle(
                      color: Colors.blueGrey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
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
}
