# FitCoach AI - AI-Powered Fitness App

A beautiful, modern fitness app built with Flutter that combines AI technology with personalized workout and nutrition tracking.

## 🚀 Features

### Core Features (MVP) ✅
- **Elegant Onboarding**: 8-step personalized setup with progress tracking
- **Workout Library**: Pre-made workout plans for all levels with detailed exercises
- **Nutrition Tracking**: Manual food logging with macro tracking and meal planning
- **Progress Dashboard**: Beautiful stats and progress visualization with charts
- **User Profiles**: Complete user management and settings with statistics
- **Authentication**: Secure login with email/password and Google OAuth
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Dark Mode**: Complete dark mode support with theme switching

### AI Features (Post-Launch)
- **AI Coach Chat**: Personalized fitness advice and motivation
- **Smart Food Scanner**: Camera-based food recognition
- **AI Workout Generation**: Personalized workout plans
- **Mirror AI**: Body transformation previews (Premium)

## 🎨 Design System

Built with a minimal, elegant design philosophy:
- **Muted Pastel Gradients**: Soft, calming color palette
- **Modern Typography**: Inter font family for clean readability
- **Frosted Glass Cards**: Subtle transparency effects
- **Smooth Animations**: Delightful micro-interactions
- **Responsive Layout**: Works perfectly on all screen sizes

## 🛠 Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile development
- **BLoC**: State management with flutter_bloc
- **GoRouter**: Declarative routing
- **Supabase**: Backend-as-a-Service

### AI Services
- **DeepSeek API**: AI coach and workout generation
- **Gemini Vision**: Food recognition from photos
- **FatSecret API**: Nutrition database
- **Replicate API**: Body transformation AI

### Design Tools
- **Cursor Pro**: AI-powered code generation
- **Figma**: UI/UX design
- **Lottie**: Smooth animations

## 📱 Screenshots

