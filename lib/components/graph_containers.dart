import 'package:flutter/material.dart';
import 'package:sqltest/constants/colors.dart';

class GraphContainer extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const GraphContainer({
    required this.text,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  @override
  State<GraphContainer> createState() => _GraphContainerState();
}

class _GraphContainerState extends State<GraphContainer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.04),
      width: screenWidth * 0.3,
      height: screenWidth * 0.3,
      decoration: BoxDecoration(
          color: darkGreyColor, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: widget.iconColor, size: screenWidth * 0.1),
            SizedBox(height: screenWidth * 0.02),
            Text(widget.text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
