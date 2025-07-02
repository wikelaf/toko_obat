import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Pelanggan_Model.dart';
import '../../services/api_pelanggan.dart';
import 'add_pelanggan.dart';
import 'edit_pelanggan.dart';
import 'hapus_pelanggan.dart';

class HomePelangganScreen extends StatefulWidget {
  const HomePelangganScreen({Key? key}) : super(key: key);

  @override
  State<HomePelangganScreen> createState() => _HomePelangganScreenState();
}

class _HomePelangganScreenState extends State<HomePelangganScreen> {
  late Future<List<PelangganModel>> futurePelanggan;

  @override
  void initState() {
    super.initState();
    futurePelanggan = ApiPelanggan.fetchPelanggan();
  }

  void refreshData() {
    setState(() {
      futurePelanggan = ApiPelanggan.fetchPelanggan();
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
        title: const Text('Data Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () => logout(context),
          //   tooltip: 'Logout',
          // ),
        ],
      ),
      body: FutureBuilder<List<PelangganModel>>(
        future: futurePelanggan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data pelanggan kosong'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pelanggan = data[index];
              return Slidable(
                key: ValueKey(pelanggan.idPelanggan),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => HapusPelangganScreen(pelanggan: pelanggan),
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
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   backgroundColor: Colors.grey[200],
                    //   child: Icon(Icons.person, color: Colors.grey[700]),
                    // ),
                    title: Text(
                      pelanggan.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alamat: ${pelanggan.alamat ?? "-"}'),
                        Text('Telepon: ${pelanggan.telepon ?? "-"}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPelangganScreen(pelanggan: pelanggan),
                          ),
                        );
                        if (result == true) refreshData();
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => AddPelangganScreen()),
          );
          if (result == true) refreshData();
        },
      ),
    );
  }
}
