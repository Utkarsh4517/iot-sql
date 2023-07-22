import 'package:flutter/material.dart';
import 'package:sqltest/constants/colors.dart';

class CoordinatesGraph extends StatelessWidget {
  const CoordinatesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: blackColor,
      body: Center(
        child: Text(
          'Coordinates',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
