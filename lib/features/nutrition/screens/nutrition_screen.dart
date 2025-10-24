import 'package:flutter/material.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/theme/app_colors.dart';
import 'add_food_screen.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

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
                  'Nutrition',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Track your daily nutrition',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Daily Summary
                FrostedCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMacroCard(
                              'Calories',
                              '1,850',
                              '2,200',
                              AppColors.primary,
                              Icons.local_fire_department,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMacroCard(
                              'Protein',
                              '85g',
                              '120g',
                              AppColors.secondary,
                              Icons.fitness_center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMacroCard(
                              'Carbs',
                              '180g',
                              '250g',
                              AppColors.accent,
                              Icons.grain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMacroCard(
                              'Fat',
                              '65g',
                              '80g',
                              AppColors.warning,
                              Icons.opacity,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddFoodScreen(
                                mealType: 'Breakfast',
                                date: DateTime.now(),
                              ),
                            ),
                          );
                        },
                        child: _buildActionCard(
                          'Add Food',
                          Icons.add_circle_outline,
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Food scanner coming soon!')),
                          );
                        },
                        child: _buildActionCard(
                          'Scan Food',
                          Icons.camera_alt_outlined,
                          AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Water tracking coming soon!')),
                          );
                        },
                        child: _buildActionCard(
                          'Water',
                          Icons.water_drop_outlined,
                          AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Meal plans coming soon!')),
                          );
                        },
                        child: _buildActionCard(
                          'Meal Plans',
                          Icons.restaurant_menu,
                          AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Recent Meals
                Text(
                  'Recent Meals',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Expanded(
                  child: ListView(
                    children: [
                      _buildMealItem('Breakfast', 'Oatmeal with berries', '320 cal'),
                      _buildMealItem('Lunch', 'Grilled chicken salad', '450 cal'),
                      _buildMealItem('Snack', 'Greek yogurt', '150 cal'),
                      _buildMealItem('Dinner', 'Salmon with vegetables', '380 cal'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroCard(
    String name,
    String current,
    String target,
    Color color,
    IconData icon,
  ) {
    final currentValue = double.tryParse(current.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    final targetValue = double.tryParse(target.replaceAll(RegExp(r'[^\d.]'), '')) ?? 1;
    final progress = (currentValue / targetValue).clamp(0.0, 1.0);
    
    return FrostedCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$current / $target',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
  ) {
    return FrostedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(String meal, String food, String calories) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FrostedCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    food,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              calories,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
