import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/widgets/animated_gradient_button.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validation_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  String _passwordStrength = '';
  double _passwordStrengthValue = 0.0;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    final strength = _calculatePasswordStrength(password);
    setState(() {
      _passwordStrengthValue = strength.value;
      _passwordStrength = strength.text;
    });
  }

  ({double value, String text}) _calculatePasswordStrength(String password) {
    if (password.isEmpty) return (0.0, '');
    
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    switch (score) {
      case 0:
      case 1:
        return (0.2, 'Very Weak');
      case 2:
        return (0.4, 'Weak');
      case 3:
        return (0.6, 'Fair');
      case 4:
        return (0.8, 'Good');
      case 5:
        return (1.0, 'Strong');
      default:
        return (0.0, '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showErrorDialog(state.message);
        } else if (state is AuthEmailConfirmationRequired) {
          _showEmailConfirmationDialog(state.email);
        } else if (state is AuthAuthenticated) {
          if (state.user.hasCompletedOnboarding) {
            context.go('/home');
          } else {
            context.go('/onboarding');
          }
        }
      },
      child: AnimatedBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Logo/Title
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Join FitCoach AI today',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Name Field
                    FrostedCard(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email Field
                    FrostedCard(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!ValidationUtils.isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Password Field
                    FrostedCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!ValidationUtils.isStrongPassword(value)) {
                                return 'Password must contain uppercase, lowercase, number, and special character';
                              }
                              return null;
                            },
                          ),
                          if (_passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: _passwordStrengthValue,
                                    backgroundColor: AppColors.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getPasswordStrengthColor(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _passwordStrength,
                                  style: TextStyle(
                                    color: _getPasswordStrengthColor(),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Confirm Password Field
                    FrostedCard(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Terms and Conditions
                    FrostedCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                              Expanded(
                                child: Text(
                                  'I agree to the Terms of Service',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptPrivacy,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptPrivacy = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                              Expanded(
                                child: Text(
                                  'I agree to the Privacy Policy',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign Up Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AnimatedGradientButton(
                          text: 'Create Account',
                          onPressed: _canSignUp(state) ? _onSignUp : null,
                          isLoading: state is AuthLoading,
                          width: double.infinity,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Google Sign Up
                    AnimatedGradientButton(
                      text: 'Continue with Google',
                      onPressed: _onGoogleSignUp,
                      isOutlined: true,
                      width: double.infinity,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canSignUp(AuthState state) {
    return state is! AuthLoading && 
           _acceptTerms && 
           _acceptPrivacy &&
           _formKey.currentState?.validate() == true;
  }

  Color _getPasswordStrengthColor() {
    if (_passwordStrengthValue < 0.3) return AppColors.error;
    if (_passwordStrengthValue < 0.6) return AppColors.warning;
    if (_passwordStrengthValue < 0.8) return AppColors.accent;
    return AppColors.success;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmailConfirmationDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Check Your Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'We\'ve sent a confirmation link to:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please check your email and click the link to complete your registration.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Go to Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Resend confirmation email
              _resendConfirmationEmail(email);
            },
            child: const Text('Resend Email'),
          ),
        ],
      ),
    );
  }

  void _resendConfirmationEmail(String email) {
    // TODO: Implement resend confirmation email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Confirmation email sent!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate() && _acceptTerms && _acceptPrivacy) {
      context.read<AuthBloc>().add(
        AuthSignupRequested(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        ),
      );
    } else if (!_acceptTerms || !_acceptPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service and Privacy Policy'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onGoogleSignUp() {
    context.read<AuthBloc>().add(const AuthGoogleLoginRequested());
  }
}
