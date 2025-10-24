import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/onboarding/models/onboarding_data.dart';
import '../core/error/exceptions.dart';
import 'data_service.dart';

class OnboardingService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DataService _dataService = DataService();

  Future<void> saveOnboardingData(OnboardingData data) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw AuthException('User not authenticated');
      }

      // Update user profile with onboarding data
      await _supabase.from('users').update({
        'has_completed_onboarding': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      // Save detailed profile data
      final profileData = {
        'age': data.age,
        'gender': data.gender,
        'height_cm': data.height,
        'weight_kg': data.weight,
        'activity_level': _mapFitnessLevelToActivityLevel(data.fitnessLevel),
        'fitness_goals': data.targetAreas,
        'medical_conditions': data.medicalConditions ?? [],
      };

      await _dataService.saveUserProfile(profileData);

      // Create user goals based on onboarding data
      await _createUserGoals(data);

    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save onboarding data: ${e.toString()}');
    }
  }

  String _mapFitnessLevelToActivityLevel(String? fitnessLevel) {
    switch (fitnessLevel?.toLowerCase()) {
      case 'beginner':
        return 'light';
      case 'intermediate':
        return 'moderate';
      case 'advanced':
        return 'active';
      default:
        return 'light';
    }
  }

  Future<void> _createUserGoals(OnboardingData data) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Calculate daily calorie target based on goal and user data
      final dailyCalories = _calculateDailyCalories(data);

      // Create weight-related goal
      final goalType = _mapWeeklyGoalToGoalType(data.weeklyGoal);
      final goalData = {
        'goal_type': goalType,
        'target_value': dailyCalories,
        'current_value': 0.0,
        'unit': 'calories',
        'target_date': DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T')[0],
        'is_achieved': false,
      };

      await _dataService.saveGoal(goalData);

    } catch (e) {
      // Don't throw error for goals creation, it's not critical
      print('Failed to create user goals: $e');
    }
  }

  String _mapWeeklyGoalToGoalType(String? weeklyGoal) {
    switch (weeklyGoal?.toLowerCase()) {
      case 'lose_weight':
        return 'weight_loss';
      case 'gain_weight':
        return 'weight_gain';
      case 'build_muscle':
        return 'muscle_gain';
      case 'improve_endurance':
        return 'endurance';
      case 'get_stronger':
        return 'strength';
      case 'improve_flexibility':
        return 'flexibility';
      default:
        return 'weight_loss';
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
