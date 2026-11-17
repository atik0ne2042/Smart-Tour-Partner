import 'package:flutter/material.dart';

import 'homepage.dart'; // Tor homepage file-er name thik thakle eita thakbe

// 1. Global list jeta shob page theke data nibe
final ValueNotifier<List<Map<String, dynamic>>> allExpenses = ValueNotifier([]);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        // Dark theme setup
        scaffoldBackgroundColor: const Color(0xFF050A18),
        primaryColor: Colors.blueAccent,
      ),
      // Eikhane 'const' bad dewa hoilo jate dynamic data load hoye pare
      home: ExpenseHomePage(),
    );
  }
}