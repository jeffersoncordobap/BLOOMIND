import 'package:flutter/material.dart';

void main() {
  runApp(const BloomindApp());
}

class BloomindApp extends StatelessWidget {
  const BloomindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Blooming'))),
    );
  }
}
