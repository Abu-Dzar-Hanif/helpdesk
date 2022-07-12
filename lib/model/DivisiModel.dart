class DivisiModel {
  String? id_divisi;
  String? nama_divisi;
  DivisiModel(this.id_divisi, this.nama_divisi);
  DivisiModel.fromJson(Map<String, dynamic> json) {
    id_divisi = json['id_divisi'];
    nama_divisi = json['nama_divisi'];
  }
}
