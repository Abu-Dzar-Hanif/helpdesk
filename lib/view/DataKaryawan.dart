import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/KaryawanModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:helpdesk/view/EditKaryawan.dart';
import 'package:helpdesk/view/TambahKaryawan.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class DataKaryawan extends StatefulWidget {
  @override
  State<DataKaryawan> createState() => _DataKaryawanState();
}

class _DataKaryawanState extends State<DataKaryawan> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlDataKaryawan));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new KaryawanModel(
            api['id_karyawan'],
            api['nama'],
            api['gender'],
            api['divisi'],
            api['notelpon'],
            api['username'],
            api['level']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _proseshapus(String id) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusKaryawan), body: {"id_karyawan": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
        ;
      });
    } else {
      print(pesan);
    }
  }

  dialogHapus(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Apakah anda yakin ingin menghapus data ini?",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                      "Tidak",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 25.0),
                  InkWell(
                    onTap: () {
                      _proseshapus(id);
                    },
                    child: Text(
                      "Ya",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Karyawan",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("tambah teknisi");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TambahKaryawan(_lihatData)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
      ),
      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("ID : " + x.id_karyawan.toString(),
                                    style: TextStyle(fontSize: 15.0)),
                                Text("Nama Karyawan : " + x.nama.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                Text("Gender : " + x.gender.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                Text("Divisi : " + x.divisi.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                Text("No telp : " + x.notelpon.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                Text("Level : " + x.level.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // edit
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Editkaryawan(x, _lihatData)));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                // delete
                                dialogHapus(x.id_karyawan);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    );
                  },
                )),
    );
  }
}
