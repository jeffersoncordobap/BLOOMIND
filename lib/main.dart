import 'package:bloomind/features/emotions/presentation/screens/emotion_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloomind/core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  runApp(const BloomindApp());
}

class BloomindApp extends StatelessWidget {
  const BloomindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomind',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFE9EDF2)),
      home: const RegistroEmocionalScreen(),
    );
  }
}
