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
                  'What areas do you want to focus on?',
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
                  'Select all that apply',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
              
            const SizedBox(height: 48),
            
            // Target Areas Grid - Cal AI Style
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _targetAreas.length,
                itemBuilder: (context, index) {
                  final area = _targetAreas[index];
                  final isSelected = _selectedAreas.contains(area['id']);
                  
                  return _buildTargetAreaCard(area, isSelected);
                },
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

  Widget _buildTargetAreaCard(Map<String, dynamic> area, bool isSelected) {
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
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected 
                ? (area['color'] as Color).withOpacity(0.05)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? area['color'] as Color
                  : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: (area['color'] as Color).withOpacity(0.1),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                area['emoji'] as String,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 12),
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
              if (isSelected) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.check_circle_rounded,
                  color: area['color'] as Color,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _selectedAreas.isNotEmpty;
    
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
    if (_selectedAreas.isNotEmpty) {
      context.read<OnboardingBloc>().add(
        OnboardingTargetAreasSelected(targetAreas: _selectedAreas),
      );
    }
  }
}
