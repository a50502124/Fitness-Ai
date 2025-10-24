import 'package:equatable/equatable.dart';

class WorkoutPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final String level;
  final int daysPerWeek;
  final int weeks;
  final String estimatedDuration;
  final List<String> equipment;
  final List<String> targetAreas;
  final List<WorkoutDay> days;

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.daysPerWeek,
    required this.weeks,
    required this.estimatedDuration,
    required this.equipment,
    required this.targetAreas,
    required this.days,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      level: json['level'] as String,
      daysPerWeek: json['daysPerWeek'] as int,
      weeks: json['weeks'] as int,
      estimatedDuration: json['estimatedDuration'] as String,
      equipment: List<String>.from(json['equipment'] as List),
      targetAreas: List<String>.from(json['targetAreas'] as List),
      days: (json['days'] as List)
          .map((day) => WorkoutDay.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'daysPerWeek': daysPerWeek,
      'weeks': weeks,
      'estimatedDuration': estimatedDuration,
      'equipment': equipment,
      'targetAreas': targetAreas,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        level,
        daysPerWeek,
        weeks,
        estimatedDuration,
        equipment,
        targetAreas,
        days,
      ];
}

class WorkoutDay extends Equatable {
  final int day;
  final String name;
  final String focus;
  final String estimatedDuration;
  final List<Exercise> exercises;

  const WorkoutDay({
    required this.day,
    required this.name,
    required this.focus,
    required this.estimatedDuration,
    required this.exercises,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      day: json['day'] as int,
      name: json['name'] as String,
      focus: json['focus'] as String,
      estimatedDuration: json['estimatedDuration'] as String,
      exercises: (json['exercises'] as List)
          .map((exercise) => Exercise.fromJson(exercise as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'name': name,
      'focus': focus,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [day, name, focus, estimatedDuration, exercises];
}

class Exercise extends Equatable {
  final String name;
  final int sets;
  final String reps;
  final String rest;
  final String instructions;
  final String tips;
  final String? videoUrl;

  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.instructions,
    required this.tips,
    this.videoUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as String,
      rest: json['rest'] as String,
      instructions: json['instructions'] as String,
      tips: json['tips'] as String,
      videoUrl: json['videoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'rest': rest,
      'instructions': instructions,
      'tips': tips,
      'videoUrl': videoUrl,
    };
  }

  @override
  List<Object?> get props => [
        name,
        sets,
        reps,
        rest,
        instructions,
        tips,
        videoUrl,
      ];
}
