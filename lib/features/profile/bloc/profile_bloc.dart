import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/data_service.dart';
import '../../../core/error/exceptions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataService _dataService = DataService();

  ProfileBloc() : super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProgressEntryAddRequested>(_onProgressEntryAddRequested);
    on<ProgressHistoryLoadRequested>(_onProgressHistoryLoadRequested);
    on<GoalsLoadRequested>(_onGoalsLoadRequested);
    on<GoalAddRequested>(_onGoalAddRequested);
    on<GoalUpdateRequested>(_onGoalUpdateRequested);
    on<GoalDeleteRequested>(_onGoalDeleteRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _dataService.getUserProfile();
      emit(ProfileLoaded(profile: profile));
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await _dataService.saveUserProfile(event.profileData);
      final updatedProfile = await _dataService.getUserProfile();
      emit(ProfileLoaded(profile: updatedProfile));
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onProgressEntryAddRequested(
    ProgressEntryAddRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _dataService.saveProgressEntry(event.progressData);
      add(const ProgressHistoryLoadRequested());
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to save progress: ${e.toString()}'));
    }
  }

  Future<void> _onProgressHistoryLoadRequested(
    ProgressHistoryLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final progressHistory = await _dataService.getProgressHistory();
      emit(ProgressHistoryLoaded(progressHistory: progressHistory));
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load progress history: ${e.toString()}'));
    }
  }

  Future<void> _onGoalsLoadRequested(
    GoalsLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final goals = await _dataService.getUserGoals();
      emit(GoalsLoaded(goals: goals));
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load goals: ${e.toString()}'));
    }
  }

  Future<void> _onGoalAddRequested(
    GoalAddRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _dataService.saveGoal(event.goalData);
      add(const GoalsLoadRequested());
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to add goal: ${e.toString()}'));
    }
  }

  Future<void> _onGoalUpdateRequested(
    GoalUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _dataService.updateGoal(event.goalId, event.updates);
      add(const GoalsLoadRequested());
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to update goal: ${e.toString()}'));
    }
  }

  Future<void> _onGoalDeleteRequested(
    GoalDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _dataService.deleteGoal(event.goalId);
      add(const GoalsLoadRequested());
    } on AuthException catch (e) {
      emit(ProfileError(message: e.message));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (e) {
      emit(ProfileError(message: 'Failed to delete goal: ${e.toString()}'));
    }
  }
}