import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // App Information
  static const String appName = 'FitCoach AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered fitness coaching app';
  
  // API Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'YOUR_SUPABASE_URL';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'YOUR_SUPABASE_ANON_KEY';
  
  // AI Services (Optional for MVP)
  static String get deepSeekApiKey => dotenv.env['DEEPSEEK_API_KEY'] ?? 'YOUR_DEEPSEEK_API_KEY';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_GEMINI_API_KEY';
  static String get fatSecretApiKey => dotenv.env['FATSECRET_API_KEY'] ?? 'YOUR_FATSECRET_API_KEY';
  static String get replicateApiKey => dotenv.env['REPLICATE_API_KEY'] ?? 'YOUR_REPLICATE_API_KEY';
  
  // Feature Flags
  static const bool enableAI = false; // Set to true when AI features are ready
  static const bool enableFoodScanner = false;
  static const bool enableMirrorAI = false;
  static const bool enablePremium = false;
  
  // App Store Configuration
  static const String googlePlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.fitcoachai';
  static const String appleAppStoreUrl = 'https://apps.apple.com/app/fitcoach-ai/id123456789';
  
  // Social Media
  static const String websiteUrl = 'https://fitcoachai.com';
  static const String supportEmail = 'support@fitcoachai.com';
  static const String privacyPolicyUrl = 'https://fitcoachai.com/privacy';
  static const String termsOfServiceUrl = 'https://fitcoachai.com/terms';
  
  // Development
  static const bool isDebugMode = true;
  static const bool enableCrashlytics = false;
  static const bool enableAnalytics = false;
}
