import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../objects/sensors.dart';

class SensorDisplay extends StatelessWidget {
  const SensorDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sensor = Provider.of<Sensor>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(
          maxWidth: 100,
          maxHeight: 100,
        ),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              //alignment: WrapAlignment.spaceEvenly,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  '${sensor.title}: ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  width: ((sensor.title != "Status") &&
                          (sensor.title != "RAM Usage"))
                      ? 70
                      : 60,
                  child: Text(sensor.value,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
