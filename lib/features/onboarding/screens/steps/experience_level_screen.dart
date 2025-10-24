import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/frosted_card.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/theme/app_colors.dart';

class ExperienceLevelScreen extends StatefulWidget {
  const ExperienceLevelScreen({super.key});

  @override
  State<ExperienceLevelScreen> createState() => _ExperienceLevelScreenState();
}

class _ExperienceLevelScreenState extends State<ExperienceLevelScreen> {
  String? selectedExperience;

  final List<Map<String, dynamic>> _experienceLevels = [
    {'id': 'beginner', 'name': 'Beginner', 'description': '0-6 months experience'},
    {'id': 'intermediate', 'name': 'Intermediate', 'description': '6 months - 2 years'},
    {'id': 'advanced', 'name': 'Advanced', 'description': '2+ years experience'},
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
              Text(
                'What\'s your experience level?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ..._experienceLevels.map((level) {
                final isSelected = selectedExperience == level['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedExperience = level['id']),
                    child: FrostedCard(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                      border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(level['name'], style: Theme.of(context).textTheme.titleLarge),
                                Text(level['description'], style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              AnimatedGradientButton(
                text: 'Continue',
                onPressed: selectedExperience != null ? _onContinue : null,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (selectedExperience != null) {
      context.read<OnboardingBloc>().add(
        OnboardingExperienceLevelSelected(experienceLevel: selectedExperience!),
      );
    }
  }
}
