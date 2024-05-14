import 'package:flutter/material.dart';
import 'package:iot_team_project/model/SpeedAndEnergyEntry.dart';

class ListEntryWidget extends StatelessWidget {
  final SpeedAndEnergyEntry speedAndEnergyEntry;


  const ListEntryWidget(
      {Key? key,
        required this.speedAndEnergyEntry,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Date: ${speedAndEnergyEntry.dateTime}\n"
                    "Speed: ${speedAndEnergyEntry.speed.toStringAsFixed(2)} m/s\n"
                    "Energy: ${speedAndEnergyEntry.energy.toStringAsFixed(2)} J",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}