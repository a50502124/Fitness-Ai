# FitCoach AI - AI-Powered Fitness App

A beautiful, modern fitness app built with Flutter that combines AI technology with personalized workout and nutrition tracking.

## 🚀 Features

### Core Features (MVP)
- **Elegant Onboarding**: 8-step personalized setup
- **Workout Library**: Pre-made workout plans for all levels
- **Nutrition Tracking**: Manual food logging with macro tracking
- **Progress Dashboard**: Beautiful stats and progress visualization
- **User Profiles**: Complete user management and settings

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

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Copy your project URL and anon key
   - Update `lib/main.dart` with your credentials

4. **Set up AI APIs** (Optional for MVP)
   - Get DeepSeek API key from [deepseek.com](https://deepseek.com)
   - Get Gemini API key from [ai.google.dev](https://ai.google.dev)
   - Get FatSecret API credentials from [fatsecret.com/api](https://fatsecret.com/api)

5. **Run the app**
   ```bash
   flutter run
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
- [x] Onboarding flow (8 steps)
- [x] Authentication (email + Google)
- [x] Basic workout library
- [x] Manual nutrition tracking
- [x] User profile and settings
- [x] Beautiful UI/UX

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

## 📞 Support

- Email: support@fitcoachai.com
- Discord: [Join our community](https://discord.gg/fitcoachai)
- GitHub Issues: [Report bugs](https://github.com/yourusername/fitcoach-ai/issues)

---

**Built with ❤️ using Flutter and AI**
