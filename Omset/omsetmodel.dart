class OmsetModel {
  final String urut;
  final String nama_regional;
  final double target_omset;
  final double target_volume;
  final double net_exc_ppn;
  final double persentase_bulan;
  final double nomor;

  bool selected = false;

  OmsetModel({this.urut
    , this.nama_regional
    , this.target_omset
    , this.target_volume
    , this.net_exc_ppn
    , this.persentase_bulan
    , this.nomor});

  factory OmsetModel.fromJson(Map<String, dynamic> json) {
    return new OmsetModel(
      urut: json['urut'],
      nama_regional: json['nama_regional'],
      target_omset: json['target_omset'] == null ? 0 : json['target_omset'].toDouble(),
      target_volume: json['target_volume'] == null ? 0 : json['target_volume'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase_bulan: json['persentase_bulan'] == null ? 0 : json['persentase_bulan'].toDouble(),
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
    );
  }
}

class OmsetTotalModel {
  final double target_omset;
  final double target_volume;
  final double net_exc_ppn;
  final double persentase;

  bool selected = false;

  OmsetTotalModel({ this.target_omset
    , this.target_volume
    , this.net_exc_ppn
    , this.persentase});

  factory OmsetTotalModel.fromJson(Map<String, dynamic> json) {
    return new OmsetTotalModel(
      target_omset: json['target_omset'] == null ? 0 : json['target_omset'].toDouble(),
      target_volume: json['target_volume'] == null ? 0 : json['target_volume'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
    );
  }
}

class OmsetAreaModel {
  final String kode_periode;
  final String nama_regional;
  final String area_key;
  final double target_value;
  final double target_volume;
  final double net_exc_ppn;
  final double persentase;
  final String nama_area;
  final String urut;
  final double nomor;

  bool selected = false;

  OmsetAreaModel({this.kode_periode
    , this.nama_regional
    , this.area_key
    , this.target_value
    , this.target_volume
    , this.net_exc_ppn
    , this.persentase
    , this.nama_area
    , this.urut
    , this.nomor});

  factory OmsetAreaModel.fromJson(Map<String, dynamic> json) {
    return new OmsetAreaModel(
      kode_periode: json['kode_periode'],
      nama_regional: json['nama_regional'],
      area_key: json['area_key'],
      target_value: json['target_value'] == null ? 0 : json['target_value'].toDouble(),
      target_volume: json['target_volume'] == null ? 0 : json['target_volume'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
      nama_area: json['nama_area'],
      urut: json['urut'],
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
    );
  }
}

class OmsetSalesModel {
  final String kode_periode;
  final String kode_regional;
  final String nama_regional;
  final String area_key;
  final String nik;
  final String nama_sales;
  final double target_tagih;
  final double tunai;
  final double transfer;
  final double kas_transfer;
  final double discount;
  final double giro_cair;
  final double giro_ganti;
  final double total_bayar;
  final double persentase;
  final String nama_area;
  final String urut;
  final double nomor;
  final double target_value;
  final double net_exc_ppn;
  final double persentase_omset;

  bool selected = false;

  OmsetSalesModel({this.kode_periode
    , this.kode_regional
    , this.nama_regional
    , this.area_key
    , this.nik
    , this.nama_sales
    , this.target_tagih
    , this.tunai
    , this.transfer
    , this.kas_transfer
    , this.discount
    , this.giro_cair
    , this.giro_ganti
    , this.total_bayar
    , this.persentase
    , this.nama_area
    , this.urut
    , this.nomor
    , this.target_value
    , this.net_exc_ppn
    , this.persentase_omset});

  factory OmsetSalesModel.fromJson(Map<String, dynamic> json) {
    return new OmsetSalesModel(
      kode_periode: json['kode_periode'],
      kode_regional: json['kode_regional'],
      nama_regional: json['nama_regional'],
      area_key: json['area_key'],
      nik: json['nik'],
      nama_sales: json['nama_sales'],
      target_tagih: json['target_tagih'] == null ? 0 : json['target_tagih'].toDouble(),
      tunai: json['tunai'] == null ? 0 : json['tunai'].toDouble(),
      transfer: json['transfer'] == null ? 0 : json['transfer'].toDouble(),
      kas_transfer: json['kas_transfer'] == null ? 0 : json['kas_transfer'].toDouble(),
      discount: json['discount'] == null ? 0 : json['discount'].toDouble(),
      giro_cair: json['giro_cair'] == null ? 0 : json['giro_cair'].toDouble(),
      giro_ganti: json['giro_ganti'] == null ? 0 : json['giro_ganti'].toDouble(),
      total_bayar: json['total_bayar'] == null ? 0 : json['total_bayar'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
      nama_area: json['nama_area'],
      urut: json['urut'],
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      target_value: json['target_value'] == null ? 0 : json['target_value'].toDouble() ,
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase_omset: json['persentase_omset'] == null ? 0 : json['persentase_omset'].toDouble(),
    );
  }
}

class OmsetTokoModel {
  final String nik;
  final String kode_pelanggan;
  final String nama_toko;
  final String area_key;
  final String kode_periode;
  final double target_value;
  final double net_exc_ppn;
  final double persentase_omset;
  final double nomor;

  bool selected = false;

  OmsetTokoModel({this.nik
    , this.kode_pelanggan
    , this.nama_toko
    , this.area_key
    , this.kode_periode
    , this.target_value
    , this.net_exc_ppn
    , this.persentase_omset
    , this.nomor});

  factory OmsetTokoModel.fromJson(Map<String, dynamic> json) {
    return new OmsetTokoModel(
      nik: json['nik'],
      kode_pelanggan: json['kode_pelanggan'],
      nama_toko: json['nama_toko'],
      area_key: json['area_key'],
      kode_periode: json['kode_periode'],
      target_value: json['target_value'] == null ? 0 : json['target_value'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase_omset: json['persentase_omset'] == null ? 0 : json['persentase_omset'].toDouble(),
      nomor: json['nomor'].toDouble() == null ? 0 : json['nomor'].toDouble(),
    );
  }
}

class PeriodeModel {
  final String kode_periode;
  final String TAHUN;
  final String BULAN;
  final String KODE_PERIODE1;

  bool selected = false;

  PeriodeModel({ this.kode_periode
    , this.TAHUN
    , this.BULAN
    , this.KODE_PERIODE1});

  factory PeriodeModel.fromJson(Map<String, dynamic> json) {
    return new PeriodeModel(
      kode_periode: json['kode_periode'],
      TAHUN: json['TAHUN'],
      BULAN: json['BULAN'],
      KODE_PERIODE1: json['KODE_PERIODE1'],
    );
  }
}

class TokoModel {
  final double total;
  final double total_order_so;
  final double persentase;

  bool selected = false;

  TokoModel({ this.total
    , this.total_order_so
    , this.persentase});

  factory TokoModel.fromJson(Map<String, dynamic> json) {
    return new TokoModel(
      total: json['total'] == null ? 0 : json['total'].toDouble(),
      total_order_so: json['total_order_so'] == null ? 0 : json['total_order_so'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
    );
  }
}

class BrandModel {
  final String jenis_merk;
  final double omset;
  final double berat;

  bool selected = false;

  BrandModel({ this.jenis_merk
    , this.omset
    , this.berat});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return new BrandModel(
      jenis_merk: json['jenis_merk'],
      omset: json['omset'] == null ? 0 : json['omset'].toDouble(),
      berat: json['berat'] == null ? 0 : json['berat'].toDouble(),
    );
  }
}