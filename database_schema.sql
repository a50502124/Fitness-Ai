-- FitCoach AI Database Schema
-- Run this in your Supabase SQL editor to set up the database tables

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Create users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    name TEXT,
    avatar_url TEXT,
    has_completed_onboarding BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user profiles table for additional user data
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID REFERENCES public.users(id) ON DELETE CASCADE PRIMARY KEY,
    age INTEGER,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    height_cm INTEGER,
    weight_kg DECIMAL(5,2),
    activity_level TEXT CHECK (activity_level IN ('sedentary', 'light', 'moderate', 'active', 'very_active')),
    fitness_goals TEXT[],
    medical_conditions TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create workouts table
CREATE TABLE IF NOT EXISTS public.workouts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    duration_minutes INTEGER,
    difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
    workout_type TEXT CHECK (workout_type IN ('strength', 'cardio', 'flexibility', 'mixed')),
    exercises JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create workout_sessions table for tracking completed workouts
CREATE TABLE IF NOT EXISTS public.workout_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    duration_minutes INTEGER,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5)
);

-- Create nutrition_logs table
CREATE TABLE IF NOT EXISTS public.nutrition_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    food_name TEXT NOT NULL,
    calories INTEGER,
    protein_g DECIMAL(5,2),
    carbs_g DECIMAL(5,2),
    fat_g DECIMAL(5,2),
    fiber_g DECIMAL(5,2),
    sugar_g DECIMAL(5,2),
    sodium_mg DECIMAL(8,2),
    quantity DECIMAL(8,2),
    unit TEXT,
    meal_type TEXT CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create progress_tracking table
CREATE TABLE IF NOT EXISTS public.progress_tracking (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    weight_kg DECIMAL(5,2),
    body_fat_percentage DECIMAL(4,2),
    muscle_mass_kg DECIMAL(5,2),
    measurements JSONB, -- Store body measurements as JSON
    notes TEXT,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create goals table
CREATE TABLE IF NOT EXISTS public.goals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    goal_type TEXT NOT NULL CHECK (goal_type IN ('weight_loss', 'weight_gain', 'muscle_gain', 'endurance', 'strength', 'flexibility')),
    target_value DECIMAL(8,2),
    current_value DECIMAL(8,2),
    unit TEXT,
    target_date DATE,
    is_achieved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nutrition_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can only access their own data
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- User profiles policies
CREATE POLICY "Users can view own profile data" ON public.user_profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile data" ON public.user_profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile data" ON public.user_profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Workouts policies
CREATE POLICY "Users can view own workouts" ON public.workouts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workouts" ON public.workouts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workouts" ON public.workouts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workouts" ON public.workouts
    FOR DELETE USING (auth.uid() = user_id);

-- Workout sessions policies
CREATE POLICY "Users can view own workout sessions" ON public.workout_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workout sessions" ON public.workout_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workout sessions" ON public.workout_sessions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workout sessions" ON public.workout_sessions
    FOR DELETE USING (auth.uid() = user_id);

-- Nutrition logs policies
CREATE POLICY "Users can view own nutrition logs" ON public.nutrition_logs
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own nutrition logs" ON public.nutrition_logs
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own nutrition logs" ON public.nutrition_logs
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own nutrition logs" ON public.nutrition_logs
    FOR DELETE USING (auth.uid() = user_id);

-- Progress tracking policies
CREATE POLICY "Users can view own progress" ON public.progress_tracking
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" ON public.progress_tracking
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" ON public.progress_tracking
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own progress" ON public.progress_tracking
    FOR DELETE USING (auth.uid() = user_id);

-- Goals policies
CREATE POLICY "Users can view own goals" ON public.goals
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own goals" ON public.goals
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own goals" ON public.goals
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own goals" ON public.goals
    FOR DELETE USING (auth.uid() = user_id);

-- Create functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at BEFORE UPDATE ON public.workouts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_goals_updated_at BEFORE UPDATE ON public.goals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();