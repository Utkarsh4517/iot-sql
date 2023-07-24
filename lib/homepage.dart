import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/components/combined.dart';
import 'package:sqltest/components/coordinates.dart';
import 'package:sqltest/components/graph_containers.dart';
import 'package:sqltest/components/humidity.dart';
import 'package:sqltest/components/temperature.dart';
import 'package:sqltest/constants/colors.dart';
import 'package:sqltest/server.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formatTimestamp(int unixTimestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  double latestTemp = 0.0;
  double latestHumidity = 0.0;

  // get latest temp and humidty
  var db = MySqlServer();

  void getTempData() {
    db.getConnection().then((conn) {
      String sql =
          'select Temperature from IOT order by Timestamp DESC limit 1';

      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            latestTemp = row[0];
          });
        }
      });
    });
  }

  void getHumidityData() {
    db.getConnection().then((conn) {
      String sql = 'select Humidity from IOT order by Timestamp DESC limit 1';

      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            latestHumidity = row[0];
          });
        }
      });
    });
  }

  @override
  void initState() {
    getTempData();
    getHumidityData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
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
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04, vertical: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: darkGreyColor,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 70,
                              lineWidth: 10,
                              percent: latestTemp / 100,
                              progressColor: Colors.blue,
                              animation: true,
                              center: GradientText(
                                '$latestTemp',
                                colors: const [
                                  Colors.red,
                                  Colors.redAccent,
                                  Colors.purple
                                ],
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.05),
                            GradientText(
                              'Latest Temperature',
                              colors: const [
                                Colors.red,
                                Colors.redAccent,
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: darkGreyColor,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 70,
                              lineWidth: 10,
                              percent: latestHumidity / 100,
                              progressColor: Colors.blueAccent,
                              animation: true,
                              center: GradientText(
                                '$latestHumidity',
                                colors: const [
                                  Colors.red,
                                  Colors.redAccent,
                                  Colors.purple
                                ],
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.05),
                            GradientText('Latest Humidity', colors: const [
                              Colors.red,
                              Colors.redAccent,
                            ])
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.055),
              const Wrap(
                children: [
                  GraphContainer(
                      text: 'Temperature',
                      icon: Icons.thermostat,
                      iconColor: Colors.orange,
                      containerToLoad: TemperatureGraph()),
                  GraphContainer(
                      text: 'Humidity',
                      icon: Icons.thermostat_auto,
                      iconColor: Colors.blue,
                      containerToLoad: HumidityGraph()),
                  GraphContainer(
                      text: 'Coordinates',
                      icon: FeatherIcons.barChart2,
                      iconColor: Colors.white,
                      containerToLoad: CoordinatesGraph()),
                  GraphContainer(
                      text: 'Combined',
                      icon: FeatherIcons.monitor,
                      iconColor: Colors.white,
                      containerToLoad: CombinedGraph()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
