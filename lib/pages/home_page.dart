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
  List<Note> _notesList = [];
  List<Note> _toDoList = [];
  int _currentPage = 0;
  bool _isLoading = false;
  final PageController _pageController = PageController();
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _refreshForNotes();
      _refreshForToDo();
    });
  }

  void _onBottomBarTap(int val) {
    _pageController.animateToPage(
      val,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshForNotes();
    _refreshForToDo();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  Future _refreshForNotes() async {
    setState(() => _isLoading = true);
    _notesList = await NoteDatabase.instance.readNotes(false);
    setState(() => _isLoading = false);
  }

  Future _refreshForToDo() async {
    setState(() => _isLoading = true);
    _toDoList = await NoteDatabase.instance.readNotes(true);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CalendarPage(),
          ToDoPage(
            refresh: _refreshForToDo,
            notesList: _toDoList,
          ),
          NotesPage(
            refresh: _refreshForNotes,
            notesList: _notesList,
          ),
          SettingsPage(),
        ],
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
