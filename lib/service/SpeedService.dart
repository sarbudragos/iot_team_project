import 'package:iot_team_project/model/SpeedAndEnergyEntry.dart';
import 'package:iot_team_project/model/SpeedDatabaseEntry.dart';

import '../repository/AdditionalInformationRepository.dart';
import '../repository/SpeedSQLiteRepository.dart';

class SpeedService{
  SpeedSQLiteRepository speedSQLiteRepository;
  AdditionalInformationRepository additionalInformationRepository;

  SpeedService({
    required this.speedSQLiteRepository,
    required this.additionalInformationRepository,
  });

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

    return List.generate(databaseEntries.length, (index){
      SpeedDatabaseEntry databaseEntry = databaseEntries[index];

      return SpeedAndEnergyEntry(id: databaseEntry.id,
          speed: databaseEntry.speed,
          dateTime: databaseEntry.dateTime,
          energy: (mass * databaseEntry.speed * databaseEntry.speed)/2
      );
    });
  }

  Future<List<String>> getAllDays(){
    return speedSQLiteRepository.getAllDays();
  }

}