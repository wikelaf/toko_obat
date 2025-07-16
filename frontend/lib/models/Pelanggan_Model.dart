class PelangganModel {
  final int idPelanggan;
  final String nama;
   final String email;
  final String password;
  final String alamat;
  final String telepon;
  final String createdAt;
  final String updatedAt;

  PelangganModel({
    required this.idPelanggan,
    required this.nama,
    required this.email,
    required this.password,
    required this.alamat,
    required this.telepon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      idPelanggan: json['id_pelanggan'],
      nama: json['nama'],
      email: json['email'] ?? '',
      password: json[''] ?? '',
      alamat: json['alamat'] ?? '',
      telepon: json['telepon'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

// class PelangganModel {
//   final int idPelanggan;
//   final String nama;
//   final String? alamat;
//   final String? telepon;
//   final String? createdAt;
//   final String? updatedAt;

//   PelangganModel({
//     required this.idPelanggan,
//     required this.nama,
//     this.alamat,
//     this.telepon,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory PelangganModel.fromJson(Map<String, dynamic> json) {
//     return PelangganModel(
//       idPelanggan: json['id_pelanggan'],
//       nama: json['nama'],
//       alamat: json['alamat'],
//       telepon: json['telepon'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id_pelanggan': idPelanggan,
//     'nama': nama,
//     'alamat': alamat,
//     'telepon': telepon,
//   };
// }
