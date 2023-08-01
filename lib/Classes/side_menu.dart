import 'package:flutter/material.dart';
import 'package:my_app/Pages/map_page.dart';
import 'package:my_app/Pages/sign_page.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    MapComponent(),
    SignInPage(),
    SettingsScreen(),
  ];

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Side Menu Navigator'),
      ),
      body: screens[selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 78, 126, 157),
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
              title: Text('Map'),
              selected: selectedIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              selected: selectedIndex == 1,
              onTap: () => onItemSelected(1),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              selected: selectedIndex == 2,
              onTap: () => onItemSelected(2),
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
