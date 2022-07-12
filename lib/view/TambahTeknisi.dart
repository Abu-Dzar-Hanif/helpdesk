import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/GenderModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'dart:convert';

class TambahTeknisi extends StatefulWidget {
  final VoidCallback reload;
  TambahTeknisi(this.reload);
  @override
  State<TambahTeknisi> createState() => _TambahTeknisiState();
}

class _TambahTeknisiState extends State<TambahTeknisi> {
  String? nama_teknisi, gender, vendor, username, password, no_telpon;
  GenderModel? _currentGender;
  final _key = new GlobalKey<FormState>();
  final String? linkGender = BaseUrl.urlDataGender;
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
          await http.post(Uri.parse(BaseUrl.urlTambahTeknisi), body: {
        "nama_teknisi": nama_teknisi,
        "gender": gender,
        "vendor": vendor,
        "username": username,
        "password": password,
        "no_telpon": no_telpon
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
                    return "Silahkan isi Nama Teknisi";
                  }
                },
                onSaved: (e) => nama_teknisi = e,
                decoration: InputDecoration(labelText: "Nama Teknisi"),
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
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Vendor";
                  }
                },
                onSaved: (e) => vendor = e,
                decoration: InputDecoration(labelText: "Vendor"),
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
                height: 25,
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
