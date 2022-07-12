import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/DivisiModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class EditDivisi extends StatefulWidget {
  final VoidCallback reload;
  final DivisiModel model;
  EditDivisi(this.model, this.reload);
  @override
  State<EditDivisi> createState() => _EditDivisiState();
}

class _EditDivisiState extends State<EditDivisi> {
  String? id_divisi, nama_divisi;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtDivisi;
  setup() async {
    txtDivisi = TextEditingController(text: widget.model.nama_divisi);
    id_divisi = widget.model.id_divisi;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proseUpdate();
    }
  }

  proseUpdate() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditDivisi),
          body: {"id_divisi": id_divisi, "nama_divisi": nama_divisi});
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
                "Edit Divisi " + id_divisi.toString(),
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
              controller: txtDivisi,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Divisi";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama_divisi = e,
              decoration: InputDecoration(labelText: "Nama Divisi"),
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
