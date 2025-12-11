import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:welllog/pages/home_page.dart';
import 'package:welllog/pages/login_page.dart';
import 'package:welllog/pages/register_page.dart';
import 'package:welllog/providers/auth_provider.dart';
<<<<<<< HEAD
import 'package:welllog/pages/about_page.dart';
import 'firebase_options.dart'; // flutterfire ile oluşturduysan
=======
import 'firebase_options.dart';
>>>>>>> 516a9ef5597768fce4148f4fe0fd8aa90380e1e3

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // AuthProvider başlatılırken autoLogin() çağrılıyor.
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..autoLogin(),
        )
      ],
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

      // Routes (Rotasyonlar)
      routes: {
<<<<<<< HEAD
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/about": (context) => const AboutPage(),
=======
        // Tutarlılık için const ekledik
        "/login": (context) =>  LoginPage(),
        "/register": (context) =>  RegisterPage(),
        "/home": (context) =>  HomePage(),
>>>>>>> 516a9ef5597768fce4148f4fe0fd8aa90380e1e3
      },

      // Ana Sayfa (Dinamik Yönlendirme)
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          // ⚠️ DÜZELTME: isLoading yerine isAppLoading kullanıldı.
          // Bu, uygulamanın ilk açılışındaki oturum kontrolünü yönetir.
          if (auth.isAppLoading) {
            // Token kontrolü veya Firebase bağlantısı devam ederken gösterilecek ekran
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Oturum açılmışsa (isLoggedIn true ise)
          if (auth.isLoggedIn) {
            return const HomePage();
          }

          // Oturum kapalıysa veya bulunamadıysa
          return const LoginPage();
        },
      ),
    );
  }
}