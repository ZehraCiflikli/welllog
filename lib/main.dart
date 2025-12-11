import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:welllog/pages/home_page.dart';
import 'package:welllog/pages/login_page.dart';
import 'package:welllog/pages/register_page.dart';
import 'package:welllog/providers/auth_provider.dart';
import 'package:welllog/pages/about_page.dart';
import 'firebase_options.dart'; // flutterfire ile oluşturduysan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welllog',
      routes: {
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/about": (context) => const AboutPage(),
      },
      home: LoginPage(),
      /*Scaffold(
        appBar: AppBar(title: Text('Welllog')),
        body: Center(child: Text('Başlangıç')),
      ),*/
    );
  }
}
