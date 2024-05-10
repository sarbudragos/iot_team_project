class SpeedAndEnergyEntry{
  int? id;
  double speed;
  String dateTime;
  double energy;

  SpeedAndEnergyEntry({
    this.id,
    required this.speed,
    required this.dateTime,
    required this.energy,
  });

  factory SpeedAndEnergyEntry.fromJson(Map<String,dynamic> json) => SpeedAndEnergyEntry(
    id: json['id'],
    speed: json['speed'],
    dateTime: json['dateTime'],
    energy: json['energy'],
  );

  Map<String,dynamic> toJson() => {
    'id': id,
    'speed': speed,
    'dateTime': dateTime,
    'energy': energy,
  };
}