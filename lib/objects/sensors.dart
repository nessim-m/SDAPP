import 'package:flutter/cupertino.dart';

class Sensor with ChangeNotifier {
  final String id;
  final String title;
  String value;

  Sensor({required this.id, required this.title, this.value = "0"});

  set setSensorValue(String value) {
    this.value = value;
    notifyListeners();
  }
}

class SensorsList {
  List<Sensor> sensorList;

  SensorsList({required this.sensorList});

  List<Sensor> get getSensors {
    return [...sensorList];
  }

  Sensor findById(String id) {
    return sensorList.firstWhere((sensor) => sensor.id == id);
  }

  void addSensorList(List<Sensor> sensorList) {
    for (Sensor sensor in sensorList) {
      this.sensorList.add(sensor);
    }
  }
}
