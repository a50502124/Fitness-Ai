part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic>? profile;

  const ProfileLoaded({this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProgressHistoryLoaded extends ProfileState {
  final List<Map<String, dynamic>> progressHistory;

  const ProgressHistoryLoaded({required this.progressHistory});

  @override
  List<Object> get props => [progressHistory];
}

class GoalsLoaded extends ProfileState {
  final List<Map<String, dynamic>> goals;

  const GoalsLoaded({required this.goals});

  @override
  List<Object> get props => [goals];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}