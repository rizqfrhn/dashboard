// Omset

class OmsetModel {
  final String urut;
  final String nama_regional;
  final double target_omset;
  final double target_volume;
  final double net_exc_ppn;
  final double persentase_bulan;
  final double persentase_harian;
  final double nomor;

  bool selected = false;

  OmsetModel({this.urut
    , this.nama_regional
    , this.target_omset
    , this.target_volume
    , this.net_exc_ppn
    , this.persentase_bulan
    , this.persentase_harian
    , this.nomor});

  factory OmsetModel.fromJson(Map<String, dynamic> json) {
    return new OmsetModel(
      urut: json['urut'] == null ? '' : json['urut'],
      nama_regional: json['nama_regional'] == null ? '' : json['nama_regional'],
      target_omset: json['target_omset'] == null ? 0 : json['target_omset'].toDouble(),
      target_volume: json['target_volume'] == null ? 0 : json['target_volume'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase_bulan: json['persentase_bulan'] == null ? 0 : json['persentase_bulan'].toDouble(),
      persentase_harian: json['persentase_harian'] == null ? 0 : json['persentase_harian'].toDouble(),
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
    );
  }
}

class OmsetTotalModel {
  final double target_omset;
  final double target_volume;
  final double net_exc_ppn;
  final double persentase;
  final double target_omset_hari;
  final double target_volume_hari;
  final double net_exc_ppn_hari;
  final double persentase_hari;

  OmsetTotalModel({ this.target_omset
    , this.target_volume
    , this.net_exc_ppn
    , this.persentase
    , this.target_omset_hari
    , this.target_volume_hari
    , this.net_exc_ppn_hari
    , this.persentase_hari});

  factory OmsetTotalModel.fromJson(Map<String, dynamic> json) {
    return new OmsetTotalModel(
      target_omset: json['target_omset'] == null ? 0 : json['target_omset'].toDouble(),
      target_volume: json['target_volume'] == null ? 0 : json['target_volume'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
      target_omset_hari: json['target_omset_hari'] == null ? 0 : json['target_omset_hari'].toDouble(),
      target_volume_hari: json['target_volume_hari'] == null ? 0 : json['target_volume_hari'].toDouble(),
      net_exc_ppn_hari: json['net_exc_ppn_hari'] == null ? 0 : json['net_exc_ppn_hari'].toDouble(),
      persentase_hari: json['persentase_hari'] == null ? 0 : json['persentase_hari'].toDouble(),
    );
  }
}

class OmsetSOModel {
  final String kode_periode;
  final double so;
  final double sj;
  final double fk;
  final double persentase_kirim;
  final double persentase_faktur;

  OmsetSOModel({ this.kode_periode
    , this.so
    , this.sj
    , this.fk
    , this.persentase_kirim
    , this.persentase_faktur});

  factory OmsetSOModel.fromJson(Map<String, dynamic> json) {
    return new OmsetSOModel(
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      so: json['so'] == null ? 0 : json['so'].toDouble(),
      sj: json['sj'] == null ? 0 : json['sj'].toDouble(),
      fk: json['fk'] == null ? 0 : json['fk'].toDouble(),
      persentase_kirim: json['persentase_kirim'] == null ? 0 : json['persentase_kirim'].toDouble(),
      persentase_faktur: json['persentase_faktur'] == null ? 0 : json['persentase_faktur'].toDouble(),
    );
  }
}

class PeriodeModel {
  final String kode_periode;
  final String TAHUN;
  final String BULAN;
  final String KODE_PERIODE1;

  PeriodeModel({ this.kode_periode
    , this.TAHUN
    , this.BULAN
    , this.KODE_PERIODE1});

