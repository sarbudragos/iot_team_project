import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_team_project/model/SpeedAndEnergyEntry.dart';
import 'package:iot_team_project/service/SpeedService.dart';

import 'BluetoothScreen.dart';
import 'ListEntryWidget.dart';

class MainScreen extends StatefulWidget {

  final SpeedService speedService;

  const MainScreen({
    Key? key,
    required this.speedService,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  static MainScreenState? instance;

  late Future<List<String>> future;
  late List<String> days;

  String selectedDay = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();

    future = widget.speedService.getAllDays();

    instance = this;
  }

  // Callback function to trigger list refresh
  void refreshList() {
    setState(() {}); // Simply call setState to trigger a rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Speed entries'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              // Navigate to bluetooth page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BluetoothScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Mass:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: TextField(
                  controller: TextEditingController()
                    ..text = widget.speedService.getMass().toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    setState(() {
                      widget.speedService.setNewMass(double.parse(value));
                    });
                  },
                ),
              )
            ],
          ),
          FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  if (selectedDay.isEmpty) {
                    selectedDay = snapshot.data!.first;
                  }

                  return DropdownMenu<String>(
                    onSelected: (String? value) {
                      setState(() {
                        selectedDay = value!;
                      });
                    },
                    dropdownMenuEntries: snapshot.data!.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                    initialSelection: selectedDay,
                  );
                }
              }
              return const Center(
                child: Text('No data yet'),
              );
            },
          ),
          Expanded(
            child: FutureBuilder<List<SpeedAndEnergyEntry>>(
              future: widget.speedService.getAllEntriesByDay(DateTime.parse(selectedDay)),
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
            ),
          )
        ],
      ),
    );
  }
}
