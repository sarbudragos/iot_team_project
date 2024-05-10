import 'package:flutter/material.dart';
import 'package:iot_team_project/repository/AdditionalInformationRepository.dart';
import 'package:iot_team_project/repository/SpeedSQLiteRepository.dart';
import 'package:iot_team_project/service/SpeedService.dart';
import 'package:iot_team_project/ui/MainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SpeedSQLiteRepository speedSQLiteRepository = SpeedSQLiteRepository();
    AdditionalInformationRepository additionalInformationRepository = AdditionalInformationRepository(mass: 1.0);

    SpeedService speedService = SpeedService(
        speedSQLiteRepository: speedSQLiteRepository,
        additionalInformationRepository: additionalInformationRepository
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IOT Team project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(speedService: speedService),
    );
  }
}
