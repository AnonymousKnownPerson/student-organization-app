import 'package:flutter/material.dart';
import 'package:student_app/pages/calendar_page.dart';
import 'package:student_app/pages/notes_page.dart';
import 'package:student_app/pages/settings_page.dart';
import 'package:student_app/pages/todo_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/calendar-page': (context) => CalendarPage(),
        '/todo-list': (context) => ToDoPage(),
        '/notes': (context) => const NotesPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
