import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/components/date_picker.dart';
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
  List<Map<String, dynamic>> allData = [];

  DateTime selectedDate = DateTime.now();

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
        // new
        data.sort((a, b) => a['Timestamp'].compareTo(b['Timestamp']));
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
                'Temperature vs Time',
                colors: const [Colors.red, Colors.redAccent, Colors.purple],
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(20),
              height: screenHeight * 0.4,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        drawBelowEverything: true,
                        axisNameSize: 20,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            return RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                formatTimestamp(value.toInt()),
                                style: TextStyle(fontSize: screenWidth * 0.015),
                              ),
                            );
                          },
                        )),
                    topTitles: AxisTitles(
                        drawBelowEverything: true,
                        axisNameSize: 20,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            return RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                formatTimestamp(value.toInt()),
                                style: TextStyle(fontSize: screenWidth * 0.015),
                              ),
                            );
                          },
                        )),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getTemperatureSpots(),
                      isCurved: true,
                      color: Colors.blue, // Set the color for Temperature line
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            DatePickerWidget(
              onDateChanged: (DateTime date) {
                // Filter data based on the selected date
                List<Map<String, dynamic>> filteredData = allData.where((data) {
                  DateTime dataDate = DateTime.fromMillisecondsSinceEpoch(
                      data['Timestamp'] * 1000);
                  return dataDate.year == date.year &&
                      dataDate.month == date.month &&
                      dataDate.day == date.day;
                }).toList();
                setState(() {
                  selectedDate = date;
                  allData = filteredData;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(int timestamp) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime localTime = dt.toLocal(); // Convert to local time
    return '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
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
}
