import 'package:flutter/material.dart';
import 'package:sqltest/homepage.dart';
import 'package:sqltest/server.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const HomePage()
    );
  }
}
