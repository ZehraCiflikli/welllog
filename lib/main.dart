import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:welllog/pages/change_password.dart';
import 'package:welllog/pages/edit_profile_page.dart';
import 'package:welllog/pages/home_page.dart';
import 'package:welllog/pages/login_page.dart';
import 'package:welllog/pages/register_page.dart';
import 'package:welllog/providers/auth_provider.dart';
import 'package:welllog/pages/about_page.dart';
import 'firebase_options.dart';
import 'package:welllog/providers/todo_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr'); // 👈 şart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // AuthProvider başlatılırken autoLogin() çağrılıyor.
        ChangeNotifierProvider(create: (_) => AuthProvider()..autoLogin()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
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
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/about": (context) => const AboutPage(),
        "/edit_profile": (context) => const EditProfilePage(),
        "/change_password": (context) => const PasswordChangePage(),
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
