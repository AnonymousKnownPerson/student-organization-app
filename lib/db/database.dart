import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';
import '../models/calendar.dart';

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._init();
  static Database? _database;
  StudentDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('data.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, /*onUpgrade: _onUpgrade*/
    );
  }

/*
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    db.execute('DROP TABLE note');
    _createDB(db, newVersion);
  }
*/
  Future _createDB(Database db, int version) async {
    //Create table note
    const noteIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const noteTitleType = 'TEXT NOT NULL';
    const noteSubtitleType = 'TEXT';
    const notePriorityType = 'INTEGER';
    const noteDoneType = 'INTEGER NOT NULL';
    const noteIsActiveType = 'INTEGER NOT NULL';
    await db.execute('''
    CREATE TABLE $tableNote (
      ${NoteFields.id} $noteIdType,
      ${NoteFields.title} $noteTitleType,
      ${NoteFields.subtitle} $noteSubtitleType,
      ${NoteFields.priority} $notePriorityType,
      ${NoteFields.done} $noteDoneType,
      ${NoteFields.isActive} $noteIsActiveType
    )
    ''');
//  Create table Calendar
    const calendarIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const calendarTitleType = 'TEXT NOT NULL';
    const calendarSubtitleType = 'TEXT';
    const calendarDateType = 'TEXT NOT NULL';
    const calendarRepeatType = 'INTEGER NOT NULL';
    const calendarRepeatEveryType = 'INTEGER';
    const calendarDurationType = 'INTEGER NOT NULL';
    await db.execute('''
    CREATE TABLE $tableCalendar (
      ${CalendarFields.id} $calendarIdType,
      ${CalendarFields.title} $calendarTitleType,
      ${CalendarFields.subtitle} $calendarSubtitleType,
      ${CalendarFields.date} $calendarDateType,
      ${CalendarFields.repeat} $calendarRepeatType,
      ${CalendarFields.repeatEvery} $calendarRepeatEveryType,
      ${CalendarFields.duration} $calendarDurationType)
''');
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNote, note.toMap());
    return note.copy(id: id);
  }

  Future<Calendar> createCalendarTask(Calendar calendarTask) async {
    final db = await instance.database;
    final id = await db.insert(tableCalendar, calendarTask.toMap());
    return calendarTask.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableNote,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?', // prevents SQL Injection
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<Calendar> readCalendarTask(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableCalendar,
      columns: CalendarFields.values,
      where: '${CalendarFields.id} = ?', // prevents SQL Injection
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Calendar.fromMap(result.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

/*
  Future readLatestNoteId() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        '''SELECT max(${NoteFields.id}), ${NoteFields.title}, ${NoteFields.subtitle}, ${NoteFields.priority}, ${NoteFields.done}, ${NoteFields.isActive} FROM $tableNote''');
    if (result.isNotEmpty) {
      return Note.fromMap(result.first).id;
    } else {
      throw Exception('Table note is empty');
    }
  }
*/
  //not useful rn
/*
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(
      tableNote,
      orderBy: '${NoteFields.priority} DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }
*/
  Future<List<Note>> readNotes(bool active) async {
    final db = await instance.database;
    final result = await db.query(
      tableNote,
      where: '${NoteFields.isActive} = ?',
      whereArgs: [active == true ? 1 : 0],
      orderBy: '${NoteFields.priority} DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<List<Calendar>> readCalendarTasks() async {
    final db = await instance.database;
    final result = await db.query(
      tableCalendar,
      orderBy: '${CalendarFields.date} DESC',
    );
    return result.map((e) => Calendar.fromMap(e)).toList();
  }

  Future<List<Calendar>> readTodayTasks() async {
    // ! edit this later
    final db = await instance.database;
    final result = await db.query(
      tableCalendar,
      orderBy: '${CalendarFields.date} ASC',
    );
    List<Calendar> temp = result.map((e) => Calendar.fromMap(e)).toList();
    return temp
        .where(
            (element) => //DateTimeRange(start: element.date, end: element.date)
                true)
        .toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNote, note.toMap(),
      where: '${NoteFields.id} = ?', // prevents SQL Injection
      whereArgs: [note.id],
    );
  }

  Future<int> updateCalendarTask(Calendar calendarTask) async {
    final db = await instance.database;
    return db.update(
      tableCalendar, calendarTask.toMap(),
      where: '${CalendarFields.id} = ?', // prevents SQL Injection
      whereArgs: [calendarTask.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNote,
      where: '${NoteFields.id} = ?', // prevents SQL Injection
      whereArgs: [id],
    );
  }

  Future<int> deleteCalendarTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCalendar,
      where: '${CalendarFields.id} = ?', // prevents SQL Injection
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
