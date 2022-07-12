import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/DivisiModel.dart';
import 'package:helpdesk/model/GenderModel.dart';
import 'package:helpdesk/model/KaryawanModel.dart';
import 'package:helpdesk/model/LevelModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class Editkaryawan extends StatefulWidget {
  final VoidCallback reload;
  final KaryawanModel model;
  Editkaryawan(this.model, this.reload);
  @override
  State<Editkaryawan> createState() => _EditkaryawanState();
}

class _EditkaryawanState extends State<Editkaryawan> {
  String? id_karyawan, nama, gender, divisi, no_telpon, username, level;
  GenderModel? _currentGender;
  LevelModel? _currentLvl;
  DivisiModel? _currentDivisi;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidKaryawan, txtNama, txtNoTelp, txtUsername;
  final String? linkGender = BaseUrl.urlDataGender;
  final String? linkLvl = BaseUrl.urlDataLvl;
  final String? linkDivisi = BaseUrl.urlDataDivisi;
  Future<List<GenderModel>> _fetchGender() async {
    var response = await http.get(Uri.parse(linkGender.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<GenderModel> listOfGender = items.map<GenderModel>((json) {
        return GenderModel.fromJson(json);
      }).toList();
      return listOfGender;
    } else {
      throw Exception('gagal');
    }
  }

  Future<List<LevelModel>> _fetchLvl() async {
    var response = await http.get(Uri.parse(linkLvl.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<LevelModel> listOfLvl = items.map<LevelModel>((json) {
        return LevelModel.fromJson(json);
      }).toList();
      return listOfLvl;
    } else {
      throw Exception('gagal');
    }
  }

  Future<List<DivisiModel>> _fetchDivisi() async {
    var response = await http.get(Uri.parse(linkDivisi.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<DivisiModel> listOfDivisi = items.map<DivisiModel>((json) {
        return DivisiModel.fromJson(json);
      }).toList();
      return listOfDivisi;
    } else {
      throw Exception('gagal');
    }
  }

  setup() async {
    txtNama = TextEditingController(text: widget.model.nama);
    txtUsername = TextEditingController(text: widget.model.username);
    txtNoTelp = TextEditingController(text: widget.model.notelpon);
    id_karyawan = widget.model.id_karyawan;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proseUpdate();
      if (gender == null || divisi == null || level == null) {
        dialogGagal();
      }
    }
  }

  proseUpdate() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditKaryawan), body: {
        "id_karyawan": id_karyawan,
        "nama": nama,
        "gender": gender,
        "divisi": divisi,
        "no_telpon": no_telpon,
        "username": username,
        "level": level
      });
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  dialogGagal() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
                padding: EdgeInsets.all(20.0),
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        size: 40.0,
                        color: Colors.red,
                      ),
                      Text(
                        "Pilih ulang gender,divisi,level",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Oke",
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 25.0),
                    ],
                  )
                ]),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit Teknisi " + id_karyawan.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNama,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Nama Karyawan";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(labelText: "Nama Karyawan"),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Gender"),
            FutureBuilder<List<GenderModel>>(
              future: _fetchGender(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<GenderModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<GenderModel>(
                  items: snapshot.data!
                      .map((listGender) => DropdownMenuItem(
                            child: Text(listGender.jenis_gender.toString()),
                            value: listGender,
                          ))
                      .toList(),
                  onChanged: (GenderModel? value) {
                    setState(() {
                      _currentGender = value;
                      gender = _currentGender!.id_gender;
                    });
                  },
                  isExpanded: false,
                  hint: Text(
                      gender == null || gender == widget.model.gender.toString()
                          ? widget.model.gender.toString()
                          : _currentGender!.jenis_gender.toString()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text("Divisi"),
            FutureBuilder<List<DivisiModel>>(
              future: _fetchDivisi(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DivisiModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<DivisiModel>(
                  items: snapshot.data!
                      .map((listDivisi) => DropdownMenuItem(
                            child: Text(listDivisi.nama_divisi.toString()),
                            value: listDivisi,
                          ))
                      .toList(),
                  onChanged: (DivisiModel? value) {
                    setState(() {
                      _currentDivisi = value;
                      divisi = _currentDivisi!.id_divisi;
                    });
                  },
                  isExpanded: false,
                  hint: Text(
                      divisi == null || divisi == widget.model.divisi.toString()
                          ? widget.model.divisi.toString()
                          : _currentDivisi!.nama_divisi.toString()),
                );
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: txtNoTelp,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi No Telpon";
                } else {
                  return null;
                }
              },
              onSaved: (e) => no_telpon = e,
              decoration: InputDecoration(labelText: "No Telpon"),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: txtUsername,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Username";
                } else {
                  return null;
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Level"),
            FutureBuilder<List<LevelModel>>(
              future: _fetchLvl(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<LevelModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<LevelModel>(
                  items: snapshot.data!
                      .map((listLevel) => DropdownMenuItem(
                            child: Text(listLevel.lvl.toString()),
                            value: listLevel,
                          ))
                      .toList(),
                  onChanged: (LevelModel? value) {
                    setState(() {
                      _currentLvl = value;
                      level = _currentLvl!.id_lvl;
                    });
                  },
                  isExpanded: false,
                  hint: Text(
                      level == null || level == widget.model.level.toString()
                          ? widget.model.level.toString()
                          : _currentLvl!.lvl.toString()),
                );
              },
            ),
            SizedBox(
              height: 25.0,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text(
                "Ubah",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
          ],
        ),
      ),
    );
  }
}
