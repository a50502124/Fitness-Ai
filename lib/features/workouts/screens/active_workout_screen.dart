import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/workout_plan.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../core/widgets/animated_gradient_button.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/theme/app_colors.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final WorkoutPlan workout;
  final int? startDay;

  const ActiveWorkoutScreen({
    super.key,
    required this.workout,
    this.startDay,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _currentDayIndex = 0;
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  int _remainingSeconds = 0;
  bool _isResting = false;
  bool _isWorkoutActive = false;
  bool _isWorkoutPaused = false;
  
  List<List<bool>> _completedSets = [];
  DateTime? _workoutStartTime;

  @override
  void initState() {
    super.initState();
    _currentDayIndex = widget.startDay != null ? widget.startDay! - 1 : 0;
    _initializeCompletedSets();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initializeCompletedSets() {
    _completedSets = widget.workout.days.map((day) {
      return List.filled(day.exercises.length, false);
    }).toList();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startWorkout() {
    setState(() {
      _isWorkoutActive = true;
      _workoutStartTime = DateTime.now();
    });
  }

  void _pauseWorkout() {
    setState(() {
      _isWorkoutPaused = !_isWorkoutPaused;
    });
    
    if (_isWorkoutPaused) {
      _timer.cancel();
    } else {
      _startRestTimer();
    }
  }

  void _startRestTimer() {
    final currentExercise = _getCurrentExercise();
    if (currentExercise != null) {
      final restSeconds = _parseRestTime(currentExercise.rest);
      _remainingSeconds = restSeconds;
      _isResting = true;
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isResting = false;
          });
        }
      });
    }
  }

  void _completeSet() {
    setState(() {
      _completedSets[_currentDayIndex][_currentExerciseIndex] = true;
      _currentSetIndex++;
      
      if (_currentSetIndex >= _getCurrentExercise()!.sets) {
        _currentSetIndex = 0;
        _currentExerciseIndex++;
        
        if (_currentExerciseIndex >= _getCurrentDay().exercises.length) {
          _currentExerciseIndex = 0;
          _currentDayIndex++;
          
          if (_currentDayIndex >= widget.workout.days.length) {
            _completeWorkout();
            return;
          }
        }
      }
      
      _startRestTimer();
    });
  }

  void _completeWorkout() {
    _timer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete! 🎉'),
        content: Text(
          'Great job! You completed ${widget.workout.name} in ${_getWorkoutDuration()}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _getWorkoutDuration() {
    if (_workoutStartTime == null) return '0:00';
    final duration = DateTime.now().difference(_workoutStartTime!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  WorkoutDay _getCurrentDay() {
    return widget.workout.days[_currentDayIndex];
  }

  Exercise? _getCurrentExercise() {
    if (_currentExerciseIndex >= _getCurrentDay().exercises.length) return null;
    return _getCurrentDay().exercises[_currentExerciseIndex];
  }

  int _parseRestTime(String rest) {
    final match = RegExp(r'(\d+)').firstMatch(rest);
    return match != null ? int.parse(match.group(1)!) * 60 : 60;
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = _getCurrentDay();
    final currentExercise = _getCurrentExercise();
    
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (_isWorkoutActive) {
                _showExitDialog();
              } else {
                context.pop();
              }
            },
          ),
          title: Text(
            _isWorkoutActive ? _getWorkoutDuration() : widget.workout.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            if (_isWorkoutActive)
              IconButton(
                icon: Icon(_isWorkoutPaused ? Icons.play_arrow : Icons.pause),
                onPressed: _pauseWorkout,
              ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                if (!_isWorkoutActive) ...[
                  // Pre-workout screen
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FrostedCard(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.fitness_center,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Ready to start?',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${currentDay.name} - ${currentDay.focus}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${currentDay.exercises.length} exercises • ${currentDay.estimatedDuration}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        AnimatedGradientButton(
                          text: 'Start Workout',
                          onPressed: _startWorkout,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Active workout
                  Expanded(
                    child: Column(
                      children: [
                        // Progress indicator
                        FrostedCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Day ${_currentDayIndex + 1} of ${widget.workout.days.length}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: (_currentDayIndex + 1) / widget.workout.days.length,
                                      backgroundColor: AppColors.surfaceVariant,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Exercise ${_currentExerciseIndex + 1} of ${currentDay.exercises.length}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: (_currentExerciseIndex + 1) / currentDay.exercises.length,
                                      backgroundColor: AppColors.surfaceVariant,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Current exercise
                        if (currentExercise != null) ...[
                          FrostedCard(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Text(
                                  currentExercise.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Set ${_currentSetIndex + 1} of ${currentExercise.sets}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentExercise.reps,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentExercise.instructions,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                if (currentExercise.tips.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.lightbulb_outline,
                                          color: AppColors.accent,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            currentExercise.tips,
                                            style: const TextStyle(
                                              color: AppColors.accent,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Rest timer or complete button
                          if (_isResting) ...[
                            FrostedCard(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 48,
                                    color: AppColors.secondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Rest Time',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(_remainingSeconds / 60).floor()}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Next: ${_getCurrentExercise()?.name ?? 'Workout Complete'}',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            AnimatedGradientButton(
                              text: 'Complete Set',
                              onPressed: _completeSet,
                              width: double.infinity,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Workout?'),
        content: const Text('Are you sure you want to exit? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
