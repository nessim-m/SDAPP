import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:sd_app/providers/clients_provider.dart';
import 'package:sd_app/widgets/switch_app_bar_widget.dart';
import 'package:sd_app/widgets/sensors_grid_widget.dart';
import 'widgets/in_app_web_view_widget.dart';

const robotStatusClientName = "RobotStatusClient";
const robotDistanceClientName = "RobotDistanceClient";

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ClientsProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool serverConnection = false;
  bool _isOn = true;

  void toggle() {
    setState(() => _isOn = !_isOn);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = SwitchAppBar(toggle: toggle);
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = appBar.preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    // String oldServerResponse = " ";
    // if (oldServerResponse != serverResponse) {
    //   context.read<ServerProvider>().sendDataToTheServer(socket, serverResponse);
    // }
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0.1,
            0.4,
            0.6,
            0.9,
          ],
          colors: [
            Colors.yellow,
            Colors.red,
            Colors.indigo,
            Colors.teal,
          ],
        )),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                ),
                child: SizedBox(
                  height: (screenHeight - appBarHeight - statusBarHeight) * 0.3,
                  child: const InAppWebViewWidget(),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 20),
                  onPressed: () {
                    // context.read<RobotStatusProvider>().connectToTheServer();
                    // sleep(const Duration(seconds: 1));
                    // context.read<RobotDistanceProvider>().connectToTheServer();
                    context.read<ClientsProvider>().startServerConnection();
                    sleep(const Duration(seconds: 1));
                    setState(() {
                      serverConnection = true;
                    });
                  },
                  child: const Text(
                    "Connect",
                    style: TextStyle(fontSize: 20),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Wrap(
                    spacing: 15,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black87,
                            elevation: 10),
                        onPressed: () {
                          context
                              .read<ClientsProvider>()
                              .sendDataToStatusServer(
                                  robotStatusClientName, "start");
                        },
                        child: const Icon(Icons.play_arrow_rounded),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black87,
                            elevation: 10),
                        onPressed: () {
                          // context
                          //     .read<RobotStatusProvider>()
                          //     .sendDataToTheServer("stop");

                          context
                              .read<ClientsProvider>()
                              .sendDataToStatusServer(
                                  robotStatusClientName, "stop");
                        },
                        child: const Icon(Icons.pause),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.black,
                thickness: 3,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                )),
                child: const Text(
                  "Hardware Monitor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.yellow),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 3,
              ),
              Row(
                children: [
                  serverConnection ? const SensorsGrid() : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
