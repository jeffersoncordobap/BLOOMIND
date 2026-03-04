import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/activities/presentation/activity_form_screen.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  const RoutineDetailScreen({super.key, required this.routine});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  final Color backgroundColor = const Color(0xFFF1F5F9);
  final Color primaryBlue = const Color(0xFF75B1EA);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityController>().fetchActivitiesByRoutine(
        widget.routine.idRoutine!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityController = context.watch<ActivityController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.routine.name,
          style: const TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: activityController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : activityController.currentRoutineActivities.isEmpty
          ? _buildEmptyState()
          : _buildActivityList(activityController.currentRoutineActivities),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Esta rutina aún no tiene actividades",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
          const SizedBox(height: 30),
          _buildAddActivityButton(),
        ],
      ),
    );
  }

  Widget _buildActivityList(List<Activity> activities) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: activities.length + 1,
      itemBuilder: (context, index) {
        if (index == activities.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _buildAddActivityButton(),
          );
        }

        final activity = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Text(activity.emoji, style: const TextStyle(fontSize: 35)),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${activity.hour} · ${activity.category}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddActivityButton() {
    return Center(
      child: SizedBox(
        width: 250,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ActivityScreen(idRoutine: widget.routine.idRoutine!),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Agregar actividad",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
