import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'package:intl/date_symbol_data_local.dart'; // Para el idioma español
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/emotions/presentation/screens/emotion_record_screen.dart';
import 'package:bloomind/features/emotions/controller/emotion_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa idioma español para fechas
  await initializeDateFormatting('es_ES', null);

  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  runApp(
    // Envolvemos la app con el Provider
    ChangeNotifierProvider(
      create: (_) => EmotionController(),
      child: const BloomindApp(),
    ),
  );
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
