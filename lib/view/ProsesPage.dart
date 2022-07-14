import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/TiketModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:helpdesk/view/DetailTiket.dart';
import 'package:helpdesk/view/EditTiket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class ProsesPage extends StatefulWidget {
  @override
  State<ProsesPage> createState() => _ProsesPageState();
}

class _ProsesPageState extends State<ProsesPage> {
  String? idKaryawan;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
    });
    _lihatData();
  }

  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response =
        await http.get(Uri.parse(BaseUrl.urlTiketOp + idKaryawan.toString()));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new TiketModel(
            api['id_tiket'],
            api['user'],
            api['divisi'],
            api['keluhan'],
            api['foto'],
            api['tgl_buat'],
            api['tgl_selesai'],
            api['teknisi'],
            api['solusi'],
            api['status']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
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
        elevation: 0.1,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Text('Tiket On Process'),
      ),
      body: Column(
        children: [
          Expanded(
              child: RefreshIndicator(
                  onRefresh: _lihatData,
                  key: _refresh,
                  child: loading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Card(
                                color: const Color(0xfff1f0ec),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        CupertinoIcons.ticket_fill,
                                        size: 50,
                                        color: Color(0xff29455b),
                                      ),
                                      title: Text(
                                          "ID : " + x.id_tiket.toString(),
                                          style: TextStyle(fontSize: 15.0)),
                                      subtitle: Text("User : " +
                                          x.user.toString() +
                                          "( " +
                                          "Divisi " +
                                          x.divisi.toString() +
                                          " )"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(padding: EdgeInsets.all(10.0)),
                                        TextButton(
                                          child: Text(
                                            'Detail Tiket',
                                            style: TextStyle(
                                                color: Color(0xff29455b)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailTiket(
                                                            x, _lihatData)));
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Selesaikan',
                                            style: TextStyle(
                                                color: Color(0xff29455b)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTiket(
                                                            x, _lihatData)));
                                          },
                                        ),
                                        const SizedBox(width: 1),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))),
        ],
      ),
    );
  }
}
