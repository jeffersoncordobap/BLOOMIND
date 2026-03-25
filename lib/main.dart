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

// NUEVOS IMPORTS
import 'package:bloomind/features/onboarding/data/onboarding_local_service.dart';
import 'package:bloomind/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await NotificationService.instance.initNotifications();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  await NotificationService.instance.initTimezone();

  // NUEVO: verificar si ya vio el onboarding
  final onboardingService = OnboardingLocalService();
  //final hasSeenOnboarding = await onboardingService.hasSeenOnboarding();
  final hasSeenOnboarding = false;
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
      child: BloomindApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class BloomindApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const BloomindApp({
    super.key,
    required this.hasSeenOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomind',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE9EDF2),
        useMaterial3: true,
      ),
      home: hasSeenOnboarding
          ? const MainNavigationScreen()
          : const OnboardingScreen(),
    );
  }
}