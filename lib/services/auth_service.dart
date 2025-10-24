import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> getCurrentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session?.user != null) {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', session!.user.id)
            .single();
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed');
      }

      // Get user data from database
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userData);
    } catch (e) {
      debugPrint('Login error: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        throw Exception('Signup failed - no user created');
      }

      // Create user profile in database
      final userData = {
        'id': response.user!.id,
        'email': email,
        'name': name,
        'has_completed_onboarding': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('users').insert(userData);

      // Check if email confirmation is required
      if (response.session == null) {
        throw Exception('Please check your email and click the confirmation link to complete your registration');
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      debugPrint('Signup error: $e');
      
      // Handle specific Supabase errors
      if (e.toString().contains('User already registered')) {
        throw Exception('An account with this email already exists. Please try logging in instead.');
      } else if (e.toString().contains('Password should be at least')) {
        throw Exception('Password must be at least 6 characters long');
      } else if (e.toString().contains('Invalid email')) {
        throw Exception('Please enter a valid email address');
      } else if (e.toString().contains('Email rate limit exceeded')) {
        throw Exception('Too many signup attempts. Please try again later.');
      } else {
        throw Exception('Signup failed: ${e.toString()}');
      }
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.fitcoachai://login-callback/',
      );

      if (!response) {
        throw Exception('Google login failed');
      }

      // Wait for the session to be established
      await Future.delayed(const Duration(seconds: 2));
      
      final session = _supabase.auth.currentSession;
      if (session?.user == null) {
        throw Exception('Google login failed - no user session');
      }

      final user = session!.user;

      // Check if user exists in database
      final existingUser = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingUser == null) {
        // Create new user profile
        final userData = {
          'id': user.id,
          'email': user.email,
          'name': user.userMetadata?['full_name'],
          'avatar_url': user.userMetadata?['avatar_url'],
          'has_completed_onboarding': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await _supabase.from('users').insert(userData);
        return UserModel.fromJson(userData);
      } else {
        return UserModel.fromJson(existingUser);
      }
    } catch (e) {
      throw Exception('Google login failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _supabase.from('users').update({
        'name': user.name,
        'avatar_url': user.avatarUrl,
        'has_completed_onboarding': user.hasCompletedOnboarding,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }
}
