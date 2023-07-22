import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sqltest/constants/colors.dart';

class CombinedGraph extends StatelessWidget {
  const CombinedGraph({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: blackColor,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(screenWidth * 0.06),
            alignment: Alignment.centerLeft,
            child: GradientText(
              'Combined Graph ',
              colors: const [Colors.red, Colors.redAccent, Colors.purple],
              style:
                  TextStyle(fontFamily: 'Lexend', fontSize: screenWidth * 0.07, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}