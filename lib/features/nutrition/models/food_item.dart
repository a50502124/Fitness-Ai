import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final String servingSize;
  final String? barcode;
  final String? imageUrl;

  const FoodItem({
    required this.id,
    required this.name,
    this.brand = '',
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0.0,
    this.sugar = 0.0,
    this.sodium = 0.0,
    required this.servingSize,
    this.barcode,
    this.imageUrl,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String? ?? '',
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0.0,
      servingSize: json['servingSize'] as String,
      barcode: json['barcode'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'servingSize': servingSize,
      'barcode': barcode,
      'imageUrl': imageUrl,
    };
  }

  FoodItem copyWith({
    String? id,
    String? name,
    String? brand,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sugar,
    double? sodium,
    String? servingSize,
    String? barcode,
    String? imageUrl,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      servingSize: servingSize ?? this.servingSize,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        calories,
        protein,
        carbs,
        fat,
        fiber,
        sugar,
        sodium,
        servingSize,
        barcode,
        imageUrl,
      ];
}

class FoodLog extends Equatable {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String mealType;
  final FoodItem foodItem;
  final double quantity;
  final String notes;

  const FoodLog({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.mealType,
    required this.foodItem,
    required this.quantity,
    this.notes = '',
  });

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mealType: json['meal_type'] as String,
      foodItem: FoodItem.fromJson(json['food_item'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'meal_type': mealType,
      'food_item': foodItem.toJson(),
      'quantity': quantity,
      'notes': notes,
    };
  }

  // Calculate total nutrition for this log entry
  double get totalCalories => foodItem.calories * quantity;
  double get totalProtein => foodItem.protein * quantity;
  double get totalCarbs => foodItem.carbs * quantity;
  double get totalFat => foodItem.fat * quantity;
  double get totalFiber => foodItem.fiber * quantity;
  double get totalSugar => foodItem.sugar * quantity;
  double get totalSodium => foodItem.sodium * quantity;

  @override
  List<Object> get props => [
        id,
        userId,
        timestamp,
        mealType,
        foodItem,
        quantity,
        notes,
      ];
}

class NutritionSummary extends Equatable {
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final double totalSugar;
  final double totalSodium;
  final int mealCount;

  const NutritionSummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalFiber,
    required this.totalSugar,
    required this.totalSodium,
    required this.mealCount,
  });

  factory NutritionSummary.fromFoodLogs(List<FoodLog> logs) {
    return NutritionSummary(
      totalCalories: logs.fold(0.0, (sum, log) => sum + log.totalCalories),
      totalProtein: logs.fold(0.0, (sum, log) => sum + log.totalProtein),
      totalCarbs: logs.fold(0.0, (sum, log) => sum + log.totalCarbs),
      totalFat: logs.fold(0.0, (sum, log) => sum + log.totalFat),
      totalFiber: logs.fold(0.0, (sum, log) => sum + log.totalFiber),
      totalSugar: logs.fold(0.0, (sum, log) => sum + log.totalSugar),
      totalSodium: logs.fold(0.0, (sum, log) => sum + log.totalSodium),
      mealCount: logs.length,
    );
  }

  @override
  List<Object> get props => [
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFat,
        totalFiber,
        totalSugar,
        totalSodium,
        mealCount,
      ];
}
