import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/constants/colors.dart';
import 'package:sqltest/server.dart';

class TemperatureGraph extends StatefulWidget {
  const TemperatureGraph({super.key});

  @override
  State<TemperatureGraph> createState() => _TemperatureGraphState();
}

class _TemperatureGraphState extends State<TemperatureGraph> {
  // handling database requests
  var db = MySqlServer();
  List<Map<String, dynamic>> temperatureData = [];
  void getTemp() {
    db.getConnection().then((conn) {
      String sql = 'select Timestamp, Temperature from IOT';
      conn.query(sql).then((results) {
        List<Map<String, dynamic>> tempData = [];
        for (var row in results) {
          Map<String, dynamic> rowData = {
            'Timestamp': row['Timestamp'],
            'Temperature': row['Temperature'],
          };
          tempData.add(rowData);
        }
        setState(() {
          temperatureData = tempData;
        });
      });
    });
  }

  @override
  void initState() {
    getTemp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight  = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: blackColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(screenWidth * 0.06),
              alignment: Alignment.centerLeft,
              child: GradientText(
                'Temperature vs Time',
                colors: const [Colors.red, Colors.redAccent, Colors.purple],
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
      
            // graph
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(20),
              height: screenHeight * 0.9,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < temperatureData.length; i++) {
      double x = i.toDouble(); // Use the index as x-value
      double y = temperatureData[i]['Temperature'].toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }
}
