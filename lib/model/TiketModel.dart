class TiketModel {
  String? id_tiket;
  String? user;
  String? divisi;
  String? keluhan;
  String? foto;
  String? tgl_buat;
  String? tgl_selesai;
  String? teknisi;
  String? solusi;
  String? status;
  TiketModel(this.id_tiket, this.user, this.divisi, this.keluhan, this.foto,
      this.tgl_buat, this.tgl_selesai, this.teknisi, this.solusi, this.status);
  TiketModel.fromJson(Map<String, dynamic> json) {
    id_tiket = json['id_tiket'];
    user = json['user'];
    divisi = json['divisi'];
    keluhan = json['keluhan'];
    foto = json['foto'];
    tgl_buat = json['tgl_buat'];
    tgl_selesai = json['tgl_selesai'];
    teknisi = json['teknisi'];
    solusi = json['solusi'];
    status = json['status'];
  }
}