  factory PeriodeModel.fromJson(Map<String, dynamic> json) {
    return new PeriodeModel(
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      TAHUN: json['TAHUN'] == null ? '' : json['TAHUN'],
      BULAN: json['BULAN'] == null ? '' : json['BULAN'],
      KODE_PERIODE1: json['KODE_PERIODE1'] == null ? '' : json['KODE_PERIODE1'],
    );
  }
}

class TokoModel {
  final double total;
  final double total_order_so;
  final double persentase;

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

class RuteModel {
  final double total_rute;
  final double total_toko;
  final double persentase;

  RuteModel({ this.total_rute
    , this.total_toko
    , this.persentase});

  factory RuteModel.fromJson(Map<String, dynamic> json) {
    return new RuteModel(
      total_rute: json['total_rute'] == null ? 0 : json['total_rute'].toDouble(),
      total_toko: json['total_toko'] == null ? 0 : json['total_toko'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
    );
  }
}

class BrandModel {
  final String kode_jenis_merk;
  final double jumlah_toko;
  final String jenis_merk;
  final double jumlah;
  final double omset;
  final double berat;
  final double nomor;
  final double jumlah_toko_last_year;
  final double omset_last_year;
  final double total_toko_mtd;
  final double total_toko_last_year;

  BrandModel({ this.kode_jenis_merk
    , this.jumlah_toko
    , this.jenis_merk
    , this.jumlah
    , this.omset
    , this.berat
    , this.nomor
    , this.jumlah_toko_last_year
    , this.omset_last_year
    , this.total_toko_mtd
    , this.total_toko_last_year});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return new BrandModel(
      kode_jenis_merk: json['kode_jenis_merk'] == null ? '' : json['kode_jenis_merk'],
      jumlah_toko: json['jumlah_toko'] == null ? 0 : json['jumlah_toko'].toDouble(),
      jenis_merk: json['jenis_merk'] == null ? '' : json['jenis_merk'],
      jumlah: json['jumlah'] == null ? 0 : json['jumlah'].toDouble(),
      omset: json['omset'] == null ? 0 : json['omset'].toDouble(),
      berat: json['berat'] == null ? 0 : json['berat'].toDouble(),
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      jumlah_toko_last_year: json['jumlah_toko_last_year'] == null ? 0 : json['jumlah_toko_last_year'].toDouble(),
      omset_last_year: json['omset_last_year'] == null ? 0 : json['omset_last_year'].toDouble(),
      total_toko_mtd: json['total_toko_mtd'] == null ? 0 : json['total_toko_mtd'].toDouble(),
      total_toko_last_year: json['total_toko_last_year'] == null ? 0 : json['total_toko_last_year'].toDouble(),
    );
  }
}

class OmsetTagihModel {
  final String kode;
  final double target_tagih;
  final double total_bayar;
  final double persentase;
  final double target_hari;
  final double total_bayar_hari;
  final double persentase_hari;

  OmsetTagihModel({ this.kode
    , this.target_tagih
    , this.total_bayar
    , this.persentase
    , this.target_hari
    , this.total_bayar_hari
    , this.persentase_hari});

  factory OmsetTagihModel.fromJson(Map<String, dynamic> json) {
    return new OmsetTagihModel(
      kode: json['kode'] == null ? '' : json['kode'],
      target_tagih: json['target_tagih'] == null ? 0 : json['target_tagih'].toDouble(),
      total_bayar: json['total_bayar'] == null ? 0 : json['total_bayar'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
      target_hari: json['target_hari'] == null ? 0 : json['target_hari'].toDouble(),
      total_bayar_hari: json['total_bayar_hari'] == null ? 0 : json['total_bayar_hari'].toDouble(),
      persentase_hari: json['persentase_hari'] == null ? 0 : json['persentase_hari'].toDouble(),
    );
  }
}

class OmsetCallECModel {
  final String kode_periode;
  final double target_omset_last;
  final double rata_call_last;
  final double rata_ec_last;
  final double rata_fk_last;
  final double jumlah_sales_last;
  final double estimasi_persentase_last;
  final double target_omset;
  final double rata_call;
  final double rata_ec;
  final double rata_fk;
  final double jumlah_sales;
  final double estimasi_persentase;

