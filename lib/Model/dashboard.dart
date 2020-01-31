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

class DashboardModel {
  final String kode_channel;
  final String nama_channel;
  final String status_aktif;

  bool selected = false;

  DashboardModel({this.kode_channel, this.nama_channel, this.status_aktif});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return new DashboardModel(
      kode_channel: json['kode_channel'],
      nama_channel: json['nama_channel'],
      status_aktif: json['status_aktif'],
    );
  }
}