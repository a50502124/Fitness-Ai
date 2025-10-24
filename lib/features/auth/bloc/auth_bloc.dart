import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_event.dart';
import 'auth_state.dart' as app_auth;
import '../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../core/error/exceptions.dart';

class AuthBloc extends Bloc<AuthEvent, app_auth.AuthState> {
  final AuthService _authService;
  StreamSubscription<AuthState>? _authStateSubscription;

  AuthBloc({AuthService? authService})
      : _authService = authService ?? AuthService(),
        super(const app_auth.AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignupRequested>(_onAuthSignupRequested);
    on<AuthGoogleLoginRequested>(_onAuthGoogleLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthProfileUpdateRequested>(_onAuthProfileUpdateRequested);
    
    // Listen to auth state changes
    _authStateSubscription = _authService.authStateChanges.listen((authState) {
      add(AuthCheckRequested());
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
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
    } on AuthException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Unexpected error: ${e.toString()}'));
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
    } on AuthException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Login failed: ${e.toString()}'));
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
    } on AuthException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Signup failed: ${e.toString()}'));
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
    } on AuthException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Google login failed: ${e.toString()}'));
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
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      await _authService.resetPassword(event.email);
      emit(const app_auth.AuthPasswordResetSent());
    } on AuthException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Password reset failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(const app_auth.AuthLoading());
    try {
      await _authService.updateUserProfile(event.user);
      emit(app_auth.AuthAuthenticated(user: event.user));
    } on ServerException catch (e) {
      emit(app_auth.AuthError(message: e.message));
    } catch (e) {
      emit(app_auth.AuthError(message: 'Profile update failed: ${e.toString()}'));
    }
  }
}
