import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/frosted_card.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/theme/app_colors.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen>
    with TickerProviderStateMixin {
  String? selectedGender;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Title - Cal AI Style
                    Text(
                      'What\'s your gender?',
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
                      'This helps us personalize your fitness journey',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
              
            const SizedBox(height: 48),
            
            // Gender Cards - Cal AI Style
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Male and Female Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderCard(
                            'Male',
                            '👨',
                            'male',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderCard(
                            'Female',
                            '👩',
                            'female',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Other option
                    _buildGenderCard(
                      'Other',
                      '🧑',
                      'other',
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
              
            // Skip Button - Cal AI Style
            FadeTransition(
              opacity: _fadeAnimation,
              child: TextButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(const OnboardingSkipped());
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                child: Text(
                  'Skip for now',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Continue Button - Cal AI Style
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContinueButton(),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(
    String title,
    String emoji,
    String value, {
    bool isFullWidth = false,
  }) {
    final isSelected = selectedGender == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
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
    final isEnabled = selectedGender != null;
    
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
    if (selectedGender != null) {
      context.read<OnboardingBloc>().add(
        OnboardingGenderSelected(gender: selectedGender!),
      );
    }
  }
}