  OmsetCallECModel({ this.kode_periode
    , this.target_omset_last
    , this.rata_call_last
    , this.rata_ec_last
    , this.rata_fk_last
    , this.jumlah_sales_last
    , this.estimasi_persentase_last
    , this.target_omset
    , this.rata_call
    , this.rata_ec
    , this.rata_fk
    , this.jumlah_sales
    , this.estimasi_persentase});

  factory OmsetCallECModel.fromJson(Map<String, dynamic> json) {
    return new OmsetCallECModel(
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      target_omset_last: json['target_omset_last'] == null ? 0 : json['target_omset_last'].toDouble(),
      rata_call_last: json['rata_call_last'] == null ? 0 : json['rata_call_last'].toDouble(),
      rata_ec_last: json['rata_ec_last'] == null ? 0 : json['rata_ec_last'].toDouble(),
      rata_fk_last: json['rata_fk_last'] == null ? 0 : json['rata_fk_last'].toDouble(),
      jumlah_sales_last: json['jumlah_sales_last'] == null ? 0 : json['jumlah_sales_last'].toDouble(),
      estimasi_persentase_last: json['estimasi_persentase_last'] == null ? 0 : json['estimasi_persentase_last'].toDouble(),
      target_omset: json['target_omset'] == null ? 0 : json['target_omset'].toDouble(),
      rata_call: json['rata_call'] == null ? 0 : json['rata_call'].toDouble(),
      rata_ec: json['rata_ec'] == null ? 0 : json['rata_ec'].toDouble(),
      rata_fk: json['rata_fk'] == null ? 0 : json['rata_fk'].toDouble(),
      jumlah_sales: json['jumlah_sales'] == null ? 0 : json['jumlah_sales'].toDouble(),
      estimasi_persentase: json['estimasi_persentase'] == null ? 0 : json['estimasi_persentase'].toDouble(),
    );
  }
}

class OmsetLineChartModel {
  final String kode_periode;
  final int tahun;
  final int bulan;
  final int tgl;
  final double total_so;
  final double total_qty_bl_jt;
  final double total_qty_jt;
  final double total_harga_sj;
  final double total_harga_sj_last;
  final double total_harga_sj_now;
  final double total_bayar;

  OmsetLineChartModel({ this.kode_periode
    , this.tahun
    , this.bulan
    , this.tgl
    , this.total_so
    , this.total_qty_bl_jt
    , this.total_qty_jt
    , this.total_harga_sj
    , this.total_harga_sj_last
    , this.total_harga_sj_now
    , this.total_bayar});

  factory OmsetLineChartModel.fromJson(Map<String, dynamic> json) {
    return new OmsetLineChartModel(
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      tahun: json['tahun'] == null ? 0 : json['tahun'].toInt(),
      bulan: json['tgl'] == null ? 0 : json['bulan'].toInt(),
      tgl: json['tgl'] == null ? 0 : json['tgl'].toInt(),
      total_so: json['total_so'] == null ? 0 : json['total_so'].toDouble(),
      total_qty_bl_jt: json['total_qty_bl_jt'] == null ? 0 : json['total_qty_bl_jt'].toDouble(),
      total_qty_jt: json['total_qty_jt'] == null ? 0 : json['total_qty_jt'].toDouble(),
      total_harga_sj: json['total_harga_sj'] == null ? 0 : json['total_harga_sj'].toDouble(),
      total_harga_sj_last: json['total_harga_sj_last'] == null ? 0 : json['total_harga_sj_last'].toDouble(),
      total_harga_sj_now: json['total_harga_sj_now'] == null ? 0 : json['total_harga_sj_now'].toDouble(),
      total_bayar: json['total_bayar'] == null ? 0 : json['total_bayar'].toDouble(),
    );
  }
}

// Omset Area

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
  final double target_omset_harian;
  final double target_volume_harian;
  final double net_exc_ppn_harian;
  final double persentase_harian;

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
    , this.nomor
    , this.target_omset_harian
    , this.target_volume_harian
    , this.net_exc_ppn_harian
    , this.persentase_harian});

