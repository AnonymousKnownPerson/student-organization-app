import 'package:flutter/material.dart';
import 'package:student_app/db/database.dart';
import 'package:student_app/pages/calendar_page.dart';
import 'package:student_app/pages/notes_page.dart';
import 'package:student_app/pages/settings_page.dart';
import 'package:student_app/pages/todo_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/calendar.dart';
import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notesList = [];
  List<Note> _toDoList = [];
  List<Calendar> _calendarTasks = [];
  List<Calendar> _todayCalendarTask = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final PageController _pageController = PageController(initialPage: 1);
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      switch (index) {
        case 0:
          _refreshCalendarTasks();
          break;
        case 1:
          _refreshForToDo();
          break;
        case 2:
          _refreshForNotes();
          break;
        default:
          break;
      }
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
    _refreshCalendarTasks();
  }

  @override
  void dispose() {
    StudentDatabase.instance.close();
    super.dispose();
  }

  Future _refreshForNotes() async {
    setState(() => _isLoading = true);
    _notesList = await StudentDatabase.instance.readNotes(false);
    setState(() => _isLoading = false);
  }

  Future _refreshForToDo() async {
    setState(() => _isLoading = true);
    _toDoList = await StudentDatabase.instance.readNotes(true);
    _todayCalendarTask = await StudentDatabase.instance.readTodayTasks();
    _todayCalendarTask = _todayCalendarTask
        .where((element) => isSameDay(element.date, DateTime.now()))
        .toList();
    _todayCalendarTask.sort((a, b) => a.date.compareTo(b.date));
    setState(() => _isLoading = false);
  }

  Future _refreshCalendarTasks() async {
    setState(() => _isLoading = true);
    _calendarTasks = await StudentDatabase.instance.readCalendarTasks();
    _calendarTasks.sort((a, b) => a.date.compareTo(b.date));

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
          CalendarPage(
            calendarTasks: _calendarTasks,
            refresh: _refreshCalendarTasks,
            isLoading: _isLoading,
            checkPage: _currentPage,
          ),
          ToDoPage(
            refresh: _refreshForToDo,
            notesList: _toDoList,
            todayCalendarList: _todayCalendarTask,
            isLoading: _isLoading,
          ),
          NotesPage(
            refresh: _refreshForNotes,
            notesList: _notesList,
            isLoading: _isLoading,
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
              Icons.note_alt,
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
