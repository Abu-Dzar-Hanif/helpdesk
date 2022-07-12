import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeknisiPage extends StatefulWidget {
  final VoidCallback signOut;
  @override
  TeknisiPage(this.signOut);
  State<TeknisiPage> createState() => _TeknisiPageState();
}

class _TeknisiPageState extends State<TeknisiPage> {
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
        title: Text('Helpdesk | Teknisi Panel'),
        actions: <Widget>[
          new IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.logout),
              color: Colors.white)
        ],
      ),
    );
  }
}
