import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Interfaces/constants.dart';

class LoginPage extends StatefulWidget {
  final bool darkMode;

  const LoginPage({super.key, required this.darkMode});

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

  TextStyle styleTextByTheme() {
    return widget.darkMode
        ? TextStyle(
            color: passwordController.text.isEmpty ||
                    authController.text.isEmpty ||
                    !formKey.currentState!.validate()
                ? Colors.grey
                : darkColorText,
          )
        : TextStyle(
            color: darkColorText,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: darkColorText),
        backgroundColor:
            widget.darkMode ? darkColorBackground : lightColorBackground,
        title: Text(
          'Login',
          style: TextStyle(
            color: darkColorText,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.darkMode
                ? 'assets/images/User page dark.png'
                : 'assets/images/User page.png'),
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
                        icon: Icon(
                          Icons.mail,
                          color: darkColorText,
                        ),
                        onPressed: () {
                          setState(() {
                            authMethod = "Email address";
                            authController.text = "";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.darkMode
                              ? darkColorBackground
                              : lightColorBackground,
                        ),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            color: darkColorText,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.phone, color: darkColorText),
                      onPressed: () {
                        setState(() {
                          authMethod = "Phone number";
                          authController.text = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.darkMode
                            ? darkColorBackground
                            : lightColorBackground,
                      ),
                      label: Text(
                        'Phone',
                        style: TextStyle(
                          color: darkColorText,
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: darkColorText,
                          helperText: "Email address",
                          helperStyle: TextStyle(
                              color: widget.darkMode
                                  ? darkColorText
                                  : lightColorText),
                          labelStyle: TextStyle(color: lightColorBackground),
                          icon: Icon(Icons.contact_mail,
                              color: widget.darkMode
                                  ? darkColorBackground
                                  : lightColorBackground),
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
                        decoration: InputDecoration(
                          //counterText: "",
                          filled: true,
                          fillColor: darkColorText,
                          helperText: "Phone Number",
                          helperStyle: TextStyle(
                              color: widget.darkMode
                                  ? darkColorText
                                  : lightColorText),
                          labelStyle: TextStyle(color: lightColorBackground),
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: darkColorText,
                        helperText: "Password",
                        helperStyle: TextStyle(
                            color: widget.darkMode
                                ? darkColorText
                                : lightColorText),
                        labelStyle: TextStyle(color: lightColorBackground),
                        icon: Icon(Icons.password,
                            color: widget.darkMode
                                ? darkColorBackground
                                : lightColorBackground),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "The password is required.";
                        } else if (value.length < 5) {
                          return "Password (5 characters min.)";
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
                            passwordController.text.isNotEmpty &&
                            formKey.currentState!.validate()
                        ? () {
                            if (formKey.currentState!.validate()) login();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.darkMode
                          ? darkColorBackground
                          : lightColorBackground,
                    ),
                    child: Text('Login', style: styleTextByTheme()),
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
