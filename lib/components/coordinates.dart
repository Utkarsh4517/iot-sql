import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/components/date_picker.dart';
import 'package:sqltest/constants/colors.dart';
import 'package:sqltest/server.dart';

class CoordinatesGraph extends StatefulWidget {
  const CoordinatesGraph({super.key});

  @override
  State<CoordinatesGraph> createState() => _CoordinatesGraphState();
}

class _CoordinatesGraphState extends State<CoordinatesGraph> {
  // handling database requests

  var db = MySqlServer();
  List<Map<String, dynamic>> xyzData = [];

  DateTime selectedDate = DateTime.now();

  void getXyzData() {
    db.getConnection().then((conn) {
      String sql = 'SELECT Timestamp, X, Y, Z FROM IOT';
      conn.query(sql).then((results) {
        List<Map<String, dynamic>> data = [];
        for (var row in results) {
          Map<String, dynamic> rowData = {
            'Timestamp': row['Timestamp'],
            'X': row['X'],
            'Y': row['Y'],
            'Z': row['Z'],
          };
          data.add(rowData);
        }
        data.sort((a, b) => a['Timestamp'].compareTo(b['Timestamp']));
        setState(() {
          xyzData = data;
        });
      });
    });
  }

  @override
  void initState() {
    getXyzData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                'X, Y and Z vs Time',
                colors: const [Colors.red, Colors.redAccent, Colors.purple],
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w500),
              ),
            ),

            // graph
            SizedBox(height: screenWidth * 0.1),
            const Text(
              'Blue = X   Red = Y   Green = Z',
              style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(20),
              height: 500,
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
                      spots: getXSpots(),
                      isCurved: true,
                      color: Colors
                          .blue, // You can set different colors for X, Y, and Z lines if you want
                      dotData: const FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: getYSpots(),
                      isCurved: true,
                      color: Colors
                          .red, // You can set different colors for X, Y, and Z lines if you want
                      dotData: const FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: getZSpots(),
                      isCurved: true,
                      color: Colors
                          .green, // You can set different colors for X, Y, and Z lines if you want
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),

            DatePickerWidget(
              onDateChanged: (DateTime date) {
                // Filter data based on the selected date
                List<Map<String, dynamic>> filteredData = xyzData.where((data) {
                  DateTime dataDate = DateTime.fromMillisecondsSinceEpoch(
                      data['Timestamp'] * 1000);
                  return dataDate.year == date.year &&
                      dataDate.month == date.month &&
                      dataDate.day == date.day;
                }).toList();
                setState(() {
                  selectedDate = date;
                  xyzData = filteredData;
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

  List<FlSpot> getXSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < xyzData.length; i++) {
      double x = i.toDouble(); // Use the index as x-value
      double y = xyzData[i]['X'].toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  List<FlSpot> getYSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < xyzData.length; i++) {
      double x = i.toDouble(); // Use the index as x-value
      double y = xyzData[i]['Y'].toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  List<FlSpot> getZSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < xyzData.length; i++) {
      double x = i.toDouble(); // Use the index as x-value
      double y = xyzData[i]['Z'].toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }
}
