import 'package:iot_team_project/model/SpeedAndEnergyEntry.dart';
import 'package:iot_team_project/model/SpeedDatabaseEntry.dart';

import '../repository/AdditionalInformationRepository.dart';
import '../repository/SpeedSQLiteRepository.dart';

class SpeedService{
  static SpeedService? instance;

  SpeedSQLiteRepository speedSQLiteRepository;
  AdditionalInformationRepository additionalInformationRepository;

  SpeedService({
    required this.speedSQLiteRepository,
    required this.additionalInformationRepository,
  }) {
    instance = this;
  }

  Future<List<SpeedAndEnergyEntry>> getAllEntries() async {
    double mass = additionalInformationRepository.getMass();

    List<SpeedDatabaseEntry> databaseEntries = await speedSQLiteRepository.getAll();

    return List.generate(databaseEntries.length, (index){
      SpeedDatabaseEntry databaseEntry = databaseEntries[index];

      return SpeedAndEnergyEntry(id: databaseEntry.id,
          speed: databaseEntry.speed,
          dateTime: databaseEntry.dateTime,
          energy: (mass * databaseEntry.speed * databaseEntry.speed)/2
      );
    });
  }

  Future<List<SpeedAndEnergyEntry>> getAllEntriesByDay(DateTime day) async {
    double mass = additionalInformationRepository.getMass();

    List<SpeedDatabaseEntry> databaseEntries = await speedSQLiteRepository.getAllByDay(day);

    var result = List.generate(databaseEntries.length, (index){
      SpeedDatabaseEntry databaseEntry = databaseEntries[index];

      return SpeedAndEnergyEntry(id: databaseEntry.id,
          speed: databaseEntry.speed,
          dateTime: databaseEntry.dateTime,
          energy: (mass * databaseEntry.speed * databaseEntry.speed)/2
      );
    });

    return result.reversed.toList();
  }

  Future<List<String>> getAllDays() async{
    return speedSQLiteRepository.getAllDays();
  }

  double getMass(){
    return additionalInformationRepository.getMass();
  }

  void setNewMass(double mass){
    additionalInformationRepository.setMass(mass);
  }

  void addNewEntry(double speed) async {
    await speedSQLiteRepository.add(SpeedDatabaseEntry(speed: speed, dateTime: DateTime.now().toString()));
  }

  void addNewEntryBytes(List<int> data) async {
    int speedInt = data[0] + data[1] * 256 + data[2] * 256 * 256 + data[3] * 256 * 256 * 256;
    double speed = speedInt / 100.0;
    addNewEntry(speed);
  }

}