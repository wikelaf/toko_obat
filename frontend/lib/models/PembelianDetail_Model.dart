import 'Obat_Model.dart';

class PembelianDetailModel {
  final int id;
  final int idPembelian;
  final int idObat;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;
  final ObatModel? obat;

  PembelianDetailModel({
    required this.id,
    required this.idPembelian,
    required this.idObat,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
    this.obat,
  });

  factory PembelianDetailModel.fromJson(Map<String, dynamic> json) {
    // Fungsi bantu untuk parsing num atau string jadi double
    double parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Fungsi bantu untuk parsing int dari dynamic
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    return PembelianDetailModel(
      id: parseInt(json['id']),
      idPembelian: parseInt(json['id_pembelian']),
      idObat: parseInt(json['id_obat']),
      jumlah: parseInt(json['jumlah']),
      hargaSatuan: parseDouble(json['harga_satuan']),
      subtotal: parseDouble(json['subtotal']),
      obat: json['obat'] != null ? ObatModel.fromJson(json['obat']) : null,
    );
  }
}
