import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/error/exceptions.dart';

class DataService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Workout data methods
  Future<void> saveWorkout(Map<String, dynamic> workoutData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase.from('workouts').insert({
        'user_id': userId,
        ...workoutData,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save workout: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserWorkouts() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      final response = await _supabase
          .from('workouts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get workouts: ${e.toString()}');
    }
  }

  Future<void> saveWorkoutSession(Map<String, dynamic> sessionData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase.from('workout_sessions').insert({
        'user_id': userId,
        ...sessionData,
        'started_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save workout session: ${e.toString()}');
    }
  }

  // Nutrition data methods
  Future<void> saveNutritionLog(Map<String, dynamic> nutritionData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase.from('nutrition_logs').insert({
        'user_id': userId,
        ...nutritionData,
        'logged_at': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save nutrition log: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getNutritionLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      var query = _supabase
          .from('nutrition_logs')
          .select()
          .eq('user_id', userId)
          .order('logged_at', ascending: false);

      if (startDate != null) {
        query = query.gte('logged_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('logged_at', endDate.toIso8601String());
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get nutrition logs: ${e.toString()}');
    }
  }

  // Progress tracking methods
  Future<void> saveProgressEntry(Map<String, dynamic> progressData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase.from('progress_tracking').insert({
        'user_id': userId,
        ...progressData,
        'recorded_at': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save progress entry: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getProgressHistory() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      final response = await _supabase
          .from('progress_tracking')
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get progress history: ${e.toString()}');
    }
  }

  // Goals methods
  Future<void> saveGoal(Map<String, dynamic> goalData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase.from('goals').insert({
        'user_id': userId,
        ...goalData,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save goal: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserGoals() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      final response = await _supabase
          .from('goals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get goals: ${e.toString()}');
    }
  }

  Future<void> updateGoal(String goalId, Map<String, dynamic> updates) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase
          .from('goals')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', goalId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to update goal: ${e.toString()}');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase
          .from('goals')
          .delete()
          .eq('id', goalId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to delete goal: ${e.toString()}');
    }
  }
}