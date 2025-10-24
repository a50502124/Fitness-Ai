import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/models/user_model.dart';
import '../core/error/exceptions.dart';

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
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // User not found in users table, create profile
        return await _createUserProfile(session!.user);
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  Future<UserModel> _createUserProfile(User user) async {
    try {
      final userData = {
        'id': user.id,
        'email': user.email ?? '',
        'name': user.userMetadata?['full_name'] ?? user.userMetadata?['name'],
        'avatar_url': user.userMetadata?['avatar_url'],
        'has_completed_onboarding': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('users').insert(userData);
      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException('Failed to create user profile: ${e.toString()}');
    }
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Login failed - no user returned');
      }

      // Get user data from database
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      rethrow;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // User not found in users table, create profile
        return await _createUserProfile(response.user!);
      }
      throw ServerException(e.message);
    } on AuthException catch (e) {
      throw AuthException('Login failed: ${e.message}');
    } catch (e) {
      throw ServerException('Login failed: ${e.toString()}');
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
      );

      if (response.user == null) {
        throw AuthException('Signup failed - no user returned');
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

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Signup failed: ${e.toString()}');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.fitcoachai://login-callback/',
      );

      if (!response) {
        throw AuthException('Google login failed - OAuth response was false');
      }

      // Wait for the session to be established
      await Future.delayed(const Duration(seconds: 2));
      
      final session = _supabase.auth.currentSession;
      if (session?.user == null) {
        throw AuthException('Google login failed - no user session');
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
          'email': user.email ?? '',
          'name': user.userMetadata?['full_name'] ?? user.userMetadata?['name'],
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
    } on AuthException catch (e) {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Google login failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw ServerException('Logout failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthException('Password reset failed: ${e.message}');
    } catch (e) {
      throw ServerException('Password reset failed: ${e.toString()}');
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
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Profile update failed: ${e.toString()}');
    }
  }

  // Additional methods for data saving
  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabase.from('user_profiles').upsert({
        'id': userId,
        ...profileData,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to save user profile: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to get user profile: ${e.toString()}');
    }
  }

  // Stream for real-time auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
