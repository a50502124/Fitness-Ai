import 'package:equatable/equatable.dart';
import '../models/onboarding_data.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingStepCompleted extends OnboardingEvent {
  final OnboardingData data;

  const OnboardingStepCompleted({required this.data});

  @override
  List<Object> get props => [data];
}

class OnboardingGenderSelected extends OnboardingEvent {
  final String gender;

  const OnboardingGenderSelected({required this.gender});

  @override
  List<Object> get props => [gender];
}

class OnboardingTargetAreasSelected extends OnboardingEvent {
  final List<String> targetAreas;

  const OnboardingTargetAreasSelected({required this.targetAreas});

  @override
  List<Object> get props => [targetAreas];
}

class OnboardingFitnessLevelSelected extends OnboardingEvent {
  final String fitnessLevel;

  const OnboardingFitnessLevelSelected({required this.fitnessLevel});

  @override
  List<Object> get props => [fitnessLevel];
}

class OnboardingWorkoutLocationSelected extends OnboardingEvent {
  final String workoutLocation;

  const OnboardingWorkoutLocationSelected({required this.workoutLocation});

  @override
  List<Object> get props => [workoutLocation];
}

class OnboardingDaysPerWeekSelected extends OnboardingEvent {
  final int daysPerWeek;

  const OnboardingDaysPerWeekSelected({required this.daysPerWeek});

  @override
  List<Object> get props => [daysPerWeek];
}

class OnboardingExperienceLevelSelected extends OnboardingEvent {
  final String experienceLevel;

  const OnboardingExperienceLevelSelected({required this.experienceLevel});

  @override
  List<Object> get props => [experienceLevel];
}

class OnboardingWeeklyGoalSelected extends OnboardingEvent {
  final String weeklyGoal;

  const OnboardingWeeklyGoalSelected({required this.weeklyGoal});

  @override
  List<Object> get props => [weeklyGoal];
}

class OnboardingHeightWeightEntered extends OnboardingEvent {
  final double height;
  final double weight;
  final String unitSystem;

  const OnboardingHeightWeightEntered({
    required this.height,
    required this.weight,
    required this.unitSystem,
  });

  @override
  List<Object> get props => [height, weight, unitSystem];
}

class OnboardingCompleted extends OnboardingEvent {
  final OnboardingData data;

  const OnboardingCompleted({required this.data});

  @override
  List<Object> get props => [data];
}

class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}
