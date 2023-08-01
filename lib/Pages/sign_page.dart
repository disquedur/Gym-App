import 'dart:core';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final authController = TextEditingController();
  final passwordController = TextEditingController();
  final codeValidationController = TextEditingController();

  bool authButton = false;
  bool isCodeSent = false;
  String authMethod = "";
  bool codeIsValid = false;

  @override
  void dispose() {
    usernameController.dispose();
    authController.dispose();
    codeValidationController.dispose();
    super.dispose();
  }

  Future<void> createAccount(String username, String password) async {
    await Supabase.instance.client
        .from('Users')
        .insert({'username': username, 'password': password});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created!"),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 174, 195, 213),
        title: const Text(
          'Create account',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 31, 86),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 216, 219, 224),
                        labelText: "Username (4 characters min.)",
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.account_box),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "The username is required.";
                        } else if (value.length < 4) {
                          return "The username should have at least 4 characters.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                !authButton
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Authentication',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 2, 51, 87),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.mail,
                                    color: Color.fromARGB(255, 243, 235, 235)),
                                onPressed: usernameController.text.isNotEmpty &&
                                        formKey.currentState!.validate()
                                    ? () {
                                        setState(() {
                                          authMethod = "Email address";
                                          authButton = true;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 10, 34, 54),
                                ),
                                label: const Text(
                                  'email',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 238, 239, 239),
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.phone,
                                    color: Color.fromARGB(255, 243, 235, 235)),
                                onPressed: usernameController.text.isNotEmpty &&
                                        formKey.currentState!.validate()
                                    ? () {
                                        setState(() {
                                          authMethod = "Phone number";
                                          authButton = true;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 10, 34, 54),
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
                        ],
                      )
                    : displayValidationField(),
                if (codeValidationController.text.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String username = usernameController.text;
                          String password = codeValidationController.text;
                          createAccount(username, password);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 34, 54),
                      ),
                      child: const Text(
                        'Validate code',
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

  displayValidationField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              controller: authController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 216, 219, 224),
                labelText: authMethod,
                icon: Icon(authMethod == "Phone number"
                    ? Icons.contact_phone
                    : Icons.contact_mail),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "The password is required.";
                } else if (value.length < 7) {
                  return "The username should have at least 7 characters.";
                }
                return null;
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
                } else if (value.length < 7) {
                  return "The username should have at least 7 characters.";
                }
                return null;
              },
            ),
          ),
        ),
        !isCodeSent
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    isCodeSent = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 34, 54),
                ),
                child: Text(
                  'Verify ${authMethod.toLowerCase()}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 238, 239, 239),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: codeValidationController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 216, 219, 224),
                      labelText: "Validation code",
                      icon: Icon(Icons.confirmation_number),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
        TextButton(
          child: const Text('Change authentication method'),
          onPressed: () {
            setState(() {
              authMethod = "";
              codeValidationController.text = "";
              authButton = false;
              isCodeSent = false;
            });
          },
        ),
      ],
    );
  }
}
