import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final authController = TextEditingController();
  final passwordController = TextEditingController();

  String authMethod = "Phone number";
  String phoneNumber = "";
  bool codeIsValid = false;

  @override
  void dispose() {
    authController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  login() async {
    AuthResponse authResponse = authMethod == "Email address"
        ? await supabase.auth.signInWithPassword(
            email: authController.text, password: passwordController.text)
        : await supabase.auth.signInWithPassword(
            phone: phoneNumber, password: passwordController.text);

    if (authResponse.user?.aud == "authenticated")
      Navigator.pushNamed(context, '/sideMenu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 217, 219, 222)),
        backgroundColor: const Color.fromARGB(255, 10, 34, 54),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Color.fromARGB(255, 217, 219, 222),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.7,
            image: AssetImage('assets/images/User page.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Choose your login method"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.mail,
                            color: Color.fromARGB(255, 243, 235, 235)),
                        onPressed: () {
                          setState(() {
                            authMethod = "Email address";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 10, 34, 54),
                        ),
                        label: const Text(
                          'Email',
                          style: TextStyle(
                            color: Color.fromARGB(255, 238, 239, 239),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.phone,
                          color: Color.fromARGB(255, 243, 235, 235)),
                      onPressed: () {
                        setState(() {
                          authMethod = "Phone number";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 34, 54),
                      ),
                      label: const Text(
                        'Phone',
                        style: TextStyle(
                          color: Color.fromARGB(255, 238, 239, 239),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03),
                ),
                if (authMethod == "Email address")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: authController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 216, 219, 224),
                          labelText: "Email address",
                          icon: Icon(Icons.contact_mail),
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "The email is required.";
                          } else if (value.length < 3 ||
                              !value.contains(RegExp(
                                  "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"))) {
                            return "Invalid format";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: IntlPhoneField(
                        controller: authController,
                        decoration: const InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: const Color.fromARGB(255, 216, 219, 224),
                          labelText: 'Phone Number',
                          border: const OutlineInputBorder(),
                        ),
                        initialCountryCode: 'CA',
                        onChanged: (phone) {
                          phoneNumber = phone.completeNumber;
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 216, 219, 224),
                        labelText: "Password",
                        icon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "The password is required.";
                        } else if (value.length < 5) {
                          return "The password should have at least 5 characters.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: authController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty
                        ? () {
                            if (formKey.currentState!.validate()) login();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 34, 54),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 238, 239, 239),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
