class PemasokModel {
  final int idPemasok;
  final String nama;
  final String alamat;
  final String telepon;
  final String createdAt;
  final String updatedAt;

  PemasokModel({
    required this.idPemasok,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PemasokModel.fromJson(Map<String, dynamic> json) {
    return PemasokModel(
      idPemasok: json['id_pemasok'],
      nama: json['nama'],
      alamat: json['alamat'] ?? '',
      telepon: json['telepon'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_pemasok': idPemasok,
        'nama': nama,
        'alamat': alamat,
        'telepon': telepon,
      };
}
