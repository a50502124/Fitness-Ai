import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final int particleCount;
  final double particleSpeed;
  final double particleSize;
  final Color? particleColor;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.gradientColors,
    this.particleCount = 20,
    this.particleSpeed = 1.0,
    this.particleSize = 4.0,
    this.particleColor,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _initializeParticles();
    _animationController.repeat();
  }

  void _initializeParticles() {
    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: widget.particleSize + _random.nextDouble() * 2,
        speed: widget.particleSpeed + _random.nextDouble() * 0.5,
        opacity: 0.3 + _random.nextDouble() * 0.4,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = widget.gradientColors ?? 
        (isDark 
            ? AppColors.darkBackgroundGradient.colors
            : AppColors.backgroundGradient.colors);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              animationValue: _animationController.value,
              particleColor: widget.particleColor ?? 
                  (isDark 
                      ? AppColors.primary.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.2)),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  double direction;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  }) : direction = Random().nextDouble() * 2 * pi;

  void update(double deltaTime) {
    x += cos(direction) * speed * deltaTime;
    y += sin(direction) * speed * deltaTime;
    
    // Wrap around screen
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Color particleColor;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.particleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = particle.y * size.height;
      final radius = particle.size;
      final opacity = particle.opacity * (0.5 + 0.5 * sin(animationValue * 2 * pi));

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = particleColor.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = colors ?? 
        (isDark 
            ? AppColors.darkBackgroundGradient.colors
            : AppColors.backgroundGradient.colors);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
