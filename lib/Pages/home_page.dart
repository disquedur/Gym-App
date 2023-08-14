import 'package:flutter/material.dart';
import '../Interfaces/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(darkMode
                ? 'assets/images/Home page dark.png'
                : 'assets/images/Home page.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.emoji_people, color: darkColorText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        darkMode ? darkColorBackground : lightColorBackground,
                  ),
                  label: Text('Member Login',
                      style: TextStyle(
                        color: darkColorText,
                      )),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton.icon(
                    icon: Icon(Icons.person, color: darkColorText),
                    label: Text(
                      'Trainer login',
                      style: TextStyle(
                        color: darkColorText,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          darkMode ? darkColorBackground : lightColorBackground,
                    ),
                    onPressed:
                        null //() {Navigator.pushNamed(context, '/sideMenu');},
                    ),
              ),
              TextButton(
                child: Text(
                  'New? Create an account',
                  style: TextStyle(
                    color: darkMode ? darkColorBackground : lightColorText,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton.icon(
                  icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode,
                      color: darkMode ? darkColorBackground : lightColorText),
                  onPressed: () {
                    setState(() {
                      darkMode = !darkMode;
                    });
                  },
                  label: Text(
                    "Theme",
                    style: TextStyle(
                      color: darkMode ? darkColorBackground : lightColorText,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
