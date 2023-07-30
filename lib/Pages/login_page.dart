import 'package:flutter/material.dart';
import 'package:my_app/Services/api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home page.png'),
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
                  icon: const Icon(Icons.emoji_people,
                      color: Color.fromARGB(255, 243, 235, 235)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 10, 34, 54),
                  ),
                  label: const Text('Visitor',
                      style: TextStyle(
                        color: Color.fromARGB(255, 238, 239, 239),
                      )),
                  onPressed: () {
                    Navigator.pushNamed(context, '/sideMenu');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person,
                      color: Color.fromARGB(255, 243, 235, 235)),
                  label: const Text(
                    'Member Login',
                    style: TextStyle(
                      color: Color.fromARGB(255, 238, 239, 239),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 10, 34, 54),
                  ),
                  onPressed: () async {
                    await ApiService().loginUser('David');
                  },
                ),
              ),
              TextButton(
                child: Text('New? Create an account'),
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
