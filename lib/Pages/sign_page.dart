import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import '../Interfaces/constants.dart';

class SignInPage extends StatefulWidget {
  final bool darkMode;

  const SignInPage({super.key, required this.darkMode});

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

  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  signInWithGoogle() async {
    final rawNonce = _generateRandomString();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    String clientId = dotenv.env['GOOGLE_OAUTH_ID']!;

    final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

    const discoveryUrl =
        'https://accounts.google.com/.well-known/openid-configuration';

    final appAuth = FlutterAppAuth();

    final result = await appAuth.authorize(
      AuthorizationRequest(
        clientId,
        redirectUrl,
        discoveryUrl: discoveryUrl,
        nonce: hashedNonce,
        scopes: [
          'openid',
          'email',
        ],
      ),
    );

    if (result == null) {
      throw 'No result';
    }

    final tokenResult = await appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        authorizationCode: result.authorizationCode,
        discoveryUrl: discoveryUrl,
        codeVerifier: result.codeVerifier,
        nonce: result.nonce,
        scopes: [
          'openid',
          'email',
        ],
      ),
    );

    final idToken = tokenResult?.idToken;

    if (idToken == null) {
      throw 'No idToken';
    }

    AuthResponse signInWithIdToken = await supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      nonce: rawNonce,
    );
    createAccount(signInWithIdToken);
  }

  TextStyle styleTextByTheme() {
    return widget.darkMode
        ? TextStyle(
            color: usernameController.text.isEmpty ||
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
          'Create account',
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: darkColorText,
                        helperText: "Username (4 characters min.)",
                        helperStyle: TextStyle(
                            color: widget.darkMode
                                ? darkColorText
                                : lightColorText),
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.account_box,
                            color: widget.darkMode
                                ? darkColorText
                                : lightColorBackground),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "The username is required.";
                        } else if (value.length < 4) {
                          return "Username (4 characters min.)";
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
                                icon: Icon(Icons.mail, color: darkColorText),
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
                                  backgroundColor: widget.darkMode
                                      ? darkColorBackground
                                      : lightColorBackground,
                                ),
                                label: Text('Email', style: styleTextByTheme()),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.phone, color: darkColorText),
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
                                  backgroundColor: widget.darkMode
                                      ? darkColorBackground
                                      : lightColorBackground,
                                ),
                                label: Text('Phone', style: styleTextByTheme()),
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
                      onPressed: codeValidationController.text.isNotEmpty &&
                              formKey.currentState!.validate()
                          ? () {
                              setState(() {
                                if (formKey.currentState!.validate()) {
                                  createAccount(AuthResponse());
                                }
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.darkMode
                            ? darkColorBackground
                            : lightColorBackground,
                      ),
                      child: Text('Create account',
                          style: codeValidationController.text.isEmpty
                              ? const TextStyle(color: Colors.grey)
                              : styleTextByTheme()),
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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: darkColorText,
                  helperText: "Email address",
                  helperStyle: TextStyle(
                      color: widget.darkMode ? darkColorText : lightColorText),
                  icon: Icon(Icons.contact_mail,
                      color: widget.darkMode
                          ? darkColorText
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
                  helperText: "Phone number",
                  helperStyle: TextStyle(
                      color: widget.darkMode ? darkColorText : lightColorText),
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
                helperText: "Password (5 characters min.)",
                helperStyle: TextStyle(
                    color: widget.darkMode ? darkColorText : lightColorText),
                icon: Icon(Icons.password,
                    color:
                        widget.darkMode ? darkColorText : lightColorBackground),
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
                  backgroundColor: widget.darkMode
                      ? darkColorBackground
                      : lightColorBackground,
                ),
                child: Text(
                  'Verify ${authMethod.toLowerCase()}',
                  style: TextStyle(
                    color: darkColorText,
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: darkColorText,
                        helperText: "Validation code",
                        helperStyle: TextStyle(
                            color: widget.darkMode
                                ? darkColorText
                                : lightColorText),
                        icon: Icon(Icons.confirmation_number,
                            color: widget.darkMode
                                ? darkColorText
                                : lightColorBackground),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text('Send new code?',
                        style: TextStyle(
                            color: widget.darkMode
                                ? darkColorBackground
                                : lightColorBackground)),
                    onPressed: () {
                      setState(() {
                        sendVerification();
                      });
                    },
                  ),
                ],
              ),
        TextButton(
          child: Text('Change authentication method',
              style: TextStyle(
                  color: widget.darkMode
                      ? darkColorBackground
                      : lightColorBackground)),
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
