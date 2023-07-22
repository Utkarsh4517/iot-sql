import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/constants/colors.dart';
import 'package:sqltest/server.dart';

class CombinedGraph extends StatefulWidget {
  const CombinedGraph({super.key});

  @override
  State<CombinedGraph> createState() => _CombinedGraphState();
}

class _CombinedGraphState extends State<CombinedGraph> {
  // handling database requests

 var db = MySqlServer();
List<Map<String, dynamic>> allData = [];

void getAllData() {
  db.getConnection().then((conn) {
    String sql = 'SELECT Timestamp, Temperature, Humidity, X, Y, Z FROM IOT';
    conn.query(sql).then((results) {
      List<Map<String, dynamic>> data = [];
      for (var row in results) {
        Map<String, dynamic> rowData = {
          'Timestamp': row['Timestamp'],
          'Temperature': row['Temperature'],
          'Humidity': row['Humidity'],
          'X': row['X'],
          'Y': row['Y'],
          'Z': row['Z'],
        };
        data.add(rowData);
      }
      setState(() {
        allData = data;
      });
    });
  });
}

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                'Combined Graph ',
                colors: const [Colors.red, Colors.redAccent, Colors.purple],
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: const Text(
                'Blue = Temp  Red = X   Green = Y \n  Orange = Z  Purple = Humidity',
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
        color: Colors.white,
        margin: const EdgeInsets.all(20),
        height: screenHeight * 0.9,
        child: LineChart(
          LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: getTemperatureSpots(),
            isCurved: true,
            color: Colors.blue, // Set the color for Temperature line
            dotData: const FlDotData(show: true),
          ),
           LineChartBarData(
            spots: getHumiditySpots(),
            isCurved: true,
            color: Colors.deepPurple, // Set the color for Temperature line
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: getXSpots(),
            isCurved: true,
            color : Colors.red, // Set the color for X line
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: getYSpots(),
            isCurved: true,
            color: Colors.green, // Set the color for Y line
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: getZSpots(),
            isCurved: true,
            color:  Colors.orange, // Set the color for Z line
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
List<FlSpot> getTemperatureSpots() {
  List<FlSpot> spots = [];
  for (int i = 0; i < allData.length; i++) {
    double x = allData[i]['Timestamp'].toDouble();
    double y = allData[i]['Temperature'].toDouble();
    spots.add(FlSpot(x, y));
  }
  return spots;
}

List<FlSpot> getHumiditySpots() {
  List<FlSpot> spots = [];
  for (int i = 0; i < allData.length; i++) {
    double x = allData[i]['Timestamp'].toDouble();
    double y = allData[i]['Humidity'].toDouble();
    spots.add(FlSpot(x, y));
  }
  return spots;
}

List<FlSpot> getXSpots() {
  List<FlSpot> spots = [];
  for (int i = 0; i < allData.length; i++) {
    double x = allData[i]['Timestamp'].toDouble();
    double y = allData[i]['X'].toDouble();
    spots.add(FlSpot(x, y));
  }
  return spots;
}

List<FlSpot> getYSpots() {
  List<FlSpot> spots = [];
  for (int i = 0; i < allData.length; i++) {
    double x = allData[i]['Timestamp'].toDouble();
    double y = allData[i]['Y'].toDouble();
    spots.add(FlSpot(x, y));
  }
  return spots;
}

List<FlSpot> getZSpots() {
  List<FlSpot> spots = [];
  for (int i = 0; i < allData.length; i++) {
    double x = allData[i]['Timestamp'].toDouble();
    double y = allData[i]['Z'].toDouble();
    spots.add(FlSpot(x, y));
  }
  return spots;
}

}
