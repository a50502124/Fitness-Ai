import 'dart:convert';
import 'package:flutter/services.dart';
import '../features/workouts/models/workout_plan.dart';

class WorkoutService {
  static final WorkoutService _instance = WorkoutService._internal();
  factory WorkoutService() => _instance;
  WorkoutService._internal();

  List<WorkoutPlan>? _cachedWorkouts;

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    if (_cachedWorkouts != null) {
      return _cachedWorkouts!;
    }

    try {
      // Load from assets
      final String response = await rootBundle.loadString('assets/workouts/beginner_fullbody.json');
      final Map<String, dynamic> data = json.decode(response);
      final WorkoutPlan workout = WorkoutPlan.fromJson(data);
      
      _cachedWorkouts = [workout];
      return _cachedWorkouts!;
    } catch (e) {
      // Return empty list if loading fails
      return [];
    }
  }

  Future<WorkoutPlan?> getWorkoutPlan(String id) async {
    final workouts = await getWorkoutPlans();
    try {
      return workouts.firstWhere((workout) => workout.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<WorkoutPlan>> getWorkoutsByLevel(String level) async {
    final workouts = await getWorkoutPlans();
    return workouts.where((workout) => workout.level == level).toList();
  }

  Future<List<WorkoutPlan>> getWorkoutsByTargetArea(String targetArea) async {
    final workouts = await getWorkoutPlans();
    return workouts.where((workout) => workout.targetAreas.contains(targetArea)).toList();
  }

  Future<List<WorkoutPlan>> searchWorkouts(String query) async {
    final workouts = await getWorkoutPlans();
    final lowercaseQuery = query.toLowerCase();
    
    return workouts.where((workout) {
      return workout.name.toLowerCase().contains(lowercaseQuery) ||
             workout.description.toLowerCase().contains(lowercaseQuery) ||
             workout.targetAreas.any((area) => area.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Mock data for additional workout plans
  Future<List<WorkoutPlan>> getMockWorkoutPlans() async {
    return [
      WorkoutPlan(
        id: 'upper_body_strength',
        name: 'Upper Body Strength',
        description: 'Build upper body muscle and strength',
        level: 'intermediate',
        daysPerWeek: 2,
        weeks: 6,
        estimatedDuration: '60 minutes',
        equipment: ['dumbbells', 'barbell', 'bench'],
        targetAreas: ['chest', 'back', 'arms', 'shoulders'],
        days: [
          WorkoutDay(
            day: 1,
            name: 'Push Day',
            focus: 'Chest, Shoulders, Triceps',
            estimatedDuration: '60 minutes',
            exercises: [
              Exercise(
                name: 'Bench Press',
                sets: 4,
                reps: '8-10',
                rest: '90s',
                instructions: 'Lie on bench, lower bar to chest, press up',
                tips: 'Keep core tight, don\'t bounce off chest',
                videoUrl: 'https://youtube.com/watch?v=example1',
              ),
              Exercise(
                name: 'Overhead Press',
                sets: 3,
                reps: '8-10',
                rest: '90s',
                instructions: 'Press barbell overhead from shoulders',
                tips: 'Keep core engaged, don\'t arch back',
                videoUrl: 'https://youtube.com/watch?v=example2',
              ),
            ],
          ),
          WorkoutDay(
            day: 2,
            name: 'Pull Day',
            focus: 'Back, Biceps',
            estimatedDuration: '60 minutes',
            exercises: [
              Exercise(
                name: 'Deadlift',
                sets: 4,
                reps: '5-6',
                rest: '120s',
                instructions: 'Lift barbell from ground to standing position',
                tips: 'Keep back straight, drive through heels',
                videoUrl: 'https://youtube.com/watch?v=example3',
              ),
              Exercise(
                name: 'Pull-ups',
                sets: 3,
                reps: '6-10',
                rest: '90s',
                instructions: 'Hang from bar, pull body up until chin over bar',
                tips: 'Use full range of motion, control the descent',
                videoUrl: 'https://youtube.com/watch?v=example4',
              ),
            ],
          ),
        ],
      ),
      WorkoutPlan(
        id: 'hiit_cardio',
        name: 'HIIT Cardio',
        description: 'High intensity fat burning workout',
        level: 'intermediate',
        daysPerWeek: 3,
        weeks: 4,
        estimatedDuration: '30 minutes',
        equipment: ['bodyweight'],
        targetAreas: ['full_body'],
        days: [
          WorkoutDay(
            day: 1,
            name: 'HIIT Circuit 1',
            focus: 'Full Body Cardio',
            estimatedDuration: '30 minutes',
            exercises: [
              Exercise(
                name: 'Burpees',
                sets: 4,
                reps: '30 seconds',
                rest: '30s',
                instructions: 'Squat down, jump back to plank, do push-up, jump forward, jump up',
                tips: 'Maintain intensity throughout the 30 seconds',
                videoUrl: 'https://youtube.com/watch?v=example5',
              ),
              Exercise(
                name: 'Mountain Climbers',
                sets: 4,
                reps: '30 seconds',
                rest: '30s',
                instructions: 'In plank position, alternate bringing knees to chest',
                tips: 'Keep core tight, maintain plank position',
                videoUrl: 'https://youtube.com/watch?v=example6',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
