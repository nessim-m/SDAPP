import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:sd_app/objects/sockets.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';
import '../objects/sensors.dart';

const host =
    "192.168.1.139"; // # The SERVER's hostname/IP - find from machine, should not be the public IP
// final info = NetworkInfo();
// const port =
//     5001; //Port to listen on (non-privileged ports are > 1023), should be same for client and server

const status_server_port = 5001;
const distance_server_port = 5002;
const cpu_temp_server_port = 5003;
const cpu_usage_server_port = 5004;
const ram_usage_server_port = 5005;
const latitude_server_port = 5006;
const longitude_server_port = 5007;

const robotStatusClientName = "RobotStatusClient";
const robotDistanceClientName = "RobotDistanceClient";
const robotCpuTempClientName = "RobotCpuTempClient";
const robotCpuUsageClientName = "RobotCpuUsageClient";
const robotRamUsageClientName = "RobotRamUsageClient";
const robotLatitudeClientName = "RobotLatitudeClient";
const robotLongitudeClientName = "RobotLongitudeClient";

class ClientsProvider with ChangeNotifier {
  SensorsList sensorsList = SensorsList(sensorList: [
    Sensor(id: robotStatusClientName, title: "Status", value: "Idle"),
    Sensor(id: robotDistanceClientName, title: "Distance", value: "Idle"),
    Sensor(id: robotLatitudeClientName, title: "Latitude", value: "Idle"),
    Sensor(id: robotLongitudeClientName, title: "Longitude", value: "Idle"),
    Sensor(id: robotCpuTempClientName, title: "CPU Temp", value: " Idle"),
    Sensor(id: robotCpuUsageClientName, title: "CPU Usage", value: "Idle"),
    Sensor(id: robotRamUsageClientName, title: "RAM Usage", value: "Idle"),
  ]);
  late NamedSocketList namedSocketList;
  late Socket socket;
  String streamConnection = "Off";

  Future<void> startServerConnection() async {
    // String? host = await info.getWifiIP();
    Socket robotStatusSocket = await Socket.connect(host, status_server_port);
    print('RobotStatusProviderClient Connected to: '
        '${robotStatusSocket.remoteAddress.address}:${robotStatusSocket.remotePort}');
    sleep(const Duration(seconds: 1));
    Socket robotDistanceSocket =
        await Socket.connect(host, distance_server_port);
    print('RobotDistanceProviderClient Connected to: '
        '${robotDistanceSocket.remoteAddress.address}:${robotDistanceSocket.remotePort}');
    sleep(const Duration(seconds: 1));
    Socket robotCpuTempSocket =
        await Socket.connect(host, cpu_temp_server_port);
    print('RobotCpuTempProviderClient Connected to: '
        '${robotCpuTempSocket.remoteAddress.address}:${robotCpuTempSocket.remotePort}');
    sleep(const Duration(seconds: 1));
    Socket robotCpuUsageSocket =
        await Socket.connect(host, cpu_usage_server_port);
    print('RobotCpuUsageProviderClient Connected to: '
        '${robotCpuUsageSocket.remoteAddress.address}:${robotCpuUsageSocket.remotePort}');
    sleep(const Duration(seconds: 1));
    Socket robotRamUsageSocket =
        await Socket.connect(host, ram_usage_server_port);
    print('RobotRamUsageProviderClient Connected to: '
        '${robotRamUsageSocket.remoteAddress.address}:${robotRamUsageSocket.remotePort}');

    sleep(const Duration(seconds: 1));

    Socket robotLatitudeSocket =
    await Socket.connect(host, latitude_server_port);
    print('RobotRamUsageProviderClient Connected to: '
        '${robotLatitudeSocket.remoteAddress.address}:${robotLatitudeSocket.remotePort}');

    sleep(const Duration(seconds: 1));
    Socket robotLongitudeSocket =
    await Socket.connect(host, longitude_server_port);
    print('RobotRamUsageProviderClient Connected to: '
        '${robotLongitudeSocket.remoteAddress.address}:${robotLongitudeSocket.remotePort}');

    namedSocketList = NamedSocketList(namedSocketList: [
      NamedSocket(id: robotStatusClientName, socket: robotStatusSocket),
      NamedSocket(id: robotDistanceClientName, socket: robotDistanceSocket),
      NamedSocket(id: robotCpuTempClientName, socket: robotCpuTempSocket),
      NamedSocket(id: robotCpuUsageClientName, socket: robotCpuUsageSocket),
      NamedSocket(id: robotRamUsageClientName, socket: robotRamUsageSocket),
      NamedSocket(id: robotLatitudeClientName, socket: robotLatitudeSocket),
      NamedSocket(id: robotLongitudeClientName, socket: robotLongitudeSocket),
    ]);
    String startMessage = "On";
    robotStatusSocket.write("2");
    sleep(const Duration(seconds: 1));
    robotStatusSocket.write(startMessage);
    sleep(const Duration(seconds: 1));
    streamConnection = startMessage;
    notifyListeners();

    serverListener(robotStatusClientName);
    //sleep(const Duration(seconds: 1));
    serverListener(robotDistanceClientName);
    //sleep(const Duration(seconds: 1));
    serverListener(robotCpuTempClientName);
    //sleep(const Duration(seconds: 1));
    serverListener(robotCpuTempClientName);
    //sleep(const Duration(seconds: 1));
    serverListener(robotCpuUsageClientName);
    //sleep(const Duration(seconds: 1));
    serverListener(robotRamUsageClientName);
    //sleep(const Duration(seconds: 1));
    serverListener(robotLatitudeClientName);
    serverListener(robotLongitudeClientName);
  }

  Future<String> serverListener(String id) async {
    Socket socket = namedSocketList.findById(id).socket;
    String oldServerResponse = " ";
    socket.listen(
      // handle data from the server
      (Uint8List data) {
        final newServerResponse = String.fromCharCodes(data);
        if (oldServerResponse != newServerResponse) {
          sensorsList.findById(id).setSensorValue = newServerResponse;
          oldServerResponse = newServerResponse;
          notifyListeners();
          print('Server->$id: ${sensorsList.findById(id).value}');
        }
      },
      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server->$id left.');
        socket.destroy();
      },
    );
    return "Server $id Disconnected";
  }

  Future<void> sendDataToStatusServer(String id, String message) async {
    Socket socket = namedSocketList.findById(id).socket;
    socket.write(message.length.toString());
    sleep(const Duration(seconds: 1));
    socket.write(message);
    //await Future.delayed(const Duration(seconds: 2));
  }

  String get getStreamConnection => streamConnection;
}
