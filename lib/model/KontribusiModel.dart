class KontribusiModel {
  String? nama_teknisi;
  String? proses;
  String? done;
  KontribusiModel(this.nama_teknisi, this.proses, this.done);
  KontribusiModel.fromJson(Map<String, dynamic> json) {
    nama_teknisi = json['nama_teknisi'];
    proses = json['proses'];
    done = json['done'];
  }
}
