//class MyTable {
//  final ChildTable table;
//
//  MyTable({this.table});
//
//  factory MyTable.fromJson(Map<String, dynamic> json){
//    return new MyTable(
//        table: ChildTable.fromJson(json['Table']),
//    );
//  }
//}

class SettingModel {
  final String kode_channel;
  final String nama_channel;
  final String status_aktif;

  SettingModel({this.kode_channel, this.nama_channel, this.status_aktif});

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return new SettingModel(
      kode_channel: json['kode_channel'],
      nama_channel: json['nama_channel'],
      status_aktif: json['status_aktif'],
    );
  }
}