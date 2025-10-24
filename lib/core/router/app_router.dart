import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/workouts/screens/workout_library_screen.dart';
import '../../features/nutrition/screens/nutrition_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Skip redirect for auth routes to avoid infinite loops
      if (state.uri.path == '/login' || state.uri.path == '/signup') {
        return null;
      }
      
      // Check authentication state
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      
      // If user is not authenticated and trying to access protected routes
      if (authState is AuthUnauthenticated || authState is AuthError) {
        if (state.uri.path != '/login' && state.uri.path != '/signup') {
          return '/login';
        }
      }
      
      // If user is authenticated but hasn't completed onboarding
      if (authState is AuthAuthenticated) {
        if (!authState.user.hasCompletedOnboarding && state.uri.path != '/onboarding') {
          return '/onboarding';
        }
        if (authState.user.hasCompletedOnboarding && state.uri.path == '/onboarding') {
          return '/home';
        }
      }
      
      // Default redirect to home for root path
      if (state.uri.path == '/') {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Root route - will be redirected by the redirect logic
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'workouts',
            builder: (context, state) => const WorkoutLibraryScreen(),
          ),
          GoRoute(
            path: 'nutrition',
            builder: (context, state) => const NutritionScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
