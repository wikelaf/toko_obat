import 'package:flutter/material.dart';

class InfoTokoScreen extends StatelessWidget {
  const InfoTokoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text('Info Toko', style: TextStyle(color: Colors.blue)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView( // Tambahkan scroll agar tidak overflow
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.blue[50],
                      child: const Icon(Icons.local_pharmacy, size: 48, color: Colors.blue),
                    ),
                    const SizedBox(height: 18),
                    const Text('Toko Obat Abadi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    const Text('"Melayani dengan sepenuh hati, obat berkualitas untuk keluarga Anda"',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const Divider(height: 32),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.blue),
                      title: const Text('Jl. Padang Pasir 1, Padang, Sumatera Barat'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text('tokoabadi@gmail.com'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blue),
                      title: const Text('0812-3456-7890'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_in_talk, color: Colors.blue),
                      title: const Text('(0751) 123456'),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Jam Operasional: 08.00 - 21.00 WIB\nMinggu & Hari Libur Tetap Buka',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
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
