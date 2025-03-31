import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/app/cat_list.dart';
import 'package:flutter_firebase/app/home.dart';
import 'package:flutter_firebase/app/login_screen.dart';
import 'package:flutter_firebase/app/signup_screen.dart';
import 'package:flutter_firebase/app/splash_screen.dart';
import 'package:flutter_firebase/widgets/animaredBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/cat_list': (context) => CatListScreen(),
        '/Example': (context) => Example(),
      },
    );
  }
}
