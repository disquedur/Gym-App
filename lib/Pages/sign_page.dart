import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final usernameController = TextEditingController();
  final authController = TextEditingController();
  final passwordController = TextEditingController();
  final codeValidationController = TextEditingController();

  bool authButton = false;
  bool isCodeSent = false;
  bool isEmailSent = false;
  AuthResponse emailRes = AuthResponse();
  String authMethod = "";
  String phoneNumber = "";
  bool codeIsValid = false;

  @override
  void dispose() {
    usernameController.dispose();
    authController.dispose();
    codeValidationController.dispose();
    super.dispose();
  }

  createAccount(AuthResponse authResponse) async {
    String authInfo = authMethod == "Email address" ? 'email' : 'phone';
    AuthResponse authResponse = AuthResponse();
    if (authInfo == 'phone') {
      try {
        authResponse = await supabase.auth.verifyOTP(
            phone: phoneNumber,
            token: codeValidationController.text,
            type: OtpType.sms);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Token has expired or is invalid"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    if (authResponse.user?.aud == "authenticated") {
      await supabase
          .from(
        dotenv.env['TABLE_USERS']!,
      )
          .insert({
        'username': usernameController.text,
        'password': passwordController.text,
        authInfo: authController.text
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created!"),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  sendVerification() {
    setState(() {
      supabase.auth
          .signUp(phone: phoneNumber, password: passwordController.text);
      isCodeSent = true;
    });
  }

  signUpWithEmail() async {
    final confirmation = await supabase.auth
        .signUp(email: authController.text, password: passwordController.text);
    if (!isEmailSent) {
      await supabase.auth.signInWithOtp(email: authController.text);
      isEmailSent = true;
    } else if (confirmation.user?.emailConfirmedAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You received an email, please verify your email!"),
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      await supabase.auth.signUp(
          email: authController.text, password: passwordController.text);
      createAccount(emailRes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 217, 219, 222)),
        backgroundColor: const Color.fromARGB(255, 10, 34, 54),
        title: const Text(
          'Create account',
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
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
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
                                  'Email',
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
                if (isCodeSent)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: codeValidationController.text.isNotEmpty
                          ? () {
                              setState(() {
                                if (formKey.currentState!.validate()) {
                                  createAccount(AuthResponse());
                                }
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 34, 54),
                      ),
                      child: const Text(
                        'Create account',
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
        !isCodeSent
            ? ElevatedButton(
                onPressed: authController.text.isNotEmpty &&
                        formKey.currentState!.validate()
                    ? () {
                        authMethod == "Email address"
                            ? signUpWithEmail()
                            : sendVerification();
                      }
                    : null,
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
            : Column(
                children: [
                  SizedBox(
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
                  TextButton(
                    child: const Text('Send new code?'),
                    onPressed: () {
                      setState(() {
                        sendVerification();
                      });
                    },
                  ),
                ],
              ),
        TextButton(
          child: const Text('Change authentication method'),
          onPressed: () {
            setState(() {
              authMethod = "";
              codeValidationController.text = "";
              authController.text = "";
              authButton = false;
              isCodeSent = false;
            });
          },
        ),
      ],
    );
  }
}
