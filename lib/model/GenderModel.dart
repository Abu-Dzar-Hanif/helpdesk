class GenderModel {
  String? id_gender;
  String? jenis_gender;
  GenderModel(this.id_gender, this.jenis_gender);
  GenderModel.fromJson(Map<String, dynamic> json) {
    id_gender = json['id_gender'];
    jenis_gender = json['jenis_gender'];
  }
}
