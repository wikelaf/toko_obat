import 'Obat_Model.dart';

class PenjualanDetailModel {
  final int idDetail;
  final int idPenjualan;
  final int idObat;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;
  final ObatModel? obat;

  PenjualanDetailModel({
    required this.idDetail,
    required this.idPenjualan,
    required this.idObat,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
    this.obat,
  });

  factory PenjualanDetailModel.fromJson(Map<String, dynamic> json) {
    return PenjualanDetailModel(
      idDetail: json['id_detail'],
      idPenjualan: json['id_penjualan'],
      idObat: json['id_obat'],
      jumlah: json['jumlah'],
      hargaSatuan: double.parse(json['harga_satuan'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
      obat: json['obat'] != null ? ObatModel.fromJson(json['obat']) : null,
    );
  }
}
