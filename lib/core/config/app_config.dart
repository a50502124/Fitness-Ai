class AppConfig {
  // App Information
  static const String appName = 'FitCoach AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered fitness coaching app';
  
  // API Configuration
  // TODO: Replace with your actual Supabase credentials
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';
  
  // AI Services (Optional for MVP)
  static const String deepSeekApiKey = 'YOUR_DEEPSEEK_API_KEY';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String fatSecretApiKey = 'YOUR_FATSECRET_API_KEY';
  static const String replicateApiKey = 'YOUR_REPLICATE_API_KEY';
  
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
