import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/theme/app_colors.dart';
import '../models/workout_plan.dart';
import '../screens/workout_detail_screen.dart';
import '../../../services/workout_service.dart';

class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  final WorkoutService _workoutService = WorkoutService();
  List<WorkoutPlan> _workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final workouts = await _workoutService.getWorkoutPlans();
      final mockWorkouts = await _workoutService.getMockWorkoutPlans();
      setState(() {
        _workouts = [...workouts, ...mockWorkouts];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Workout Library',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Choose your workout plan',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Workout Plans
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _workouts.length,
                          itemBuilder: (context, index) {
                            final workout = _workouts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildWorkoutPlan(context, workout),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutPlan(BuildContext context, WorkoutPlan workout) {
    final colors = [AppColors.primary, AppColors.secondary, AppColors.accent, AppColors.error];
    final icons = [Icons.fitness_center, Icons.self_improvement, Icons.directions_run, Icons.speed];
    final colorIndex = _workouts.indexOf(workout) % colors.length;
    final color = colors[colorIndex];
    final icon = icons[colorIndex];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(workout: workout),
          ),
        );
      },
      child: FrostedCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        workout.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip('${workout.daysPerWeek} days/week', Icons.calendar_today, color),
                const SizedBox(width: 8),
                _buildInfoChip(workout.estimatedDuration, Icons.timer, color),
                const SizedBox(width: 8),
                _buildInfoChip(workout.level.toUpperCase(), Icons.trending_up, color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
