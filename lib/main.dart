import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invest_iq/AuthView/Splashscreen.dart';
import 'package:provider/provider.dart';
import 'AuthView/Login.dart';
import 'Admin.dart';
import 'Provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invest-IQ',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      home: Splashscreen(),
    );
  }
}
