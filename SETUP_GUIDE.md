# FitCoach AI - Setup Guide

## 🚀 Quick Start (5 minutes)

### 1. Prerequisites
- Flutter SDK 3.0.0+ installed
- Android Studio / VS Code with Flutter extension
- Cursor Pro (recommended for AI assistance)

### 2. Clone and Setup
```bash
# Navigate to your project directory
cd "C:\Users\User\Desktop\Fit Ai"

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 3. Configure Supabase (Required)
1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Go to Settings > API
4. Copy your Project URL and anon key
5. Update `lib/main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL', // Replace with your URL
     anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your key
   );
   ```

### 4. Database Setup
Run this SQL in your Supabase SQL editor:

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  avatar_url TEXT,
  has_completed_onboarding BOOLEAN DEFAULT FALSE,
  gender TEXT,
  target_areas TEXT[],
  fitness_level TEXT,
  workout_location TEXT,
  days_per_week INTEGER,
  experience_level TEXT,
  weekly_goal TEXT,
  height DECIMAL,
  weight DECIMAL,
  unit_system TEXT DEFAULT 'metric',
  bmi DECIMAL,
  bmi_category TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User goals table
CREATE TABLE user_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  daily_calories DECIMAL,
  protein_target DECIMAL,
  carb_target DECIMAL,
  fat_target DECIMAL,
  workout_days_per_week INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Food logs table
CREATE TABLE food_logs (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
  meal_type TEXT NOT NULL,
  food_item JSONB NOT NULL,
  quantity DECIMAL NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Workout logs table
CREATE TABLE workout_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  workout_plan_id TEXT NOT NULL,
  workout_day INTEGER NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  duration_minutes INTEGER,
  notes TEXT
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE food_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view own data" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own data" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own data" ON users FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own goals" ON user_goals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own goals" ON user_goals FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own goals" ON user_goals FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own food logs" ON food_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own food logs" ON food_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own food logs" ON food_logs FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own food logs" ON food_logs FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own workout logs" ON workout_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own workout logs" ON workout_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
```

### 5. Test the App
1. Run `flutter run` in your terminal
2. The app should launch on your device/emulator
3. Try the onboarding flow
4. Test authentication (signup/login)
5. Browse workout library
6. Try adding food to nutrition

## 🎯 What You Have Now

✅ **Complete MVP App** - Ready for users  
✅ **Beautiful UI** - Professional design system  
✅ **Authentication** - Email + Google OAuth ready  
✅ **Onboarding** - 8-step personalized setup  
✅ **Workouts** - Library, detail, and active workout screens  
✅ **Nutrition** - Food logging with search and tracking  
✅ **Profile** - User management and settings  
✅ **Database** - Supabase backend ready  

## 🚀 Next Steps (Optional)

### Phase 2: AI Features (Month 2)
1. **Get AI API Keys**:
   - DeepSeek API (free): [deepseek.com](https://deepseek.com)
   - Gemini Vision (free): [ai.google.dev](https://ai.google.dev)
   - FatSecret API (free): [fatsecret.com/api](https://fatsecret.com/api)
   - Replicate API: [replicate.com](https://replicate.com)

2. **Enable AI Features**:
   - Update `lib/core/config/app_config.dart`
   - Set `enableAI = true`
   - Add API keys

### Phase 3: App Store Launch
1. **Create App Icons** (1024x1024)
2. **Take Screenshots** (6-8 per platform)
3. **Write App Description**
4. **Submit to Stores**:
   - Google Play Console ($25)
   - Apple App Store ($99/year)

## 💰 Cost Summary

### Month 1 (MVP)
- **Development**: $20 (Cursor Pro)
- **Backend**: FREE (Supabase)
- **Total**: $20

### Month 2+ (With AI)
- **Development**: $20 (Cursor Pro)
- **AI Services**: $5-50/month
- **App Store**: $25-99
- **Total**: $50-170/month

## 🐛 Troubleshooting

### Common Issues

**1. Flutter not found**
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

**2. Supabase connection error**
- Check your URL and API key
- Ensure database tables are created
- Check RLS policies

**3. Build errors**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**4. Authentication not working**
- Check Supabase auth settings
- Enable email auth in Supabase dashboard
- Check redirect URLs

## 📞 Support

- **Documentation**: Check this README
- **Issues**: Create GitHub issue
- **Email**: support@fitcoachai.com

## 🎉 You're Ready!

Your FitCoach AI app is now ready for development and testing! 

**Next**: Start testing, customize the content, and prepare for launch! 🚀
