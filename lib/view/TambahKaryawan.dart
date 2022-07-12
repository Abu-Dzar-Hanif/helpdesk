import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/DivisiModel.dart';
import 'package:helpdesk/model/GenderModel.dart';
import 'package:helpdesk/model/LevelModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'dart:convert';

class TambahKaryawan extends StatefulWidget {
  final VoidCallback reload;
  TambahKaryawan(this.reload);
  @override
  State<TambahKaryawan> createState() => _TambahKaryawanState();
}

class _TambahKaryawanState extends State<TambahKaryawan> {
  String? nama_karyawan, gender, divisi, no_telpon, username, password, level;
  GenderModel? _currentGender;
  LevelModel? _currentLvl;
  DivisiModel? _currentDivisi;
  final _key = new GlobalKey<FormState>();
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

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanData();
    }
  }

  simpanData() async {
    try {
      final response =
          await http.post(Uri.parse(BaseUrl.urlTambahKaryawan), body: {
        "nama_karyawan": nama_karyawan,
        "gender": gender,
        "divisi": divisi,
        "no_telpon": no_telpon,
        "username": username,
        "password": password,
        "level": level
      });
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
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
                  "Tambah Teknisi",
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
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Nama Karyawan";
                  }
                },
                onSaved: (e) => nama_karyawan = e,
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
                    hint: Text(gender == null
                        ? "Pilih jenis Kelamin"
                        : _currentGender!.jenis_gender.toString()),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
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
                    hint: Text(divisi == null
                        ? "Pilih Divisi"
                        : _currentDivisi!.nama_divisi.toString()),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi No Telpon";
                  }
                },
                onSaved: (e) => no_telpon = e,
                decoration: InputDecoration(labelText: "No Telpon"),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Username";
                  }
                },
                onSaved: (e) => username = e,
                decoration: InputDecoration(labelText: "Username"),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Password";
                  }
                },
                onSaved: (e) => password = e,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(
                height: 20,
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
                    hint: Text(level == null
                        ? "Pilih Level"
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
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ));
  }
}
