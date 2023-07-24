import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/components/date_picker.dart';
import 'package:sqltest/constants/colors.dart';
import 'package:sqltest/server.dart';

class HumidityGraph extends StatefulWidget {
  const HumidityGraph({super.key});

  @override
  State<HumidityGraph> createState() => _HumidityGraphState();
}

class _HumidityGraphState extends State<HumidityGraph> {
  // handling database requests
  var db = MySqlServer();
  List<Map<String, dynamic>> humidityData = [];

  DateTime selectedDate = DateTime.now();

  void getHumidity() {
    db.getConnection().then((conn) {
      String sql = 'select Timestamp, Humidity from IOT';
      conn.query(sql).then((results) {
        List<Map<String, dynamic>> humiData = [];
        for (var row in results) {
          Map<String, dynamic> rowData = {
            'Timestamp': row['Timestamp'],
            'Humidity': row['Humidity'],
          };
          humiData.add(rowData);
        }
        humiData.sort((a, b) => a['Timestamp'].compareTo(b['Timestamp']));
        setState(() {
          humidityData = humiData;
        });
      });
    });
  }

  @override
  void initState() {
    getHumidity();
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
                'Humidity vs Time',
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
                  minY: 20,
                  maxY: 100,
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
            ),
            DatePickerWidget(
              onDateChanged: (DateTime date) {
                // Filter data based on the selected date
                List<Map<String, dynamic>> filteredData =
                    humidityData.where((data) {
                  DateTime dataDate = DateTime.fromMillisecondsSinceEpoch(
                      data['Timestamp'] * 1000);
                  return dataDate.year == date.year &&
                      dataDate.month == date.month &&
                      dataDate.day == date.day;
                }).toList();
                setState(() {
                  selectedDate = date;
                  humidityData = filteredData;
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

  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < humidityData.length; i++) {
      double x = i.toDouble(); // Use the index as x-value
      double y = humidityData[i]['Humidity'].toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }
}
