class LoginModel {
  final String userid;
  final String password;
  final String nama_karyawan;
  final String kode_group_menu;
  final String NAMA_GROUP_MENU;
  final String jabatan;

  LoginModel({this.userid, this.password, this.nama_karyawan, this.kode_group_menu, this.NAMA_GROUP_MENU, this.jabatan});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      userid: json['userid'],
      password: json['password'],
      nama_karyawan: json['nama_karyawan'],
      kode_group_menu: json['kode_group_menu'],
      NAMA_GROUP_MENU: json['NAMA_GROUP_MENU'],
      jabatan: json['jabatan'],
    );
  }
}