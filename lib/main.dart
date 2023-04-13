import 'package:flutter/material.dart';
import 'package:map_test/screens/walk_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '犬の散歩管理アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WalkScreen(),
    );
  }
}
