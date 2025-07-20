import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen/home_page.dart';
import 'screen/login.dart';
import 'screen/home_pelanggan.dart';
import 'screen/change_password_page.dart';
import 'screen/menu_user/profile_page.dart';
import 'models/cart_model.dart';
import 'models/Obat_Provider.dart'; // Import ObatModelProvider



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()), // ← tambahkan CartModel
         ChangeNotifierProvider(create: (_) => ObatProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Data Obat',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/homePelanggan': (context) => HomePelangganScreen(),
        '/login': (context) => LoginPage(),
         '/change-password': (context) => ChangePasswordPage(),
          '/profile': (context) => const ProfilePage(),
      },

      /// ⬇️ Tampilkan halaman login **langsung** saat app dibuka
      home: LoginPage(),
    );
  }
}
