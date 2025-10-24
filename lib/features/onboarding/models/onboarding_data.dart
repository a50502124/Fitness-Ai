import 'package:equatable/equatable.dart';

class OnboardingData extends Equatable {
  final String? gender;
  final List<String> targetAreas;
  final String? fitnessLevel;
  final String? workoutLocation;
  final int? daysPerWeek;
  final String? experienceLevel;
  final String? weeklyGoal;
  final double? height;
  final double? weight;
  final String? unitSystem; // 'metric' or 'imperial'

  const OnboardingData({
    this.gender,
    this.targetAreas = const [],
    this.fitnessLevel,
    this.workoutLocation,
    this.daysPerWeek,
    this.experienceLevel,
    this.weeklyGoal,
    this.height,
    this.weight,
    this.unitSystem = 'metric',
  });

  OnboardingData copyWith({
    String? gender,
    List<String>? targetAreas,
    String? fitnessLevel,
    String? workoutLocation,
    int? daysPerWeek,
    String? experienceLevel,
    String? weeklyGoal,
    double? height,
    double? weight,
    String? unitSystem,
  }) {
    return OnboardingData(
      gender: gender ?? this.gender,
      targetAreas: targetAreas ?? this.targetAreas,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      workoutLocation: workoutLocation ?? this.workoutLocation,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }

  bool get isComplete {
    return gender != null &&
        targetAreas.isNotEmpty &&
        fitnessLevel != null &&
        workoutLocation != null &&
        daysPerWeek != null &&
        experienceLevel != null &&
        weeklyGoal != null &&
        height != null &&
        weight != null;
  }

  double get bmi {
    if (height == null || weight == null) return 0.0;
    
    final heightInMeters = unitSystem == 'metric' 
        ? height! / 100 
        : height! * 0.3048; // Convert feet to meters
    
    final weightInKg = unitSystem == 'metric' 
        ? weight! 
        : weight! * 0.453592; // Convert lbs to kg
    
    return weightInKg / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal weight';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  List<Object?> get props => [
        gender,
        targetAreas,
        fitnessLevel,
        workoutLocation,
        daysPerWeek,
        experienceLevel,
        weeklyGoal,
        height,
        weight,
        unitSystem,
      ];
}
