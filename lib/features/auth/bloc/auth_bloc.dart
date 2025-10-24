import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_event.dart';
import 'auth_state.dart' as app_auth;
import '../models/user_model.dart';
import '../../../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, app_auth.AuthState> {
  final AuthService _authService;

  AuthBloc({AuthService? authService})
      : _authService = authService ?? AuthService(),
        super(const app_auth.AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignupRequested>(_onAuthSignupRequested);
    on<AuthGoogleLoginRequested>(_onAuthGoogleLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(app_auth.AuthAuthenticated(user: user));
      } else {
        emit(const app_auth.AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      emit(app_auth.AuthError(message: 'Failed to check authentication status'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      final user = await _authService.signInWithEmail(
        event.email,
        event.password,
      );
      emit(app_auth.AuthAuthenticated(user: user));
    } catch (e) {
      emit(app_auth.AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthSignupRequested(
    AuthSignupRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      final user = await _authService.signUpWithEmail(
        event.email,
        event.password,
        event.name,
      );
      emit(app_auth.AuthAuthenticated(user: user));
    } catch (e) {
      emit(app_auth.AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      final user = await _authService.signInWithGoogle();
      emit(app_auth.AuthAuthenticated(user: user));
    } catch (e) {
      emit(app_auth.AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      await _authService.signOut();
      emit(const app_auth.AuthUnauthenticated());
    } catch (e) {
      emit(app_auth.AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      await _authService.resetPassword(event.email);
      emit(const app_auth.AuthUnauthenticated());
    } catch (e) {
      emit(app_auth.AuthError(message: e.toString()));
    }
  }
}
