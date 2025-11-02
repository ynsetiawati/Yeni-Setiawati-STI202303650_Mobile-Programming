class EventModel {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String time;
  final String? imagePath;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'date': date.toIso8601String(),
        'time': time,
        'imagePath': imagePath,
      };

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        date: DateTime.parse(json['date']),
        time: json['time'],
        imagePath: json['imagePath'],
      );
}
