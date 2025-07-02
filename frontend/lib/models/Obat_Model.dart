class ObatModel {
  final int idObat;
  final String namaObat;
  final int stok;
  final double hargaBeli;
  final double hargaJual;
  final String expiredDate;
  final String foto;
  final String createdAt;
  final String updatedAt;

  ObatModel({
    required this.idObat,
    required this.namaObat,
    required this.stok,
    required this.hargaBeli,
    required this.hargaJual,
    required this.expiredDate,
    required this.foto,
    required this.createdAt,
    required this.updatedAt,
  });

  ObatModel copyWith({
    int? idObat,
    String? namaObat,
    int? stok,
    double? hargaBeli,
    double? hargaJual,
    String? expiredDate,
    String? foto,
    String? createdAt,
    String? updatedAt,
  }) {
    return ObatModel(
      idObat: idObat ?? this.idObat,
      namaObat: namaObat ?? this.namaObat,
      stok: stok ?? this.stok,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      expiredDate: expiredDate ?? this.expiredDate,
      foto: foto ?? this.foto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ObatModel.fromJson(Map<String, dynamic> json) {
    return ObatModel(
      idObat: json['id_obat'],
      namaObat: json['nama_obat'],
      stok: json['stok'],
      hargaBeli: double.parse(json['harga_beli'].toString()),
      hargaJual: double.parse(json['harga_jual'].toString()),
      expiredDate: json['expired_date'],
      foto: json['foto'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }


  /// Tambahkan ini:
  String get fullFotoUrl {
    if (foto.startsWith('http')) {
      return foto;
    } else {
      return 'http://192.168.241.67:8000/storage/$foto'; // sesuaikan IP dan path
    }
  }
}
