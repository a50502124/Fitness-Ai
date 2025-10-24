import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // User Info
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return FrostedCard(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                state.user.name?.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.name ?? 'User',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    state.user.email,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.push('/profile/edit');
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Stats
                Text(
                  'Your Stats',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded && state.profile != null) {
                      final profile = state.profile!;
                      final weight = profile['weight_kg']?.toString() ?? 'N/A';
                      final height = profile['height_cm']?.toDouble() ?? 0.0;
                      final bmi = height > 0 ? (profile['weight_kg']?.toDouble() ?? 0.0) / ((height / 100) * (height / 100)) : 0.0;
                      
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Weight',
                                  '${weight} kg',
                                  'Current',
                                  Icons.monitor_weight,
                                  AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'BMI',
                                  bmi > 0 ? bmi.toStringAsFixed(1) : 'N/A',
                                  _getBMICategory(bmi),
                                  Icons.health_and_safety,
                                  _getBMIColor(bmi),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Activity',
                                  _formatActivityLevel(profile['activity_level'] ?? 'light'),
                                  'Level',
                                  Icons.directions_run,
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Goals',
                                  '${(profile['fitness_goals'] as List?)?.length ?? 0}',
                                  'Active',
                                  Icons.flag,
                                  AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Weight',
                            'N/A',
                            'Not set',
                            Icons.monitor_weight,
                            AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'BMI',
                            'N/A',
                            'Not set',
                            Icons.health_and_safety,
                            AppColors.success,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Settings
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                _buildSettingsItem(
                  'Edit Profile',
                  Icons.person_outline,
                  () {
                    context.push('/profile/edit');
                  },
                ),
                
                _buildSettingsItem(
                  'Goals & Preferences',
                  Icons.flag_outlined,
                  () {
                    // TODO: Goals
                  },
                ),
                
                _buildSettingsItem(
                  'Notifications',
                  Icons.notifications_outlined,
                  () {
                    // TODO: Notifications
                  },
                ),
                
                _buildSettingsItem(
                  'Privacy & Security',
                  Icons.security_outlined,
                  () {
                    // TODO: Privacy
                  },
                ),
                
                _buildSettingsItem(
                  'Help & Support',
                  Icons.help_outline,
                  () {
                    // TODO: Help
                  },
                ),
                
                const Spacer(),
                
                // Logout Button
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthUnauthenticated) {
                      context.go('/login');
                    }
                  },
                  child: FrostedCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: AppColors.error),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Sign Out',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(const AuthLogoutRequested());
                          },
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return FrostedCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FrostedCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return AppColors.warning;
    if (bmi < 25) return AppColors.success;
    if (bmi < 30) return AppColors.warning;
    return AppColors.error;
  }

  String _formatActivityLevel(String level) {
    switch (level) {
      case 'sedentary':
        return 'Sedentary';
      case 'light':
        return 'Light';
      case 'moderate':
        return 'Moderate';
      case 'active':
        return 'Active';
      case 'very_active':
        return 'Very Active';
      default:
        return 'Light';
    }
  }
}
