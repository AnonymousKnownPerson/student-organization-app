final String tableNote = 'note.db';

class NoteFields {
  static final List<String> values = [id, title, subtitle, piority, date, done];
  static const String id = '_id';
  static const String title = 'title';
  static const String subtitle = 'subtitle';
  static const String piority = 'piority';
  static const String date = 'date';
  static const String done = 'done';
}

class Note {
  final int? id;
  final String title;
  final String? subtitle;
  final int? piority;
  final DateTime? date;
  final bool done;
  Note({
    this.id,
    required this.title,
    this.subtitle,
    this.piority,
    this.date,
    required this.done,
  });
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      NoteFields.title: title,
      NoteFields.subtitle: subtitle,
      NoteFields.piority: piority,
      NoteFields.date: date?.toIso8601String(),
      NoteFields.done: done == true ? 1 : 0,
    };
    // Please don't look at this code it's 11 PM
    if (id != null) {
      map[NoteFields.id] = id;
    }
    if (subtitle != null) {
      map[NoteFields.subtitle] = subtitle;
    }
    if (piority != null) {
      map[NoteFields.piority] = piority;
    }
    if (date != null) {
      map[NoteFields.date] = date;
    }
    return map;
  }

  Note copy({
    int? id,
    String? title,
    String? subtitle,
    int? piority,
    DateTime? date,
    bool? done,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        piority: piority ?? this.piority,
        date: date ?? this.date,
        done: done ?? this.done,
      );

  static Note fromMap(Map<String, Object?> note) => Note(
        id: note[NoteFields.id] as int?,
        title: note[NoteFields.title] as String,
        subtitle: note[NoteFields.subtitle] as String?,
        piority: note[NoteFields.piority] as int?,
        date: DateTime.parse(note[NoteFields.date] as String),
        done: note[NoteFields.done] == 1,
      );
}
