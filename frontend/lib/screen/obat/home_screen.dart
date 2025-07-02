import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Obat_Model.dart';
import '../../services/api_service.dart';
import 'add_obat.dart';
import 'edit_obat.dart';
import 'hapus_obat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ObatModel>> futureObat;

  @override
  void initState() {
    super.initState();
    futureObat = ApiService.fetchObat();
  }

  void refreshData() {
    setState(() {
      futureObat = ApiService.fetchObat();
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Obat'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshData,
          ),
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () => logout(context),
          //   tooltip: 'Logout',
          // ),
        ],
      ),
      body: FutureBuilder<List<ObatModel>>(
        future: futureObat,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final obat = data[index];
                return Slidable(
                  key: ValueKey(obat.idObat),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) => HapusObatScreen(obat: obat),
                          );
                          if (result == true) refreshData();
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Hapus',
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Row(
                        children: [
                          // Foto kotak
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: obat.foto.isNotEmpty
                                ? Image.network(
                                    obat.foto,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.medical_services, size: 40, color: Colors.grey),
                                  )
                                : Icon(Icons.medical_services, size: 40, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  obat.namaObat,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text('Stok: ${obat.stok}'),
                                Text('Harga Jual: Rp ${obat.hargaJual}'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Edit',
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditObatScreen(obat: obat),
                                ),
                              );
                              if (result == true) refreshData();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddObatScreen()),
          );
          if (result == true) {
            refreshData();
          }
        },
      ),
    );
  }
}
