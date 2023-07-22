import 'package:feather_icons/feather_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/components/combined.dart';
import 'package:sqltest/components/coordinates.dart';
import 'package:sqltest/components/graph_containers.dart';
import 'package:sqltest/components/humidity.dart';
import 'package:sqltest/components/temperature.dart';
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
    getCurrentTemp();
    getTemp();
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

  // get current temperature on init state

  void getCurrentTemp(){
    db.getConnection().then((conn){
      
    } );
  }

  String formatTimestamp(int unixTimestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenWidth * 0.1),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: GradientText(
                'Live Environment Data',
                colors: const [Colors.red, Colors.redAccent, Colors.purple],
                style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: screenWidth * 0.8),

            const Wrap(
              children: [
                GraphContainer(text: 'Temperature', icon: Icons.thermostat, iconColor: Colors.orange, containerToLoad: TemperatureGraph()),
                GraphContainer(text: 'Humidity', icon: Icons.thermostat_auto, iconColor: Colors.blue, containerToLoad: HumidityGraph()),
                GraphContainer(text: 'Coordinates', icon: FeatherIcons.barChart2, iconColor: Colors.white, containerToLoad: CoordinatesGraph()),
                GraphContainer(text: 'Combined', icon: FeatherIcons.monitor, iconColor: Colors.white, containerToLoad: CombinedGraph()),
              ],
            ),
            
            // Container(
            //   margin: const EdgeInsets.all(20),
            //   height: 300,
            //   child: LineChart(
            //     LineChartData(
            //       lineBarsData: [
            //         LineChartBarData(
            //           spots: getSpots(),
            //           isCurved: true,
            //           color: Colors.blue,
            //           dotData: const FlDotData(show: false),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
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
