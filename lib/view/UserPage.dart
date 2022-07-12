import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class UserPage extends StatefulWidget {
  final VoidCallback signOut;
  @override
  UserPage(this.signOut);
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
        screenWidgets: [Home(), Profle(signOut)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: setCurrentIndex,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Jelajah",
          ),
        ],
      ),
    );
  }
}

_pushTo(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Text('Helpdesk | Teknisi Panel'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Halaman Beranda"),
                    Icon(Icons.home),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.red,
                    ),
                  );
                },
                child: Text("Halaman Merah"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.green,
                    ),
                  );
                },
                child: Text("Halaman Hijau"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.blue,
                    ),
                  );
                },
                child: Text("Halaman Biru"),
              ),
            ],
          ),
        ),
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
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Card(
                  child: InkWell(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.logout),
                            title: Text("Logout"),
                          ),
                        ]),
                    onTap: () => signOut(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.green,
                    ),
                  );
                },
                child: Text("Halaman Hijau"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.blue,
                    ),
                  );
                },
                child: Text("Halaman Biru"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ColorScreen extends StatelessWidget {
  const ColorScreen({this.color = Colors.red});
  final Color color;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24);

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "R: " + color.red.toString(),
              style: textStyle,
            ),
            Text(
              "G: " + color.green.toString(),
              style: textStyle,
            ),
            Text(
              "B: " + color.blue.toString(),
              style: textStyle,
            ),
            Text(
              "A: " + color.alpha.toString(),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
