import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),

      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 38,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 90,
            right: 70,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.40),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutExpo,
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 24 * (1 - value)),
                    child: Transform.scale(
                      scale: 0.9 + (0.1 * value),
                      child: child,
                    ),
                  ),
                );
              },
              child: Center(
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.25),
                        blurRadius: 35,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                      width: 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.asset(
                      'assets/logo/bloomind.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(begin: 18, end: 0),
                builder: (context, value, child) {
                  final opacity = (1 - (value / 18)).clamp(0.0, 1.0);

                  return Transform.translate(
                    offset: Offset(0, value),
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 36),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 26,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.90),
                              borderRadius: BorderRadius.circular(34),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Tu espacio de bienestar',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: const Color(0xFF7ABFA6).withOpacity(0.85),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                SizedBox(
                                  height: 320,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withOpacity(0.34),
                                              Colors.white.withOpacity(0.08),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(90),
                                        ),
                                      ),
                                      Positioned(
                                        top: 42,
                                        left: 48,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.28),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 72,
                                        right: 52,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.30),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(26),
                                        child: Image.asset(
                                          imagePath,
                                          fit: BoxFit.contain,
                                          height: 285,
                                          errorBuilder: (_, __, ___) {
                                            return Icon(
                                              Icons.spa_rounded,
                                              size: 100,
                                              color: theme.colorScheme.primary,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF243447),
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  description,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF5B6B7A),
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}