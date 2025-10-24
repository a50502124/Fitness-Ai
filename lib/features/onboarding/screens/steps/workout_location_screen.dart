import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/frosted_card.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/theme/app_colors.dart';

class WorkoutLocationScreen extends StatefulWidget {
  const WorkoutLocationScreen({super.key});

  @override
  State<WorkoutLocationScreen> createState() => _WorkoutLocationScreenState();
}

class _WorkoutLocationScreenState extends State<WorkoutLocationScreen> {
  String? selectedLocation;

  final List<Map<String, dynamic>> _locations = [
    {'id': 'home', 'name': 'Home', 'icon': '🏠', 'description': 'Workout at home'},
    {'id': 'gym', 'name': 'Gym', 'icon': '🏋️', 'description': 'Go to the gym'},
    {'id': 'both', 'name': 'Both', 'icon': '🏠🏋️', 'description': 'Mix of home and gym'},
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
                'Where do you prefer to workout?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ..._locations.map((location) {
                final isSelected = selectedLocation == location['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedLocation = location['id']),
                    child: FrostedCard(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                      border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                      child: Row(
                        children: [
                          Text(location['icon'], style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(location['name'], style: Theme.of(context).textTheme.titleLarge),
                                Text(location['description'], style: Theme.of(context).textTheme.bodyMedium),
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
                onPressed: selectedLocation != null ? _onContinue : null,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (selectedLocation != null) {
      context.read<OnboardingBloc>().add(
        OnboardingWorkoutLocationSelected(workoutLocation: selectedLocation!),
      );
    }
  }
}
