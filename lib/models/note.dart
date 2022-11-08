final String tableNote = 'note';

class NoteFields {
  static final List<String> values = [
    id,
    title,
    subtitle,
    priority,
    done,
    isActive
  ];
  static const String id = '_id';
  static const String title = 'title';
  static const String subtitle = 'subtitle';
  static const String priority = 'priority';
  static const String done = 'done';
  static const String isActive = 'isActive';
}

class Note {
  final int? id;
  final String title;
  final String? subtitle;
  final int priority;
  final bool done;
  final bool isActive;
  Note(
      {this.id,
      required this.title,
      this.subtitle,
      required this.priority,
      required this.done,
      required this.isActive});
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      NoteFields.title: title,
      NoteFields.done: done == true ? 1 : 0,
      NoteFields.isActive: isActive == true ? 1 : 0,
      NoteFields.priority: priority,
    };
    // Please don't look at this code it's 11 PM
    if (id != null) {
      map[NoteFields.id] = id;
    }
    if (subtitle != null) {
      map[NoteFields.subtitle] = subtitle;
    }
    return map;
  }

  Note copy({
    int? id,
    String? title,
    String? subtitle,
    int? priority,
    bool? done,
    bool? isActive,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        priority: priority ?? this.priority,
        done: done ?? this.done,
        isActive: isActive ?? this.isActive,
      );
  static Note fromMap(Map<String, Object?> note) => Note(
        id: note[NoteFields.id] as int?,
        title: note[NoteFields.title] as String,
        subtitle: note[NoteFields.subtitle] as String?,
        priority: note[NoteFields.priority] as int,
        done: note[NoteFields.done] == 1,
        isActive: note[NoteFields.isActive] == 1,
      );
}
