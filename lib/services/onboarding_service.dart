import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/onboarding/models/onboarding_data.dart';

class OnboardingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveOnboardingData(OnboardingData data) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Update user profile with onboarding data
      await _supabase.from('users').update({
        'has_completed_onboarding': true,
        'gender': data.gender,
        'target_areas': data.targetAreas,
        'fitness_level': data.fitnessLevel,
        'workout_location': data.workoutLocation,
        'days_per_week': data.daysPerWeek,
        'experience_level': data.experienceLevel,
        'weekly_goal': data.weeklyGoal,
        'height': data.height,
        'weight': data.weight,
        'unit_system': data.unitSystem,
        'bmi': data.bmi,
        'bmi_category': data.bmiCategory,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      // Create user goals based on onboarding data
      await _createUserGoals(data);

    } catch (e) {
      debugPrint('Onboarding save error: $e');
      throw Exception('Failed to save onboarding data: ${e.toString()}');
    }
  }

  Future<void> _createUserGoals(OnboardingData data) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Calculate daily calorie target based on goal and user data
      final dailyCalories = _calculateDailyCalories(data);
      final proteinTarget = _calculateProteinTarget(data);
      final carbTarget = _calculateCarbTarget(data);
      final fatTarget = _calculateFatTarget(data);

      // Insert user goals
      await _supabase.from('user_goals').insert({
        'user_id': user.id,
        'daily_calories': dailyCalories,
        'protein_target': proteinTarget,
        'carb_target': carbTarget,
        'fat_target': fatTarget,
        'workout_days_per_week': data.daysPerWeek,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

    } catch (e) {
      // Don't throw error for goals creation, it's not critical
      print('Failed to create user goals: $e');
    }
  }

  double _calculateDailyCalories(OnboardingData data) {
    if (data.height == null || data.weight == null) return 2000.0;

    // Calculate BMR using Harris-Benedict equation
    double bmr;
    if (data.gender == 'male') {
      bmr = 88.362 + (13.397 * data.weight!) + (4.799 * data.height!) - (5.677 * 25); // Assuming age 25
    } else {
      bmr = 447.593 + (9.247 * data.weight!) + (3.098 * data.height!) - (4.330 * 25); // Assuming age 25
    }

    // Activity multiplier based on workout days
    double activityMultiplier = 1.2; // Sedentary
    if (data.daysPerWeek != null) {
      if (data.daysPerWeek! >= 6) {
        activityMultiplier = 1.9; // Very active
      } else if (data.daysPerWeek! >= 4) {
        activityMultiplier = 1.7; // Active
      } else if (data.daysPerWeek! >= 2) {
        activityMultiplier = 1.5; // Moderately active
      }
    }

    double tdee = bmr * activityMultiplier;

    // Adjust based on goal
    switch (data.weeklyGoal) {
      case 'lose_weight':
        return tdee - 500; // 1 lb per week deficit
      case 'gain_weight':
        return tdee + 500; // 1 lb per week surplus
      case 'maintain':
      default:
        return tdee;
    }
  }

  double _calculateProteinTarget(OnboardingData data) {
    if (data.weight == null) return 150.0;
    
    // 1.6-2.2g per kg for muscle building, 0.8-1.2g for maintenance
    double proteinPerKg = 1.0;
    if (data.weeklyGoal == 'gain_weight') {
      proteinPerKg = 2.0;
    } else if (data.weeklyGoal == 'lose_weight') {
      proteinPerKg = 1.6; // Higher protein for weight loss to preserve muscle
    }
    
    return data.weight! * proteinPerKg;
  }

  double _calculateCarbTarget(OnboardingData data) {
    final dailyCalories = _calculateDailyCalories(data);
    final proteinTarget = _calculateProteinTarget(data);
    final proteinCalories = proteinTarget * 4;
    final fatCalories = dailyCalories * 0.25; // 25% from fat
    final carbCalories = dailyCalories - proteinCalories - fatCalories;
    return carbCalories / 4; // 4 calories per gram of carbs
  }

  double _calculateFatTarget(OnboardingData data) {
    final dailyCalories = _calculateDailyCalories(data);
    return (dailyCalories * 0.25) / 9; // 25% from fat, 9 calories per gram
  }
}
