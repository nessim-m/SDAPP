import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sd_app/providers/clients_provider.dart';
import 'package:sd_app/widgets/sensor_widget.dart';

class SensorsGrid extends StatelessWidget {
  const SensorsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sensorsData = Provider.of<ClientsProvider>(context);
    final sensors = sensorsData.sensorsList.getSensors;
    return SizedBox(
      height: screenHeight/3,
      width: screenWidth,
      child: GridView.builder(
        //scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        padding: const EdgeInsets.all(5.0),
        itemCount: sensors.length,
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
            value: sensors[i], child:  SensorDisplay()),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
