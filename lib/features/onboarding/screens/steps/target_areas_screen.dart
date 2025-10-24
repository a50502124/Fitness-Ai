import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/frosted_card.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/theme/app_colors.dart';

class TargetAreasScreen extends StatefulWidget {
  const TargetAreasScreen({super.key});

  @override
  State<TargetAreasScreen> createState() => _TargetAreasScreenState();
}

class _TargetAreasScreenState extends State<TargetAreasScreen> {
  final List<String> _selectedAreas = [];

  final List<Map<String, dynamic>> _targetAreas = [
    {'id': 'chest', 'name': 'Chest', 'emoji': '💪', 'color': AppColors.primary},
    {'id': 'back', 'name': 'Back', 'emoji': '🦾', 'color': AppColors.secondary},
    {'id': 'arms', 'name': 'Arms', 'emoji': '💪', 'color': AppColors.accent},
    {'id': 'legs', 'name': 'Legs', 'emoji': '🦵', 'color': AppColors.primary},
    {'id': 'shoulders', 'name': 'Shoulders', 'emoji': '🤸', 'color': AppColors.secondary},
    {'id': 'core', 'name': 'Core', 'emoji': '🔥', 'color': AppColors.accent},
    {'id': 'full_body', 'name': 'Full Body', 'emoji': '🏋️', 'color': AppColors.primary},
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
                'What areas do you want to focus on?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Select all that apply',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Target Areas Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _targetAreas.length,
                  itemBuilder: (context, index) {
                    final area = _targetAreas[index];
                    final isSelected = _selectedAreas.contains(area['id']);
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedAreas.remove(area['id']);
                          } else {
                            _selectedAreas.add(area['id']);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: FrostedCard(
                          padding: const EdgeInsets.all(16),
                          margin: EdgeInsets.zero,
                          backgroundColor: isSelected 
                              ? (area['color'] as Color).withOpacity(0.1)
                              : null,
                          border: isSelected 
                              ? Border.all(color: area['color'] as Color, width: 2)
                              : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                area['emoji'] as String,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                area['name'] as String,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected 
                                      ? area['color'] as Color
                                      : AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Continue Button
              AnimatedGradientButton(
                text: 'Continue',
                onPressed: _selectedAreas.isNotEmpty ? _onContinue : null,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (_selectedAreas.isNotEmpty) {
      context.read<OnboardingBloc>().add(
        OnboardingTargetAreasSelected(targetAreas: _selectedAreas),
      );
    }
  }
}
