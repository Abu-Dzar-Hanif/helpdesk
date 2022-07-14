import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/view/DataDivisi.dart';
import 'package:helpdesk/view/DataKaryawan.dart';
import 'package:helpdesk/view/DataPerforma.dart';
import 'package:helpdesk/view/DataTeknisi.dart';
import 'package:helpdesk/view/DataTiket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  final VoidCallback signOut;
  @override
  AdminPage(this.signOut);
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromARGB(255, 41, 69, 91),
          title: Text('Helpdesk | Admin Panel'),
        ),
        body: GridView.count(
          // primary: false,
          padding: EdgeInsets.all(15),
          // crossAxisSpacing: 5,
          // mainAxisSpacing: 5,
          crossAxisCount: 3,
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("Divisi");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataDivisi()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(80)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.tags_solid,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Divisi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu Teknisi");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataTeknisi()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.settings,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Teknisi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu admin");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataKaryawan()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.person_alt,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Data Karyawan",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu tiket");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new DataTiket()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.tickets_fill,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Data Tiket",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu tiket");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataPerforma()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.graph_square_fill,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Statistik",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Teknisi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () => signOut(),
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.logout,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