*Coming soon - beautiful screenshots of the app in action*

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Cursor Pro (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fitcoach-ai.git
   cd fitcoach-ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase** (Quick Setup)
   - Create a new project at [supabase.com](https://supabase.com)
   - Go to **Settings** → **API** and copy:
     - **Project URL**: `https://your-project-id.supabase.co`
     - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - Update `lib/core/config/app_config.dart`:
     ```dart
     static const String supabaseUrl = 'https://your-actual-project-id.supabase.co';
     static const String supabaseAnonKey = 'your-actual-anon-key-here';
     ```

4. **Set up AI APIs** (Optional for MVP)
   - Get DeepSeek API key from [deepseek.com](https://deepseek.com)
   - Get Gemini API key from [ai.google.dev](https://ai.google.dev)
   - Get FatSecret API credentials from [fatsecret.com/api](https://fatsecret.com/api)

5. **Set up Database Tables**
   - Go to your Supabase project dashboard
   - Navigate to **SQL Editor**
   - Run the following SQL commands to create the required tables:

   ```sql
   -- Create users table
   CREATE TABLE users (
     id UUID REFERENCES auth.users(id) PRIMARY KEY,
     email TEXT UNIQUE NOT NULL,
     name TEXT,
     avatar_url TEXT,
     has_completed_onboarding BOOLEAN DEFAULT FALSE,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Enable Row Level Security
   ALTER TABLE users ENABLE ROW LEVEL SECURITY;

   -- Create policies for users table
   CREATE POLICY "Users can view own profile" ON users
     FOR SELECT USING (auth.uid() = id);
   CREATE POLICY "Users can update own profile" ON users
     FOR UPDATE USING (auth.uid() = id);
   CREATE POLICY "Users can insert own profile" ON users
     FOR INSERT WITH CHECK (auth.uid() = id);

   -- Create food_logs table
   CREATE TABLE food_logs (
     id TEXT PRIMARY KEY,
     user_id UUID REFERENCES users(id) ON DELETE CASCADE,
     timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
     meal_type TEXT NOT NULL,
     food_item JSONB NOT NULL,
     quantity DECIMAL NOT NULL,
     notes TEXT DEFAULT '',
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Enable Row Level Security for food_logs
   ALTER TABLE food_logs ENABLE ROW LEVEL SECURITY;

   -- Create policies for food_logs table
   CREATE POLICY "Users can view own food logs" ON food_logs
     FOR SELECT USING (auth.uid() = user_id);
   CREATE POLICY "Users can insert own food logs" ON food_logs
     FOR INSERT WITH CHECK (auth.uid() = user_id);
   CREATE POLICY "Users can update own food logs" ON food_logs
     FOR UPDATE USING (auth.uid() = user_id);
   CREATE POLICY "Users can delete own food logs" ON food_logs
     FOR DELETE USING (auth.uid() = user_id);

   -- Create user_goals table
   CREATE TABLE user_goals (
     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
     user_id UUID REFERENCES users(id) ON DELETE CASCADE,
     daily_calories DECIMAL DEFAULT 2000,
     protein_target DECIMAL DEFAULT 150,
     carb_target DECIMAL DEFAULT 250,
     fat_target DECIMAL DEFAULT 80,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Enable Row Level Security for user_goals
   ALTER TABLE user_goals ENABLE ROW LEVEL SECURITY;

   -- Create policies for user_goals table
   CREATE POLICY "Users can view own goals" ON user_goals
     FOR SELECT USING (auth.uid() = user_id);
   CREATE POLICY "Users can insert own goals" ON user_goals
     FOR INSERT WITH CHECK (auth.uid() = user_id);
   CREATE POLICY "Users can update own goals" ON user_goals
     FOR UPDATE USING (auth.uid() = user_id);
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## ⚡ Quick Reference

### Supabase Setup Checklist
- [ ] Project created at [supabase.com](https://supabase.com)
- [ ] Credentials copied to `lib/core/config/app_config.dart`
- [ ] Database tables created (see SQL above)
- [ ] App runs without errors
- [ ] User can sign up and log in

### Configuration File
```dart
// lib/core/config/app_config.dart
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── theme/           # Design system
│   ├── widgets/         # Reusable components
│   └── router/          # Navigation
├── features/
│   ├── auth/           # Authentication
│   ├── onboarding/     # Onboarding flow
│   ├── home/           # Dashboard
│   ├── workouts/       # Workout features
│   ├── nutrition/      # Nutrition tracking
│   └── profile/        # User profile
├── services/           # API services
└── main.dart          # App entry point
```

## 🎯 Development Roadmap

### Phase 1: MVP (4 weeks) ✅
- [x] Project setup and design system
- [x] Onboarding flow (8 steps) with validation
- [x] Authentication (email + Google) with error handling
- [x] Workout library with detailed exercise tracking
- [x] Nutrition tracking with macro monitoring
- [x] User profile and settings with statistics
- [x] Beautiful UI/UX with animations
- [x] Error handling and user feedback
- [x] Dark mode support
- [x] Code optimization and bug fixes

### Phase 2: AI Features (4 weeks)
- [ ] AI Coach chat integration
- [ ] Food scanner with camera
- [ ] AI workout generation
- [ ] Enhanced nutrition tracking

### Phase 3: Premium Features (4 weeks)
- [ ] Mirror AI body transformation
- [ ] Advanced analytics
- [ ] Premium subscription
- [ ] Social features

## 💰 Cost Breakdown

### Development (Month 1)
- Cursor Pro: $20/month
- Supabase: FREE (up to 50K users)
- Total: $20

### AI Services (Post-Launch)
- DeepSeek API: $5-20/month
- Gemini Vision: FREE (60 requests/min)
- FatSecret API: FREE
- Replicate API: $0.02-0.03 per image
- Total: $5-50/month

### App Store
- Google Play: $25 (one-time)
- Apple Developer: $99/year

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- All the AI service providers
- The open-source community

## 🔧 Troubleshooting

### Common Issues

1. **"Invalid API key" error**
   - Check that you copied the correct anon key from Supabase
   - Make sure there are no extra spaces in the key
   - Verify the key is in `lib/core/config/app_config.dart`

2. **"Project not found" error**
   - Verify the project URL is correct in `app_config.dart`
   - Check that the project is active in Supabase dashboard

3. **Database connection errors**
   - Make sure you created the database tables
   - Check that Row Level Security policies are set up
   - Verify the user is authenticated

4. **Authentication not working**
   - Check Supabase authentication settings
   - Verify redirect URLs are configured
   - Make sure email confirmation is set up properly

### Getting Help

- **Supabase Docs**: [supabase.com/docs](https://supabase.com/docs)
- **Flutter Docs**: [docs.flutter.dev](https://docs.flutter.dev)
- **GitHub Issues**: [Report bugs](https://github.com/yourusername/fitcoach-ai/issues)

## 📞 Support

- Email: support@fitcoachai.com
- Discord: [Join our community](https://discord.gg/fitcoachai)
- GitHub Issues: [Report bugs](https://github.com/yourusername/fitcoach-ai/issues)

---

**Built with ❤️ using Flutter and AI**
