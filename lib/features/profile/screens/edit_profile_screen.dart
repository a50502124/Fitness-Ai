import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/profile_bloc.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_gradient_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedGender = 'male';
  String _selectedActivityLevel = 'light';
  List<String> _selectedFitnessGoals = [];
  List<String> _selectedMedicalConditions = [];

  final List<String> _genders = ['male', 'female', 'other'];
  final List<String> _activityLevels = [
    'sedentary',
    'light',
    'moderate',
    'active',
    'very_active'
  ];
  final List<String> _fitnessGoals = [
    'weight_loss',
    'weight_gain',
    'muscle_gain',
    'endurance',
    'strength',
    'flexibility'
  ];
  final List<String> _medicalConditions = [
    'diabetes',
    'hypertension',
    'heart_disease',
    'asthma',
    'arthritis',
    'back_pain',
    'knee_injury',
    'shoulder_injury',
    'none'
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded && state.profile != null) {
              _populateForm(state.profile!);
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 16),
                  
                  FrostedCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: _genders.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                            suffixText: 'years',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 13 || age > 120) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Physical Information
                  _buildSectionTitle('Physical Information'),
                  const SizedBox(height: 16),
                  
                  FrostedCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _heightController,
                                decoration: const InputDecoration(
                                  labelText: 'Height',
                                  border: OutlineInputBorder(),
                                  suffixText: 'cm',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your height';
                                  }
                                  final height = double.tryParse(value);
                                  if (height == null || height < 100 || height > 250) {
                                    return 'Please enter a valid height';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _weightController,
                                decoration: const InputDecoration(
                                  labelText: 'Weight',
                                  border: OutlineInputBorder(),
                                  suffixText: 'kg',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your weight';
                                  }
                                  final weight = double.tryParse(value);
                                  if (weight == null || weight < 30 || weight > 300) {
                                    return 'Please enter a valid weight';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        DropdownButtonFormField<String>(
                          value: _selectedActivityLevel,
                          decoration: const InputDecoration(
                            labelText: 'Activity Level',
                            border: OutlineInputBorder(),
                          ),
                          items: _activityLevels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(_formatActivityLevel(level)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedActivityLevel = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Fitness Goals
                  _buildSectionTitle('Fitness Goals'),
                  const SizedBox(height: 16),
                  
                  FrostedCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select your fitness goals:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _fitnessGoals.map((goal) {
                            final isSelected = _selectedFitnessGoals.contains(goal);
                            return FilterChip(
                              label: Text(_formatFitnessGoal(goal)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedFitnessGoals.add(goal);
                                  } else {
                                    _selectedFitnessGoals.remove(goal);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Medical Conditions
                  _buildSectionTitle('Medical Conditions'),
                  const SizedBox(height: 16),
                  
                  FrostedCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select any medical conditions:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _medicalConditions.map((condition) {
                            final isSelected = _selectedMedicalConditions.contains(condition);
                            return FilterChip(
                              label: Text(_formatMedicalCondition(condition)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedMedicalConditions.add(condition);
                                  } else {
                                    _selectedMedicalConditions.remove(condition);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  AnimatedGradientButton(
                    onPressed: _saveProfile,
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  void _populateForm(Map<String, dynamic> profile) {
    _nameController.text = profile['name'] ?? '';
    _ageController.text = profile['age']?.toString() ?? '';
    _heightController.text = profile['height_cm']?.toString() ?? '';
    _weightController.text = profile['weight_kg']?.toString() ?? '';
    _selectedGender = profile['gender'] ?? 'male';
    _selectedActivityLevel = profile['activity_level'] ?? 'light';
    _selectedFitnessGoals = List<String>.from(profile['fitness_goals'] ?? []);
    _selectedMedicalConditions = List<String>.from(profile['medical_conditions'] ?? []);
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'age': int.tryParse(_ageController.text),
        'gender': _selectedGender,
        'height_cm': int.tryParse(_heightController.text),
        'weight_kg': double.tryParse(_weightController.text),
        'activity_level': _selectedActivityLevel,
        'fitness_goals': _selectedFitnessGoals,
        'medical_conditions': _selectedMedicalConditions,
      };

      context.read<ProfileBloc>().add(ProfileUpdateRequested(profileData: profileData));
      
      // Show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      context.pop();
    }
  }

  String _formatActivityLevel(String level) {
    switch (level) {
      case 'sedentary':
        return 'Sedentary (little to no exercise)';
      case 'light':
        return 'Light (light exercise 1-3 days/week)';
      case 'moderate':
        return 'Moderate (moderate exercise 3-5 days/week)';
      case 'active':
        return 'Active (heavy exercise 6-7 days/week)';
      case 'very_active':
        return 'Very Active (very heavy exercise, physical job)';
      default:
        return level;
    }
  }

  String _formatFitnessGoal(String goal) {
    switch (goal) {
      case 'weight_loss':
        return 'Weight Loss';
      case 'weight_gain':
        return 'Weight Gain';
      case 'muscle_gain':
        return 'Muscle Gain';
      case 'endurance':
        return 'Endurance';
      case 'strength':
        return 'Strength';
      case 'flexibility':
        return 'Flexibility';
      default:
        return goal;
    }
  }

  String _formatMedicalCondition(String condition) {
    switch (condition) {
      case 'diabetes':
        return 'Diabetes';
      case 'hypertension':
        return 'Hypertension';
      case 'heart_disease':
        return 'Heart Disease';
      case 'asthma':
        return 'Asthma';
      case 'arthritis':
        return 'Arthritis';
      case 'back_pain':
        return 'Back Pain';
      case 'knee_injury':
        return 'Knee Injury';
      case 'shoulder_injury':
        return 'Shoulder Injury';
      case 'none':
        return 'None';
      default:
        return condition;
    }
  }
}