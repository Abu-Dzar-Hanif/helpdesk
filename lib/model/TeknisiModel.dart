class TeknisiModel {
  String? id_teknisi;
  String? nama_teknisi;
  String? gender;
  String? vendor;
  String? no_telpon;
  TeknisiModel(this.id_teknisi, this.nama_teknisi, this.gender, this.vendor,
      this.no_telpon);
  TeknisiModel.fromJson(Map<String, dynamic> json) {
    id_teknisi = json['id_teknisi'];
    nama_teknisi = json['nama_teknisi'];
    gender = json['gender'];
    vendor = json['vendor'];
    no_telpon = json['no_telpon'];
  }
}
