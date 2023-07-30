import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();


  String selectedQuestion = "";
  String picturePath = "";
  List iconList = [];
  List decodedBytesList = [];
  bool isIcon = false;
  int number = -1;

  List<String> questions = [];

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void setProfilePic(String imagePath) {
    setState(() {
      picturePath = imagePath;
    });
  }

  void createAccount()  {

  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> qsts = <DropdownMenuItem<String>>[];
    for (int i = 0; i < questions.length; i++) {
      qsts.add(DropdownMenuItem<String>(value: '$i', child: Text(questions[i])));
    }

    return Scaffold(
      body: Center(
        child: Container(
          height: 1000,
          width: 600,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/User page.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text('Création de compte',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              hintText: "Nom d'utilisateur",
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.account_box),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Nom d'utilisateur requis.";
                              } else if (value.length < 5) {
                                return "Un nom d'utilisateur doit au moins contenir 5 caractéres.";
                              } else if (!value
                                  .contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
                                return "Un nom d'utilisateur ne doit contenir que des lettres ou des chiffres";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: "Mot de passe",
                              icon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Mot de passe requis.";
                              } else if (value.length < 8) {
                                return "Un mot de passe doit contenir au minimum 8 caractéres.";
                              }else if (!value
                                  .contains(RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
                                return "Le mot de passe doit contenir au minimum un caractère spécial,\n un chiffre et une lettre en majuscule";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordCheckController,
                            decoration: const InputDecoration(
                              hintText: "Retapez votre mot de passe",
                              icon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value != passwordController.text) {
                                return "Le mot de passe écrit ne correspond pas";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