  factory OmsetAreaModel.fromJson(Map<String, dynamic> json) {
    return new OmsetAreaModel(
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      nama_regional: json['nama_regional'] == null ? '' : json['nama_regional'],
      area_key: json['area_key'] == null ? '' : json['area_key'],
      target_value: json['target_value'] == null ? 0 : json['target_value'].toDouble(),
      target_volume: json['target_volume'] == null ? 0 : json['target_volume'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
      nama_area: json['nama_area'] == null ? '' : json['nama_area'],
      urut: json['urut'] == null ? '' : json['urut'],
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      target_omset_harian: json['target_omset_harian'] == null ? 0 : json['target_omset_harian'].toDouble(),
      target_volume_harian: json['target_volume_harian'] == null ? 0 : json['target_volume_harian'].toDouble(),
      net_exc_ppn_harian: json['net_exc_ppn_harian'] == null ? 0 : json['net_exc_ppn_harian'].toDouble(),
      persentase_harian: json['persentase_harian'] == null ? 0 : json['persentase_harian'].toDouble(),
    );
  }
}

// Omset Sales

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
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      kode_regional: json['kode_regional'] == null ? '' : json['kode_regional'],
      nama_regional: json['nama_regional'] == null ? '' : json['nama_regional'],
      area_key: json['area_key'] == null ? '' : json['area_key'],
      nik: json['nik'] == null ? '' : json['nik'],
      nama_sales: json['nama_sales'] == null ? '' : json['nama_sales'],
      target_tagih: json['target_tagih'] == null ? 0 : json['target_tagih'].toDouble(),
      tunai: json['tunai'] == null ? 0 : json['tunai'].toDouble(),
      transfer: json['transfer'] == null ? 0 : json['transfer'].toDouble(),
      kas_transfer: json['kas_transfer'] == null ? 0 : json['kas_transfer'].toDouble(),
      discount: json['discount'] == null ? 0 : json['discount'].toDouble(),
      giro_cair: json['giro_cair'] == null ? 0 : json['giro_cair'].toDouble(),
      giro_ganti: json['giro_ganti'] == null ? 0 : json['giro_ganti'].toDouble(),
      total_bayar: json['total_bayar'] == null ? 0 : json['total_bayar'].toDouble(),
      persentase: json['persentase'] == null ? 0 : json['persentase'].toDouble(),
      nama_area: json['nama_area'] == null ? '' : json['nama_area'],
      urut: json['urut'] == null ? '' : json['urut'],
      nomor: json['nomor'] == null ? 0 : json['nomor'].toDouble(),
      target_value: json['target_value'] == null ? 0 : json['target_value'].toDouble() ,
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase_omset: json['persentase_omset'] == null ? 0 : json['persentase_omset'].toDouble(),
    );
  }
}

// Omset Toko

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
      nik: json['nik'] == null ? '' : json['nik'],
      kode_pelanggan: json['kode_pelanggan'] == null ? '' : json['kode_pelanggan'],
      nama_toko: json['nama_toko'] == null ? '' : json['nama_toko'],
      area_key: json['area_key'] == null ? '' : json['area_key'],
      kode_periode: json['kode_periode'] == null ? '' : json['kode_periode'],
      target_value: json['target_value'] == null ? 0 : json['target_value'].toDouble(),
      net_exc_ppn: json['net_exc_ppn'] == null ? 0 : json['net_exc_ppn'].toDouble(),
      persentase_omset: json['persentase_omset'] == null ? 0 : json['persentase_omset'].toDouble(),
      nomor: json['nomor'].toDouble() == null ? 0 : json['nomor'].toDouble(),
    );
  }
}