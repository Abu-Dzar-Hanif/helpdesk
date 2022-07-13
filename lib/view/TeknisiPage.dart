import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/CountTiketModel.dart';
import 'package:helpdesk/model/TiketModel.dart';
import 'package:helpdesk/model/api.dart';
import 'package:helpdesk/view/DetailTiket.dart';
import 'package:helpdesk/view/EditTiket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/cupertino.dart';

class PresistentTabs extends StatelessWidget {
  const PresistentTabs({
    required this.screenWidgets,
    this.currentTabIndex = 0,
  });
  final int currentTabIndex;
  final List<Widget> screenWidgets;
  List<Widget> _buildOffstageWidgets() {
    return screenWidgets
        .map(
          (w) => Offstage(
            offstage: currentTabIndex != screenWidgets.indexOf(w),
            child: Navigator(
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (_) => w);
              },
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildOffstageWidgets(),
    );
  }
}

class TeknisiPage extends StatefulWidget {
  final VoidCallback signOut;
  @override
  TeknisiPage(this.signOut);
  State<TeknisiPage> createState() => _TeknisiPageState();
}

class _TeknisiPageState extends State<TeknisiPage> {
  late int currentTabIndex;
  String? idKaryawan, nama;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      nama = pref.getString("nama");
    });
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    currentTabIndex = 0;
  }

  void setCurrentIndex(int val) {
    setState(() {
      currentTabIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PresistentTabs(
        currentTabIndex: currentTabIndex,
        screenWidgets: [Home(), Proses(), Profle(signOut)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: setCurrentIndex,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Request",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.timer),
            label: "Dikerjakan",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

_pushTo(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? idKaryawan, nama;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      nama = pref.getString("nama");
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

    final response = await http.get(Uri.parse(BaseUrl.urlTiketTeknisi));
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

  _accTiket(String id) async {
    final response = await http.post(Uri.parse(BaseUrl.urlAcctiket),
        body: {"id_tiket": id, "id_teknisi": idKaryawan});
    print(idKaryawan);
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Home(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        // Navigator.pop(context, TeknisiPage(() {}));
        // _lihatData();
        ;
      });
    } else {
      print(pesan);
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
        title: Text('Request Tiket'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Card(
              color: const Color(0xfff1f0ec),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    size: 50,
                    color: Color.fromARGB(255, 23, 33, 41),
                  ),
                  title: Text("Halo Teknisi " + nama.toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 23, 33, 41),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Dibawah ini adalah Request Tiket, silakan di terima dan di kerjakan',
                      style: TextStyle(color: Color.fromARGB(255, 23, 33, 41))),
                ),
              ]),
            ),
          ),
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
                                            'Terima?',
                                            style: TextStyle(
                                                color: Color(0xff29455b)),
                                          ),
                                          onPressed: () {
                                            _accTiket(x.id_tiket.toString());
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

class Proses extends StatefulWidget {
  @override
  State<Proses> createState() => _ProsesState();
}

class _ProsesState extends State<Proses> {
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

class Profle extends StatefulWidget {
  final VoidCallback signOut;
  @override
  Profle(this.signOut);
  State<Profle> createState() => _ProfleState();
}

class _ProfleState extends State<Profle> {
  String? idKaryawan, nama;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      nama = pref.getString("nama");
    });
  }

  var loading = false;
  String top = "0";
  String tsls = "0";
  final ex = List<CountTiketModel>.empty(growable: true);
  _countTiket() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    final response = await http
        .get(Uri.parse(BaseUrl.urlcountTiket + idKaryawan.toString()));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new CountTiketModel(api['op'], api['sls']);
      ex.add(exp);
      setState(() {
        top = exp.op.toString();
        tsls = exp.sls.toString();
      });
    });
    setState(() {
      _countTiket();
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _countTiket();
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: 5.0, right: 20.0, bottom: 5.0, left: 20.0),
            child: Card(
              color: const Color(0xfff1f0ec),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(
                    CupertinoIcons.tickets,
                    size: 50,
                    color: Color.fromARGB(255, 23, 33, 41),
                  ),
                  title: Text("Tiket diselesaikan ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 23, 33, 41),
                        fontSize: 20,
                      )),
                  subtitle: Text(tsls + ' Tiket',
                      style: TextStyle(
                          color: Color.fromARGB(255, 23, 33, 41),
                          fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: 5.0, right: 20.0, bottom: 5.0, left: 20.0),
            child: Card(
              color: const Color(0xfff1f0ec),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(
                    CupertinoIcons.tickets,
                    size: 50,
                    color: Color.fromARGB(255, 23, 33, 41),
                  ),
                  title: Text("Tiket dikerjakan ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 23, 33, 41),
                        fontSize: 20,
                      )),
                  subtitle: Text(top + ' Tiket',
                      style: TextStyle(
                          color: Color.fromARGB(255, 23, 33, 41),
                          fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 50.0, bottom: 5.0, left: 20.0, right: 20.0),
            child: Card(
              color: const Color.fromARGB(255, 41, 69, 91),
              child: InkWell(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.logout, color: const Color(0xfff1f0ec)),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: const Color(0xfff1f0ec)),
                    ),
                  ),
                ]),
                onTap: () => signOut(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
