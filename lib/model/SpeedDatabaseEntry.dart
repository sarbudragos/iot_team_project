class SpeedDatabaseEntry{
  int? id;
  double speed;
  DateTime dateTime;

  SpeedDatabaseEntry({
    this.id,
    required this.speed,
    required this.dateTime
  });

  factory SpeedDatabaseEntry.fromJson(Map<String,dynamic> json) => SpeedDatabaseEntry(
    id: json['id'],
    speed: json['speed'],
    dateTime: json['dateTime'],
  );

  Map<String,dynamic> toJson() => {
    'id': id,
    'speed': speed,
    'dateTime': dateTime,
  };
}