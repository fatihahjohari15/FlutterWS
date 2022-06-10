import 'package:flutter/material.dart';
import 'package:mytutor/views/loginscreen.dart';

void main() => runApp(const MainScreen());

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String _title = 'My Tutor';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Subjects',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text(
      'Tutors',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text(
      'Subscribe',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text(
      'Favourite',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text(
      'Profile',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tutor'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Fatihah Johari"),
              accountEmail: Text("teahjohari15@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/myprofile.png"),
              ),
            ),
            _createDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_rounded),
            label: 'Subjects',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutors',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Subscribe',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.amber,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _createDrawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
