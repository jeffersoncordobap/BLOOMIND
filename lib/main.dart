import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/resourses/controller/support_line_controller.dart';
import 'package:bloomind/features/resourses/repository/support_lines_repository_impl.dart';
import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/emotions/controller/emotion_controller.dart';
import 'package:bloomind/features/routines/controller/routine_controller.dart';
import 'package:bloomind/features/routines/controller/assing_routine_controller.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:bloomind/features/routines/repository/assign_routine_repository_impl.dart';
import 'package:bloomind/core/services/notification_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await NotificationService.instance.initNotifications();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  await NotificationService.instance.initTimezone();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmotionController()),
        ChangeNotifierProvider(
          create: (_) => RoutineController(repository: RoutineRepositoryImpl()),
        ),

        ChangeNotifierProvider(
          create: (_) => AssignRoutineController(
            routineRepo: RoutineRepositoryImpl(),
            assignRepo: AssignRoutineRepositoryImpl(),
          ),
        ),

        ChangeNotifierProvider(create: (_) => ActivityController()),
        ChangeNotifierProvider(
          create: (_) => DayRoutineController(
            assignRepo: AssignRoutineRepositoryImpl(),
            routineRepo: RoutineRepositoryImpl(),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => RoutineProvider(
            routineRepo: RoutineRepositoryImpl(),
            assignRepo: AssignRoutineRepositoryImpl(),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              SupportLineController(SupportLineRepositoryImpl()),
        ),
      ],
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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE9EDF2),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}
