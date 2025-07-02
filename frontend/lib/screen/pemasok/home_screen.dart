import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Pemasok_Model.dart';
import '../../services/api_pemasok.dart';
import 'add_pemasok.dart';
import 'edit_pemasok.dart';
import 'hapus_pemasok.dart';

class HomePemasokScreen extends StatefulWidget {
  const HomePemasokScreen({Key? key}) : super(key: key);

  @override
  State<HomePemasokScreen> createState() => _HomePemasokScreenState();
}

class _HomePemasokScreenState extends State<HomePemasokScreen> {
  late Future<List<PemasokModel>> futurePemasok;

  @override
  void initState() {
    super.initState();
    futurePemasok = ApiPemasok.fetchPemasok();
  }

  void refreshData() {
    setState(() {
      futurePemasok = ApiPemasok.fetchPemasok();
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
        title: const Text('Data Pemasok'),
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
      body: FutureBuilder<List<PemasokModel>>(
        future: futurePemasok,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data pemasok kosong'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pemasok = data[index];
              return Slidable(
                key: ValueKey(pemasok.idPemasok),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => HapusPemasokScreen(pemasok: pemasok),
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
                    title: Text(
                      pemasok.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alamat: ${pemasok.alamat}'),
                        Text('Telepon: ${pemasok.telepon}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPemasokScreen(pemasok: pemasok),
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
            MaterialPageRoute(builder: (context) => AddPemasokScreen()),
          );
          if (result == true) refreshData();
        },
      ),
    );
  }
}
