import 'package:flutter/material.dart';
import 'package:iot_team_project/model/SpeedAndEnergyEntry.dart';
import 'package:iot_team_project/service/SpeedService.dart';

import 'ListEntryWidget.dart';

class MainScreen extends StatefulWidget {
  final SpeedService speedService;

  const MainScreen({Key? key,
    required this.speedService,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Speed entries'),
          centerTitle: true,
          //actions: [],
        ),
        body: FutureBuilder<List<SpeedAndEnergyEntry>>(
          future: widget.speedService.getAllEntries(),
          builder: (context, AsyncSnapshot<List<SpeedAndEnergyEntry>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemBuilder: (context, index) => ListEntryWidget(
                    speedAndEnergyEntry: snapshot.data![index],
                  ),
                  itemCount: snapshot.data!.length,
                );
              }
              return const Center(
                child: Text('No data yet'),
              );
            }
            return const SizedBox.shrink();
          },
        )
    );
  }
}