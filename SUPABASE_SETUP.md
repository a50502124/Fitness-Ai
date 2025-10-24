# Supabase Setup Guide

This guide will help you set up Supabase for the FitCoach AI app.

## 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign up or log in to your account
3. Click "New Project"
4. Choose your organization
5. Enter project details:
   - Name: `fitcoach-ai`
   - Database Password: (choose a strong password)
   - Region: (choose closest to your users)
6. Click "Create new project"

## 2. Get Your Project Credentials

1. In your Supabase dashboard, go to Settings > API
2. Copy the following values:
   - Project URL
   - Project API Key (anon public)

## 3. Configure Environment Variables

1. Open the `.env` file in your project root
2. Replace the placeholder values with your actual Supabase credentials:

```env
# Supabase Configuration
SUPABASE_URL=your_actual_supabase_project_url_here
SUPABASE_ANON_KEY=your_actual_supabase_anon_key_here

# Optional: Other API keys
DEEPSEEK_API_KEY=your_deepseek_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
FATSECRET_API_KEY=your_fatsecret_api_key_here
REPLICATE_API_KEY=your_replicate_api_key_here
```

## 4. Set Up Database Schema

1. In your Supabase dashboard, go to the SQL Editor
2. Copy the contents of `database_schema.sql` from this project
3. Paste it into the SQL Editor
4. Click "Run" to execute the schema

This will create all the necessary tables:
- `users` - User profiles
- `user_profiles` - Detailed user information
- `workouts` - Workout plans
- `workout_sessions` - Completed workout sessions
- `nutrition_logs` - Food logging
- `progress_tracking` - Weight and measurements
- `goals` - User fitness goals

## 5. Configure Authentication

1. In your Supabase dashboard, go to Authentication > Settings
2. Configure the following:

### Site URL
- Set to your app's URL (for web) or deep link (for mobile)
- For development: `http://localhost:3000` (web) or `io.supabase.fitcoachai://login-callback/` (mobile)

### Redirect URLs
Add these URLs to the allowed redirect URLs:
- `http://localhost:3000/**` (for web development)
- `io.supabase.fitcoachai://login-callback/` (for mobile)

### Email Settings
- Configure your email templates for password reset, email confirmation, etc.
- Set up SMTP if you want custom email sending

### OAuth Providers (Optional)
If you want to enable Google sign-in:
1. Go to Authentication > Providers
2. Enable Google provider
3. Add your Google OAuth credentials

## 6. Set Up Row Level Security (RLS)

The database schema includes RLS policies, but you may want to review them:

1. Go to Authentication > Policies
2. Review the policies for each table
3. Ensure they match your security requirements

## 7. Test the Setup

1. Run the Flutter app: `flutter run`
2. Try to sign up with a new account
3. Check if the user appears in the Supabase dashboard under Authentication > Users
4. Check if the user profile is created in the `users` table

## 8. Production Considerations

### Environment Variables
- Never commit your `.env` file to version control
- Use environment variables in production
- Consider using a secrets management service

### Database Backups
- Enable automatic backups in Supabase
- Set up point-in-time recovery

### Monitoring
- Set up monitoring for your Supabase project
- Monitor API usage and performance

### Security
- Regularly review and update RLS policies
- Monitor for suspicious activity
- Keep your Supabase credentials secure

## Troubleshooting

### Common Issues

1. **"Invalid API key" error**
   - Check that your API key is correct
   - Ensure you're using the anon key, not the service role key

2. **"Invalid redirect URL" error**
   - Check your redirect URLs in Supabase settings
   - Ensure the URL matches exactly (including protocol and trailing slash)

3. **Database connection errors**
   - Check that your project URL is correct
   - Ensure your project is not paused

4. **RLS policy errors**
   - Check that RLS policies are properly configured
   - Ensure users are authenticated before accessing data

### Getting Help

- Check the [Supabase Documentation](https://supabase.com/docs)
- Join the [Supabase Discord](https://discord.supabase.com)
- Check the [Flutter Supabase Documentation](https://supabase.com/docs/guides/getting-started/flutter)

## Next Steps

Once Supabase is set up:

1. Test all authentication flows (signup, login, logout)
2. Test data saving (profile updates, workout logging, etc.)
3. Set up proper error handling and user feedback
4. Consider adding more advanced features like real-time subscriptions
5. Set up monitoring and analytics