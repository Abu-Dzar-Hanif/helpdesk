class LevelModel {
  String? id_lvl;
  String? lvl;
  LevelModel(this.id_lvl, this.lvl);
  LevelModel.fromJson(Map<String, dynamic> json) {
    id_lvl = json['id_lvl'];
    lvl = json['lvl'];
  }
}
