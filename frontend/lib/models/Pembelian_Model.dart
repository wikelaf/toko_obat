// import 'Pemasok_Model.dart';
// import 'PembelianDetail_Model.dart';

// class PembelianModel {
//   final int idPembelian;
//   final String tanggal;
//   final int idPemasok;
//   final double totalHarga;
//   final PemasokModel? pemasok;
//   final List<PembelianDetailModel> pembelianDetails;

//   PembelianModel({
//     required this.idPembelian,
//     required this.tanggal,
//     required this.idPemasok,
//     required this.totalHarga,
//     this.pemasok,
//     required this.pembelianDetails,
//   });

//   factory PembelianModel.fromJson(Map<String, dynamic> json) {
//     return PembelianModel(
//       idPembelian: json['id_pembelian'],
//       tanggal: json['tanggal'],
//       idPemasok: json['id_pemasok'],
//       totalHarga: (json['total_harga'] as num).toDouble(),
//       pemasok: json['pemasok'] != null
//           ? PemasokModel.fromJson(json['pemasok'])
//           : null,
//       pembelianDetails: (json['pembelian_details'] as List)
//           .map((item) => PembelianDetailModel.fromJson(item))
//           .toList(),
//     );
//   }
// }

import 'Pemasok_Model.dart';
import 'PembelianDetail_Model.dart';

class PembelianModel {
  final int idPembelian;
  final String tanggal;
  final int idPemasok;
  final double totalHarga;
  final PemasokModel? pemasok;
  final List<PembelianDetailModel> pembelianDetails;

  PembelianModel({
    required this.idPembelian,
    required this.tanggal,
    required this.idPemasok,
    required this.totalHarga,
    this.pemasok,
    required this.pembelianDetails,
  });

  factory PembelianModel.fromJson(Map<String, dynamic> json) {
  var detailsJson = json['pembelian_details'] as List<dynamic>? ?? [];

  return PembelianModel(
    idPembelian: json['id_pembelian'],
    tanggal: json['tanggal'],
    idPemasok: json['id_pemasok'],
    totalHarga: double.tryParse(json['total_harga'].toString()) ?? 0.0,
    pemasok: json['pemasok'] != null ? PemasokModel.fromJson(json['pemasok']) : null,
    pembelianDetails: detailsJson.map((item) => PembelianDetailModel.fromJson(item)).toList(),
  );
}

}

