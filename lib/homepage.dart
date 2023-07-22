import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sqltest/server.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String temp = 'Loading..';

  @override
  void initState() {
    super.initState();
  }

  var db = MySqlServer();
  double temperature = 0;
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

  String formatTimestamp(int unixTimestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text('temp is $temperature'),
            ElevatedButton(onPressed: getTemp, child: Text('press')),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.all(20),
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      dotData: const FlDotData(show: false),
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
