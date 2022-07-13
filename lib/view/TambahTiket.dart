import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';

class TambahTiket extends StatefulWidget {
  final VoidCallback reload;
  TambahTiket(this.reload);
  @override
  State<TambahTiket> createState() => _TambahTiketState();
}

class _TambahTiketState extends State<TambahTiket> {
  String? idKaryawan, nama, Keluhan;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      nama = pref.getString("nama");
    });
  }

  final _key = new GlobalKey<FormState>();
  File? _imageFile;
  final image_picker = ImagePicker();

  _pilihGallery() async {
    final image = await image_picker.getImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print('No image selected');
      }
    });
  }

  _pilihCamera() async {
    final image = await image_picker.getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print('No image selected');
      }
    });
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanTiket();
    }
  }

  simpanTiket() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      var uri = Uri.parse(BaseUrl.urlTambahTiket);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_karyawan'] = idKaryawan!;
      request.fields['keluhan'] = Keluhan!;
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile!.path)));
      var respon = await request.send();
      if (respon.statusCode > 2) {
        print("berhasil upload");
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("gagal");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  dialogFileFoto() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Silahkan Pilih Sumber File",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _pilihCamera();
                        },
                        child: Text(
                          "Kamera",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: 25.0,
                    ),
                    InkWell(
                        onTap: () {
                          _pilihGallery();
                        },
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
        width: double.infinity,
        height: 150.0,
        child: Icon(
          CupertinoIcons.camera_viewfinder,
          size: 100,
        ));
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Buat Tiket",
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
            Text("Foto Kendala"),
            Container(
                width: double.infinity,
                height: 150.0,
                child: InkWell(
                    onTap: () {
                      dialogFileFoto();
                    },
                    child: _imageFile == null
                        ? placeholder
                        : Image.file(_imageFile!, fit: BoxFit.fill))),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "isi Keluhan";
                }
              },
              onSaved: (e) => Keluhan = e,
              decoration: InputDecoration(labelText: "Keluhan / Kendala"),
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
                "Buat",
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
