part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> profileData;

  const ProfileUpdateRequested({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class ProgressEntryAddRequested extends ProfileEvent {
  final Map<String, dynamic> progressData;

  const ProgressEntryAddRequested({required this.progressData});

  @override
  List<Object> get props => [progressData];
}

class ProgressHistoryLoadRequested extends ProfileEvent {
  const ProgressHistoryLoadRequested();
}

class GoalsLoadRequested extends ProfileEvent {
  const GoalsLoadRequested();
}

class GoalAddRequested extends ProfileEvent {
  final Map<String, dynamic> goalData;

  const GoalAddRequested({required this.goalData});

  @override
  List<Object> get props => [goalData];
}

class GoalUpdateRequested extends ProfileEvent {
  final String goalId;
  final Map<String, dynamic> updates;

  const GoalUpdateRequested({
    required this.goalId,
    required this.updates,
  });

  @override
  List<Object> get props => [goalId, updates];
}

class GoalDeleteRequested extends ProfileEvent {
  final String goalId;

  const GoalDeleteRequested({required this.goalId});

  @override
  List<Object> get props => [goalId];
}