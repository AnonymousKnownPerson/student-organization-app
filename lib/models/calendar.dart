final String tableCalendar = 'calendar';

class CalendarFields {
  static final List<String> values = [
    id,
    title,
    subtitle,
    date,
    repeat,
    repeatEvery,
    duration,
  ];
  static const String id = '_id';
  static const String title = 'title';
  static const String subtitle = 'subtitle';
  static const String date = 'date';
  static const String repeat = 'repeat';
  static const String repeatEvery = 'repeatEvery';
  static const String duration = 'duration';
}

class Calendar {
  final int? id;
  final String title;
  final String? subtitle;
  final DateTime date;
  final bool repeat;
  final int? repeatEvery;
  final double duration;

  Calendar({
    this.id,
    required this.title,
    this.subtitle,
    required this.date,
    required this.repeat,
    this.repeatEvery,
    required this.duration,
  });

  Calendar copy({
    int? id,
    String? title,
    String? subtitle,
    DateTime? date,
    bool? repeat,
    int? repeatEvery,
    double? duration,
  }) =>
      Calendar(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        date: date ?? this.date,
        repeat: repeat ?? this.repeat,
        repeatEvery: repeatEvery ?? this.repeatEvery,
        duration: duration ?? this.duration,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      CalendarFields.title: title,
      CalendarFields.date: date.toIso8601String(),
      CalendarFields.repeat: repeat == true ? 1 : 0,
      CalendarFields.duration: duration,
    };
    if (id != null) {
      map[CalendarFields.id] = id;
    }
    if (subtitle != null) {
      map[CalendarFields.subtitle] = subtitle;
    }
    if (repeatEvery != null) {
      map[CalendarFields.repeatEvery] = repeatEvery;
    }
    return map;
  }

  static Calendar fromMap(Map<String, Object?> calendarTask) => Calendar(
        id: calendarTask[CalendarFields.id] as int?,
        title: calendarTask[CalendarFields.title] as String,
        subtitle: calendarTask[CalendarFields.subtitle] as String?,
        date: DateTime.parse(calendarTask[CalendarFields.date] as String),
        repeat: calendarTask[CalendarFields.repeat] == 1,
        repeatEvery: calendarTask[CalendarFields.repeatEvery] as int?,
        duration: calendarTask[CalendarFields.duration] as double,
      );
}
