import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/frosted_card.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/theme/app_colors.dart';

class WeeklyGoalScreen extends StatefulWidget {
  const WeeklyGoalScreen({super.key});

  @override
  State<WeeklyGoalScreen> createState() => _WeeklyGoalScreenState();
}

class _WeeklyGoalScreenState extends State<WeeklyGoalScreen> {
  String? selectedGoal;

  final List<Map<String, dynamic>> _goals = [
    {'id': 'lose_weight', 'name': 'Lose Weight', 'icon': '📉', 'description': 'Burn fat and get leaner'},
    {'id': 'gain_weight', 'name': 'Gain Weight', 'icon': '📈', 'description': 'Build muscle and get stronger'},
    {'id': 'maintain', 'name': 'Maintain', 'icon': '⚖️', 'description': 'Stay fit and healthy'},
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
                'What\'s your main goal?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ..._goals.map((goal) {
                final isSelected = selectedGoal == goal['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedGoal = goal['id']),
                    child: FrostedCard(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                      border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                      child: Row(
                        children: [
                          Text(goal['icon'], style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(goal['name'], style: Theme.of(context).textTheme.titleLarge),
                                Text(goal['description'], style: Theme.of(context).textTheme.bodyMedium),
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
                onPressed: selectedGoal != null ? _onContinue : null,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (selectedGoal != null) {
      context.read<OnboardingBloc>().add(
        OnboardingWeeklyGoalSelected(weeklyGoal: selectedGoal!),
      );
    }
  }
}
