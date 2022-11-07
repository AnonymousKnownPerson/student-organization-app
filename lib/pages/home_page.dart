import 'package:flutter/material.dart';
import 'package:student_app/db/note_database.dart';
import 'package:student_app/pages/calendar_page.dart';
import 'package:student_app/pages/notes_page.dart';
import 'package:student_app/pages/settings_page.dart';
import 'package:student_app/pages/todo_page.dart';

import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<Widget> _pagesList = [
    CalendarPage(),
    ToDoPage(),
    const NotesPage(),
    const SettingsPage(),
  ];
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onBottomBarTap(int val) {
    _pageController.jumpToPage(val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pagesList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        showUnselectedLabels: true,
        onTap: _onBottomBarTap,
        items: const [
          BottomNavigationBarItem(
            label: 'Calendar',
            icon: Icon(
              Icons.calendar_month,
            ),
          ),
          BottomNavigationBarItem(
            label: 'ToDo List',
            icon: Icon(
              Icons.check_box,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Notes',
            icon: Icon(
              Icons.note,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
    );
  }
}
