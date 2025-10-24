import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/widgets/empty_state.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/onboarding/bloc/onboarding_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Supabase with configuration
    await Supabase.initialize(
      url: 'https://your-project.supabase.co', // Replace with your Supabase URL
      anonKey: 'your-anon-key', // Replace with your Supabase anon key
      debug: true, // Set to false in production
    );
  } catch (e) {
    // Handle Supabase initialization error gracefully
    debugPrint('Supabase initialization failed: $e');
    // Continue app execution without Supabase for demo purposes
  }
  
  runApp(const FitCoachApp());
}

class FitCoachApp extends StatelessWidget {
  const FitCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (context) => OnboardingBloc()),
      ],
      child: MaterialApp.router(
        title: 'FitCoach AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return ErrorBoundary(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({
    super.key,
    required this.child,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Catch any errors that occur during widget building
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = details.exception.toString();
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
    return MaterialApp(
      title: 'FitCoach AI',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: ErrorState(
          title: 'Something went wrong',
          subtitle: 'We encountered an unexpected error. Please restart the app.',
          actionText: 'Restart App',
          onAction: () {
            setState(() {
              hasError = false;
              errorMessage = null;
            });
          },
        ),
      ),
    );
  }
}
