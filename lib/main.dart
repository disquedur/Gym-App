import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_app/Classes/side_menu.dart';
import 'package:my_app/Pages/map_page.dart';
import 'Pages/login_page.dart';
import 'Pages/home_page.dart';
import 'Pages/sign_page.dart';
//import 'Services/Socket_service.dart';


final getIt = GetIt.instance;

void setup() {
 //getIt.registerSingleton<SocketService>(SocketService());
 //getIt<SocketService>().connect();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  FlutterError.onError = (FlutterErrorDetails details) {
    print("Error From INSIDE FRAME_WORK");
    print("----------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/signIn': (context) => SignInPage(),
        '/sideMenu': (context) => SideMenu(),
        '/map': (context) => MapComponent(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
