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
    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Title
              Text(
                'What\'s your fitness level?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'This helps us recommend the right workouts for you',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Fitness Level Cards
              ..._fitnessLevels.map((level) {
                final isSelected = selectedLevel == level['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLevel = level['id'] as String;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: FrostedCard(
                        padding: const EdgeInsets.all(20),
                        margin: EdgeInsets.zero,
                        backgroundColor: isSelected 
                            ? (level['color'] as Color).withOpacity(0.1)
                            : null,
                        border: isSelected 
                            ? Border.all(color: level['color'] as Color, width: 2)
                            : null,
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
                                Icons.check_circle,
                                color: level['color'] as Color,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              const Spacer(),
              
              // Continue Button
              AnimatedGradientButton(
                text: 'Continue',
                onPressed: selectedLevel != null ? _onContinue : null,
                width: double.infinity,
              ),
            ],
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
