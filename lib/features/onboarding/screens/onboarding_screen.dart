import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart' as app_state;
import '../models/onboarding_data.dart';
import 'steps/gender_selection_screen.dart';
import 'steps/target_areas_screen.dart';
import 'steps/fitness_level_screen.dart';
import 'steps/workout_location_screen.dart';
import 'steps/days_per_week_screen.dart';
import 'steps/experience_level_screen.dart';
import 'steps/weekly_goal_screen.dart';
import 'steps/height_weight_screen.dart';
import '../../../core/widgets/progress_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(const OnboardingStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, app_state.OnboardingState>(
      listener: (context, state) {
        if (state is app_state.OnboardingCompleted) {
          context.go('/home');
        } else if (state is app_state.OnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<OnboardingBloc, app_state.OnboardingState>(
        builder: (context, state) {
          if (state is app_state.OnboardingLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is app_state.OnboardingInProgress) {
            return _buildOnboardingStep(state);
          }

          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnboardingStep(app_state.OnboardingInProgress state) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar - Cal AI Style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: _buildProgressIndicator(state.currentStep, state.totalSteps),
            ),
            
            // Step Content
            Expanded(
              child: _getStepWidget(state.currentStep, state.data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep, int totalSteps) {
    final progress = currentStep / totalSteps;
    
    return Column(
      children: [
        // Step Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Progress Bar
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getStepWidget(int step, OnboardingData data) {
    switch (step) {
      case 1:
        return const GenderSelectionScreen();
      case 2:
        return const TargetAreasScreen();
      case 3:
        return const FitnessLevelScreen();
      case 4:
        return const WorkoutLocationScreen();
      case 5:
        return const DaysPerWeekScreen();
      case 6:
        return const ExperienceLevelScreen();
      case 7:
        return const WeeklyGoalScreen();
      case 8:
        return const HeightWeightScreen();
      default:
        return const Center(child: Text('Unknown step'));
    }
  }
}
