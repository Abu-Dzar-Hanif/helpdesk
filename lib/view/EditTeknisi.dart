import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/GenderModel.dart';
import 'package:helpdesk/model/TeknisiModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class EditTeknisi extends StatefulWidget {
  final VoidCallback reload;
  final TeknisiModel model;
  EditTeknisi(this.model, this.reload);
  @override
  State<EditTeknisi> createState() => _EditTeknisiState();
}

class _EditTeknisiState extends State<EditTeknisi> {
  String? id_teknisi, nama_teknisi, gender, vendor, no_telpon;
  GenderModel? _currentGender;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidTeknisi, txtnamaTeknisi, txtVendor, txtNoTelp;
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

  setup() async {
    txtnamaTeknisi = TextEditingController(text: widget.model.nama_teknisi);
    txtVendor = TextEditingController(text: widget.model.vendor);
    txtNoTelp = TextEditingController(text: widget.model.no_telpon);
    id_teknisi = widget.model.id_teknisi;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proseUpdate();
      if (gender == null) {
        dialogGagal();
      }
    }
  }

  proseUpdate() async {
    try {
      final respon =
          await http.post(Uri.parse(BaseUrl.urlEditTeknisi.toString()), body: {
        "id_teknisi": id_teknisi,
        "nama_teknisi": nama_teknisi,
        "gender": gender,
        "vendor": vendor,
        "no_telpon": no_telpon
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

  @override
  void initState() {
    super.initState();
    setup();
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
                        "Pilih Ulang jenis kelamin",
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
                "Edit Teknisi " + id_teknisi.toString(),
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
              controller: txtnamaTeknisi,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Nama Teknisi";
                } else {
                  return null;
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
            TextFormField(
              controller: txtVendor,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Vedor";
                } else {
                  return null;
                }
              },
              onSaved: (e) => vendor = e,
              decoration: InputDecoration(labelText: "Vendor"),
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
