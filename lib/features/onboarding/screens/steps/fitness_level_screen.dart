import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/frosted_card.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/theme/app_colors.dart';

class FitnessLevelScreen extends StatefulWidget {
  const FitnessLevelScreen({super.key});

  @override
  State<FitnessLevelScreen> createState() => _FitnessLevelScreenState();
}

class _FitnessLevelScreenState extends State<FitnessLevelScreen> {
  String? selectedLevel;

  final List<Map<String, dynamic>> _fitnessLevels = [
    {
      'id': 'beginner',
      'name': 'Beginner',
      'description': 'New to fitness or returning after a long break',
      'icon': '🌱',
      'color': AppColors.success,
    },
    {
      'id': 'intermediate',
      'name': 'Intermediate',
      'description': 'Some experience, can handle moderate workouts',
      'icon': '💪',
      'color': AppColors.warning,
    },
    {
      'id': 'advanced',
      'name': 'Advanced',
      'description': 'Very experienced, can handle intense workouts',
      'icon': '🔥',
      'color': AppColors.error,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Header Section
            Column(
              children: [
                // Title - Cal AI Style
                Text(
                  'What\'s your fitness level?',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                // Subtitle
                Text(
                  'This helps us recommend the right workouts for you',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
              
            const SizedBox(height: 48),
            
            // Fitness Level Cards - Cal AI Style
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _fitnessLevels.map((level) {
                    final isSelected = selectedLevel == level['id'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildFitnessLevelCard(level, isSelected),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Continue Button - Cal AI Style
            _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessLevelCard(Map<String, dynamic> level, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLevel = level['id'] as String;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected 
                ? (level['color'] as Color).withOpacity(0.05)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? level['color'] as Color
                  : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: (level['color'] as Color).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                level['icon'] as String,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level['name'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? level['color'] as Color
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: level['color'] as Color,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = selectedLevel != null;
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isEnabled ? AppColors.primary : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _onContinue : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Continue',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isEnabled ? Colors.white : AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (selectedLevel != null) {
      context.read<OnboardingBloc>().add(
        OnboardingFitnessLevelSelected(fitnessLevel: selectedLevel!),
      );
    }
  }
}
