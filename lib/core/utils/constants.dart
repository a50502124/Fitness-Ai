class AppConstants {
  // App Information
  static const String appName = 'FitCoach AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered fitness coaching app';
  
  // API Endpoints
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // AI Services
  static const String deepSeekApiUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String fatSecretApiUrl = 'https://platform.fatsecret.com/rest/server.api';
  static const String replicateApiUrl = 'https://api.replicate.com/v1/predictions';
  
  // Feature Flags
  static const bool enableAI = false;
  static const bool enableFoodScanner = false;
  static const bool enableMirrorAI = false;
  static const bool enablePremium = false;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
  static const double pillBorderRadius = 50.0;
  
  static const double defaultElevation = 4.0;
  static const double smallElevation = 2.0;
  static const double largeElevation = 8.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Workout Constants
  static const int maxWorkoutDays = 7;
  static const int minWorkoutDays = 1;
  static const int defaultWorkoutDays = 3;
  
  static const int maxSets = 10;
  static const int minSets = 1;
  static const int defaultSets = 3;
  
  static const int maxReps = 100;
  static const int minReps = 1;
  static const int defaultReps = 10;
  
  static const int maxRestSeconds = 300; // 5 minutes
  static const int minRestSeconds = 15;
  static const int defaultRestSeconds = 60;
  
  // Nutrition Constants
  static const double maxCalories = 10000.0;
  static const double minCalories = 0.0;
  static const double defaultCalories = 2000.0;
  
  static const double maxProtein = 500.0;
  static const double minProtein = 0.0;
  static const double defaultProtein = 150.0;
  
  static const double maxCarbs = 1000.0;
  static const double minCarbs = 0.0;
  static const double defaultCarbs = 250.0;
  
  static const double maxFat = 300.0;
  static const double minFat = 0.0;
  static const double defaultFat = 80.0;
  
  static const double maxQuantity = 1000.0;
  static const double minQuantity = 0.1;
  static const double defaultQuantity = 1.0;
  
  // User Constants
  static const int minAge = 13;
  static const int maxAge = 120;
  static const int defaultAge = 25;
  
  static const double minHeight = 100.0; // cm
  static const double maxHeight = 250.0; // cm
  static const double defaultHeight = 170.0; // cm
  
  static const double minWeight = 20.0; // kg
  static const double maxWeight = 500.0; // kg
  static const double defaultWeight = 70.0; // kg
  
  static const double minBMI = 10.0;
  static const double maxBMI = 100.0;
  
  // File Constants
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];
  
  // Cache Constants
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;
  
  // Network Constants
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Storage Keys
  static const String userPreferencesKey = 'user_preferences';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications';
  
  // Meal Types
  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];
  
  // Workout Levels
  static const List<String> workoutLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  
  // Target Areas
  static const List<String> targetAreas = [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Shoulders',
    'Core',
    'Full Body',
  ];
  
  // Workout Locations
  static const List<String> workoutLocations = [
    'Home',
    'Gym',
    'Both',
  ];
  
  // Weekly Goals
  static const List<String> weeklyGoals = [
    'Lose Weight',
    'Gain Weight',
    'Maintain',
  ];
  
  // Unit Systems
  static const List<String> unitSystems = [
    'Metric',
    'Imperial',
  ];
  
  // Gender Options
  static const List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];
  
  // Experience Levels
  static const List<String> experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
}
