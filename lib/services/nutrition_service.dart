import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/nutrition/models/food_item.dart';

class NutritionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mock food database for MVP
  static final List<FoodItem> _mockFoodDatabase = [
    const FoodItem(
      id: '1',
      name: 'Chicken Breast',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '2',
      name: 'Brown Rice',
      calories: 111,
      protein: 2.6,
      carbs: 23,
      fat: 0.9,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '3',
      name: 'Broccoli',
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '4',
      name: 'Banana',
      calories: 89,
      protein: 1.1,
      carbs: 23,
      fat: 0.3,
      servingSize: '1 medium',
    ),
    const FoodItem(
      id: '5',
      name: 'Greek Yogurt',
      calories: 59,
      protein: 10,
      carbs: 3.6,
      fat: 0.4,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '6',
      name: 'Almonds',
      calories: 579,
      protein: 21,
      carbs: 22,
      fat: 50,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '7',
      name: 'Salmon',
      calories: 208,
      protein: 25,
      carbs: 0,
      fat: 12,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '8',
      name: 'Sweet Potato',
      calories: 86,
      protein: 1.6,
      carbs: 20,
      fat: 0.1,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '9',
      name: 'Eggs',
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
      servingSize: '100g',
    ),
    const FoodItem(
      id: '10',
      name: 'Oatmeal',
      calories: 68,
      protein: 2.4,
      carbs: 12,
      fat: 1.4,
      servingSize: '100g',
    ),
  ];

  Future<List<FoodItem>> searchFood(String query) async {
    if (query.isEmpty) return _mockFoodDatabase;
    
    final lowercaseQuery = query.toLowerCase();
    return _mockFoodDatabase.where((food) {
      return food.name.toLowerCase().contains(lowercaseQuery) ||
             food.brand.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<FoodItem?> getFoodById(String id) async {
    try {
      return _mockFoodDatabase.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<FoodItem>> getPopularFoods() async {
    // Return first 6 items as popular foods
    return _mockFoodDatabase.take(6).toList();
  }

  Future<List<FoodItem>> getFoodsByMealType(String mealType) async {
    // Mock logic - in real app, this would be based on user preferences
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return _mockFoodDatabase.where((food) => 
          ['Oatmeal', 'Greek Yogurt', 'Banana', 'Eggs'].contains(food.name)
        ).toList();
      case 'lunch':
        return _mockFoodDatabase.where((food) => 
          ['Chicken Breast', 'Brown Rice', 'Broccoli', 'Salmon'].contains(food.name)
        ).toList();
      case 'dinner':
        return _mockFoodDatabase.where((food) => 
          ['Salmon', 'Sweet Potato', 'Broccoli', 'Chicken Breast'].contains(food.name)
        ).toList();
      case 'snack':
        return _mockFoodDatabase.where((food) => 
          ['Almonds', 'Greek Yogurt', 'Banana'].contains(food.name)
        ).toList();
      default:
        return _mockFoodDatabase;
    }
  }

  Future<void> logFood(FoodLog foodLog) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabase.from('food_logs').insert({
        'id': foodLog.id,
        'user_id': user.id,
        'timestamp': foodLog.timestamp.toIso8601String(),
        'meal_type': foodLog.mealType,
        'food_item': foodLog.foodItem.toJson(),
        'quantity': foodLog.quantity,
        'notes': foodLog.notes,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to log food: ${e.toString()}');
    }
  }

  Future<List<FoodLog>> getFoodLogs(DateTime date) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('food_logs')
          .select()
          .eq('user_id', user.id)
          .gte('timestamp', startOfDay.toIso8601String())
          .lt('timestamp', endOfDay.toIso8601String())
          .order('timestamp', ascending: true);

      return (response as List)
          .map((log) => FoodLog.fromJson(log as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get food logs: ${e.toString()}');
    }
  }

  Future<List<FoodLog>> getFoodLogsByMealType(DateTime date, String mealType) async {
    final allLogs = await getFoodLogs(date);
    return allLogs.where((log) => log.mealType == mealType).toList();
  }

  Future<NutritionSummary> getNutritionSummary(DateTime date) async {
    final logs = await getFoodLogs(date);
    return NutritionSummary.fromFoodLogs(logs);
  }

  Future<void> deleteFoodLog(String logId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabase
          .from('food_logs')
          .delete()
          .eq('id', logId)
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Failed to delete food log: ${e.toString()}');
    }
  }

  Future<void> updateFoodLog(FoodLog foodLog) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabase
          .from('food_logs')
          .update({
            'meal_type': foodLog.mealType,
            'food_item': foodLog.foodItem.toJson(),
            'quantity': foodLog.quantity,
            'notes': foodLog.notes,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', foodLog.id)
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Failed to update food log: ${e.toString()}');
    }
  }

  // Calculate daily calorie target based on user goals
  Future<double> getDailyCalorieTarget() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 2000.0; // Default

      final response = await _supabase
          .from('user_goals')
          .select('daily_calories')
          .eq('user_id', user.id)
          .single();

      return (response['daily_calories'] as num).toDouble();
    } catch (e) {
      return 2000.0; // Default if no goals set
    }
  }

  // Calculate macro targets
  Future<Map<String, double>> getMacroTargets() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return {
          'protein': 150.0,
          'carbs': 250.0,
          'fat': 80.0,
        };
      }

      final response = await _supabase
          .from('user_goals')
          .select('protein_target, carb_target, fat_target')
          .eq('user_id', user.id)
          .single();

      return {
        'protein': (response['protein_target'] as num).toDouble(),
        'carbs': (response['carb_target'] as num).toDouble(),
        'fat': (response['fat_target'] as num).toDouble(),
      };
    } catch (e) {
      return {
        'protein': 150.0,
        'carbs': 250.0,
        'fat': 80.0,
      };
    }
  }
}
