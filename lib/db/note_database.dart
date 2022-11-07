import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;
  NoteDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('note.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    print(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const titleType = 'TEXT NOT NULL';
    const subtitleType = 'TEXT';
    const priorityType = 'INTEGER';
    const doneType = 'INTEGER NOT NULL';
    const isActiveType = 'INTEGER NOT NULL';
    await db.execute('''
    CREATE TABLE $tableNote (
      ${NoteFields.id} $idType,
      ${NoteFields.title} $titleType,
      ${NoteFields.subtitle} $subtitleType,
      ${NoteFields.priority} $priorityType,
      ${NoteFields.done} $doneType,
      ${NoteFields.isActive} $isActiveType
    )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNote, note.toMap());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableNote,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?', // prevents SQL Injenction
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

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

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNote, note.toMap(),
      where: '${NoteFields.id} = ?', // prevents SQL Injenction
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNote,
      where: '${NoteFields.id} = ?', // prevents SQL Injenction
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}