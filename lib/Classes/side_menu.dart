import 'package:flutter/material.dart';
import 'package:my_app/Pages/map_page.dart';
import 'package:my_app/Pages/sign_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Pages/home_page.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final supabase = Supabase.instance.client;

  int selectedIndex = 0;
  String title = "Map";

  final List<Widget> screens = [
    MapComponent(),
    SignInPage(),
    SettingsScreen(),
    HomePage(),
  ];
  final List<String> menuTitle = ["Map", "Training", "Settings", "Sign out"];

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
      title = menuTitle[selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 217, 219, 222)),
          backgroundColor: const Color.fromARGB(255, 10, 34, 54),
          title: Text(title,
              style: const TextStyle(
                color: Color.fromARGB(255, 217, 219, 222),
              ))),
      body: screens[selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 10, 34, 54),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text(menuTitle[0]),
              selected: selectedIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            ListTile(
              leading: Icon(Icons.sports_martial_arts),
              title: Text(menuTitle[1]),
              selected: selectedIndex == 1,
              onTap: () => onItemSelected(1),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(menuTitle[2]),
              selected: selectedIndex == 2,
              onTap: () => onItemSelected(2),
            ),
            ListTile(
              leading: Icon(Icons.output),
              title: Text(menuTitle[3]),
              selected: selectedIndex == 3,
              onTap: () {
                supabase.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
