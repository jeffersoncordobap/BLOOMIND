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

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        final bool isVerySmall = maxHeight < 620;
        final bool isSmall = maxHeight < 700;

        final double horizontalPadding = isVerySmall ? 18 : 20;
        final double verticalPadding = isVerySmall ? 18 : 24;

        final double topSpacing = isVerySmall ? 90 : 110;
        final double cardRadius = isVerySmall ? 28 : 34;

        final double imageBoxHeight = isVerySmall
            ? maxHeight * 0.28
            : isSmall
            ? maxHeight * 0.32
            : maxHeight * 0.36;

        final double imageHeight = isVerySmall
            ? 170
            : isSmall
            ? 200
            : 230;

        final double titleSpacing = isVerySmall ? 8 : 10;
        final double descriptionSpacing = isVerySmall ? 10 : 14;

        final double titleFontSize = isVerySmall
            ? 18
            : isSmall
            ? 21
            : 24;

        final double descFontSize = isVerySmall
            ? 14
            : isSmall
            ? 15
            : 16;

        final double badgeFontSize = isVerySmall ? 13 : 14;

        final double logoTop = isVerySmall ? 2 : 6;
        final double logoSize = isVerySmall ? 125 : 140;

        return Stack(
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
              top: logoTop,
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
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isVerySmall ? 28 : 32),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.04),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.20),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.10),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/logo/bloomind.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 8,
              ),
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
                    SizedBox(height: topSpacing),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: maxWidth > 500 ? 440 : double.infinity,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isVerySmall ? 18 : 24,
                            vertical: verticalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.90),
                            borderRadius: BorderRadius.circular(cardRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tu espacio de bienestar',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontSize: badgeFontSize,
                                  color: const Color(0xFF7ABFA6).withOpacity(0.85),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(height: isVerySmall ? 10 : 14),
                              SizedBox(
                                height: imageBoxHeight.clamp(150.0, 240.0),
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: isVerySmall ? 150 : 190,
                                      height: isVerySmall ? 150 : 190,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.34),
                                            Colors.white.withOpacity(0.08),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(70),
                                      ),
                                    ),
                                    Positioned(
                                      top: isVerySmall ? 26 : 34,
                                      left: isVerySmall ? 36 : 48,
                                      child: Container(
                                        width: isVerySmall ? 8 : 10,
                                        height: isVerySmall ? 8 : 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.28),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: isVerySmall ? 42 : 56,
                                      right: isVerySmall ? 36 : 48,
                                      child: Container(
                                        width: isVerySmall ? 5 : 7,
                                        height: isVerySmall ? 5 : 7,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.30),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.contain,
                                        height: imageHeight,
                                        errorBuilder: (_, __, ___) {
                                          return Icon(
                                            Icons.spa_rounded,
                                            size: isVerySmall ? 72 : 90,
                                            color: theme.colorScheme.primary,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: titleSpacing),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF243447),
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: descriptionSpacing),
                              Text(
                                description,
                                textAlign: TextAlign.center,
                                maxLines: isVerySmall ? 3 : 4,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: descFontSize,
                                  color: const Color(0xFF5B6B7A),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}