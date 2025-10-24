import 'package:equatable/equatable.dart';
import '../models/onboarding_data.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingInProgress extends OnboardingState {
  final OnboardingData data;
  final int currentStep;
  final int totalSteps;

  const OnboardingInProgress({
    required this.data,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  List<Object> get props => [data, currentStep, totalSteps];
}

class OnboardingCompleted extends OnboardingState {
  final OnboardingData data;

  const OnboardingCompleted({required this.data});

  @override
  List<Object> get props => [data];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError({required this.message});

  @override
  List<Object> get props => [message];
}
