import 'package:flutter/material.dart';
import 'package:sqltest/constants/colors.dart';

class GraphContainer extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Widget containerToLoad;

  const GraphContainer({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.containerToLoad,
    super.key,
  });

  @override
  State<GraphContainer> createState() => _GraphContainerState();
}

class _GraphContainerState extends State<GraphContainer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (details) {
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.containerToLoad));
      },
      child: Container(
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
      ),
    );
  }
}
