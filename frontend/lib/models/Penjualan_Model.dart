import 'PenjualanDetail_Model.dart';
import 'Pelanggan_Model.dart'; // kalau ada model Pelanggan

class PenjualanModel {
  final int idPenjualan;
  final String tanggal;
  final int idPelanggan;
  final double totalHarga;
  final double bayar;
  final double kembalian;
  final PelangganModel? pelanggan;
  final List<PenjualanDetailModel> penjualanDetails;

  PenjualanModel({
    required this.idPenjualan,
    required this.tanggal,
    required this.idPelanggan,
    required this.totalHarga,
    required this.bayar,
    required this.kembalian,
    this.pelanggan,
    required this.penjualanDetails,
  });

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    var list = json['penjualan_details'] as List<dynamic>? ?? [];
    List<PenjualanDetailModel> details = list.map((e) => PenjualanDetailModel.fromJson(e)).toList();

    return PenjualanModel(
      idPenjualan: json['id_penjualan'],
      tanggal: json['tanggal'],
      idPelanggan: json['id_pelanggan'],
      totalHarga: double.parse(json['total_harga'].toString()),
      bayar: double.parse(json['bayar'].toString()),
      kembalian: double.parse(json['kembalian'].toString()),
      pelanggan: json['pelanggan'] != null ? PelangganModel.fromJson(json['pelanggan']) : null,
      penjualanDetails: details,
    );
  }
}
