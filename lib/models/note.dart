class Note {
  final int? id;
  final String title;
  final String subtitle;
  final int? piority;
  final DateTime? date;
  Note({
    this.id,
    required this.title,
    required this.subtitle,
    this.piority,
    this.date,
  });
}
