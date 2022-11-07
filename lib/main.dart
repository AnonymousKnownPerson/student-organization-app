import 'package:flutter/material.dart';

import './pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thesis App O.O',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF544e50),
          secondary: const Color(0xFFe9e1e3),
          background: const Color(0xFFe9e1e3),
        ),
        fontFamily: 'Quicksand',
      ),
      home: HomePage(),
    );
  }
}
