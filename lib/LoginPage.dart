import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk/model/api.dart';
import 'package:helpdesk/view/AdminPage.dart';
import 'package:helpdesk/view/TeknisiPage.dart';
import 'package:helpdesk/view/UserPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn, signUser, signTeknisi }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    } else {
      setState(() {});
    }
  }

  login() async {
    final response = await http.post(Uri.parse(BaseUrl.urlLogin),
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      String usernameAPI = data['username'];
      String idAPI = data['id_karyawan'];
      String namaAPI = data['nama'];
      String userLevel = data['level'];
      if (userLevel == "1") {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, usernameAPI, idAPI, namaAPI, userLevel);
        });
      } else if (userLevel == "2") {
        setState(() {
          _loginStatus = LoginStatus.signUser;
          savePref(value, usernameAPI, idAPI, namaAPI, userLevel);
        });
      } else if (userLevel == "3") {
        setState(() {
          _loginStatus = LoginStatus.signTeknisi;
          savePref(value, usernameAPI, idAPI, namaAPI, userLevel);
        });
      } else {
        dialogGagal();
      }
      print(pesan);
    } else {
      print(pesan);
      dialogGagal();
    }
  }

  savePref(int val, String usernameAPI, String idAPI, String namaAPI,
      userLevel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", val);
      preferences.setString("username", usernameAPI);
      preferences.setString("id_karyawan", idAPI);
      preferences.setString("nama_karyawan", namaAPI);
      preferences.setString("level", userLevel);
      preferences.commit();
    });
  }

  var value;
  var level;
  var nama;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      level = preferences.getString("level");
      nama = preferences.getString("nama_karyawan");
      if (value == 1) {
        if (level == "1") {
          _loginStatus = LoginStatus.signIn;
        } else if (level == "2") {
          _loginStatus = LoginStatus.signUser;
        } else {
          _loginStatus = LoginStatus.signTeknisi;
        }
      } else {
        _loginStatus = LoginStatus.notSignIn;
      }
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("username", null.toString());
      preferences.setString("nama_karyawan", null.toString());
      preferences.setString("level", null.toString());
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
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
                        "Username / Password salah",
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

  void disopse() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
              children: <Widget>[
                Image.asset('assets/logo_m2v_n2.jpg', height: 60, width: 60),
                Text(
                  "Helpdesk Apps",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "silahkan isi username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                    labelText: "Username",
                  ),
                ),
                TextFormField(
                  obscureText: _secureText,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "silahkan isi password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: showHide)),
                ),
                SizedBox(
                  height: 25,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20.0),
                  color: Color.fromARGB(255, 41, 69, 91),
                  onPressed: () {
                    check();
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return AdminPage(signOut);
        break;
      case LoginStatus.signUser:
        return UserPage(signOut);
        break;
      case LoginStatus.signTeknisi:
        return TeknisiPage(signOut);
        break;
    }
  }
}
