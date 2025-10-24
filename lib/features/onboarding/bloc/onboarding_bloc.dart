import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart' as app_state;
import '../models/onboarding_data.dart';
import '../../../services/onboarding_service.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, app_state.OnboardingState> {
  final OnboardingService _onboardingService;

  OnboardingBloc({OnboardingService? onboardingService})
      : _onboardingService = onboardingService ?? OnboardingService(),
        super(const app_state.OnboardingInitial()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingGenderSelected>(_onOnboardingGenderSelected);
    on<OnboardingTargetAreasSelected>(_onOnboardingTargetAreasSelected);
    on<OnboardingFitnessLevelSelected>(_onOnboardingFitnessLevelSelected);
    on<OnboardingWorkoutLocationSelected>(_onOnboardingWorkoutLocationSelected);
    on<OnboardingDaysPerWeekSelected>(_onOnboardingDaysPerWeekSelected);
    on<OnboardingExperienceLevelSelected>(_onOnboardingExperienceLevelSelected);
    on<OnboardingWeeklyGoalSelected>(_onOnboardingWeeklyGoalSelected);
    on<OnboardingHeightWeightEntered>(_onOnboardingHeightWeightEntered);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingSkipped>(_onOnboardingSkipped);
  }

  void _onOnboardingStarted(
    OnboardingStarted event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    emit(const app_state.OnboardingInProgress(
      data: OnboardingData(),
      currentStep: 1,
      totalSteps: 8,
    ));
  }

  void _onOnboardingGenderSelected(
    OnboardingGenderSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(gender: event.gender);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingTargetAreasSelected(
    OnboardingTargetAreasSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(targetAreas: event.targetAreas);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingFitnessLevelSelected(
    OnboardingFitnessLevelSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(fitnessLevel: event.fitnessLevel);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingWorkoutLocationSelected(
    OnboardingWorkoutLocationSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(workoutLocation: event.workoutLocation);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingDaysPerWeekSelected(
    OnboardingDaysPerWeekSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(daysPerWeek: event.daysPerWeek);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingExperienceLevelSelected(
    OnboardingExperienceLevelSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(experienceLevel: event.experienceLevel);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingWeeklyGoalSelected(
    OnboardingWeeklyGoalSelected event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(weeklyGoal: event.weeklyGoal);
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  void _onOnboardingHeightWeightEntered(
    OnboardingHeightWeightEntered event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    if (state is app_state.OnboardingInProgress) {
      final currentState = state as app_state.OnboardingInProgress;
      final updatedData = currentState.data.copyWith(
        height: event.height,
        weight: event.weight,
        unitSystem: event.unitSystem,
      );
      emit(app_state.OnboardingInProgress(
        data: updatedData,
        currentStep: currentState.currentStep + 1,
        totalSteps: currentState.totalSteps,
      ));
    }
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<app_state.OnboardingState> emit,
  ) async {
    emit(const app_state.OnboardingLoading());
    try {
      await _onboardingService.saveOnboardingData(event.data);
      emit(app_state.OnboardingCompleted(data: event.data));
    } catch (e) {
      emit(app_state.OnboardingError(message: e.toString()));
    }
  }

  void _onOnboardingSkipped(
    OnboardingSkipped event,
    Emitter<app_state.OnboardingState> emit,
  ) {
    // Skip onboarding with default values
    final defaultData = const OnboardingData(
      gender: 'other',
      targetAreas: ['full_body'],
      fitnessLevel: 'beginner',
      workoutLocation: 'home',
      daysPerWeek: 3,
      experienceLevel: 'beginner',
      weeklyGoal: 'maintain',
      height: 170.0,
      weight: 70.0,
      unitSystem: 'metric',
    );
    add(OnboardingCompleted(data: defaultData));
  }
}
