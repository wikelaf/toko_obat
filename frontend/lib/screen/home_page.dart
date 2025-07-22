// File: home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'obat/home_screen.dart';
import 'pelanggan/home_screen.dart';
import 'pemasok/home_screen.dart';
import 'pembelian/home_screen.dart';
import 'penjualan/home_screen.dart';
import 'user/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'ID'; // ID or EN
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showProfileMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        offset & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil Saya'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Ganti Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/change-password');
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              logout(context);
            },
          ),
        ),
        const PopupMenuItem(
          child: Center(child: Text('Versi Aplikasi: 1.0.0', style: TextStyle(fontSize: 12))),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    String greeting;
    if (now.hour >= 5 && now.hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (now.hour >= 12 && now.hour < 15) {
      greeting = 'Selamat Siang';
    } else if (now.hour >= 15 && now.hour < 18) {
      greeting = 'Selamat Sore';
    } else {
      greeting = 'Selamat Malam';
    }

    return Scaffold(
      appBar: AppBar(
  title: const Text('Beranda'),
  leading: Builder(
    builder: (context) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final Offset offset = button.localToGlobal(Offset.zero);
          _showProfileMenu(context, offset);
        },
      );
    },
  ),
  // actions: []  // bisa dihapus jika kosong
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$greeting, $_userName!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                      fontSize: 18,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _menuButton(context, icon: Icons.medical_services, label: 'Obat', color: Colors.purple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()))),
                  _menuButton(context, icon: Icons.people, label: 'Pelanggan', color: Colors.indigo, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePelangganScreen()))),
                  _menuButton(context, icon: Icons.local_shipping, label: 'Pemasok', color: Colors.teal, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePemasokScreen()))),
                  _menuButton(context, icon: Icons.shopping_cart, label: 'Pembelian', color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePembelianScreen()))),
                  _menuButton(context, icon: Icons.point_of_sale, label: 'Penjualan', color: Colors.red, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePenjualanScreen()))),
                  _menuButton(context, icon: Icons.person, label: 'Data User', color: Colors.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeUserScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Aplikasi Toko Obat Abadi',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String count;

  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
