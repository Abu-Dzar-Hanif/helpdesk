class KaryawanModel {
  String? id_karyawan;
  String? nama;
  String? gender;
  String? divisi;
  String? notelpon;
  String? username;
  String? level;
  KaryawanModel(this.id_karyawan, this.nama, this.gender, this.divisi,
      this.notelpon, this.username, this.level);
  KaryawanModel.fromJson(Map<String, dynamic> json) {
    id_karyawan = json['id_karyawan'];
    nama = json['nama'];
    gender = json['gender'];
    divisi = json['divisi'];
    notelpon = json['notelpon'];
    username = json['username'];
    level = json['level'];
  }
}
