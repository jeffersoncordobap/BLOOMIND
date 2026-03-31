import 'package:bloomind/features/onboarding/data/onboarding_local_service.dart';
import 'package:bloomind/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingLocalService _localService = OnboardingLocalService();

  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'imagePath': 'assets/onboarding/welcome.png',
      'title': 'Bienvenido a Bloomind 🌱',
      'description':
      'Tu espacio para cuidar tu bienestar emocional y construir hábitos saludables cada día.',
      'gradientColors': [
        const Color(0xFFE8F6F0),
        const Color(0xFFF6FBF8),
      ],
    },
    {
      'imagePath': 'assets/onboarding/routines.png',
      'title': 'Organiza tus rutinas',
      'description':
      'Crea actividades y visualiza tus rutinas diarias para mantener equilibrio y constancia.',
      'gradientColors': [
        const Color(0xFFEAF2FF),
        const Color(0xFFF7FAFF),
      ],
    },
    {
      'imagePath': 'assets/onboarding/reminders.png',
      'title': 'Recibe recordatorios útiles',
      'description':
      'Activa notificaciones para no olvidar tus actividades importantes y acompañar tu progreso.',
      'gradientColors': [
        const Color(0xFFF3ECFF),
        const Color(0xFFFBF8FF),
      ],
    },
    {
      'imagePath': 'assets/onboarding/calm.png',
      'title': 'Encuentra momentos de calma',
      'description':
      'Accede a meditaciones, audios relajantes y recursos diseñados para ayudarte a sentirte mejor.',
      'gradientColors': [
        const Color(0xFFFFF2E8),
        const Color(0xFFFFFAF5),
      ],
    },
  ];

  Future<void> _finishOnboarding() async {
    HapticFeedback.lightImpact();
    await _localService.setSeenOnboarding();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _finishOnboarding();
      return;
    }

    HapticFeedback.selectionClick();

    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    if (_currentPage == 0) return;

    HapticFeedback.selectionClick();

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildIndicator(bool isActive, bool isSmall) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: isSmall ? 3 : 4),
      width: isActive ? (isSmall ? 20 : 24) : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF7ABFA6)
            : const Color(0xFFD7DEE7),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildTopButton({
    required String label,
    required VoidCallback? onPressed,
    required bool visible,
    required bool isSmall,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: visible ? 1 : 0,
      child: IgnorePointer(
        ignoring: !visible,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.55),
            foregroundColor: const Color(0xFF5D8F7B),
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 12 : 14,
              vertical: isSmall ? 8 : 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isSmall ? 13 : 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;

          final bool isVerySmall = height < 680;
          final bool isSmall = height < 760;

          final double horizontalPadding = width * 0.05;
          final double topSpacing = isVerySmall ? 8 : 10;
          final double pageBottomSpacing = isVerySmall ? 0 : 6;
          final double bottomMargin = isVerySmall ? 8 : 12;
          final double bottomCardPaddingH = isVerySmall ? 16 : 18;
          final double bottomCardPaddingV = isVerySmall ? 12 : 14;
          final double buttonHeight = isVerySmall ? 50 : 56;

          return Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Container(
                  key: ValueKey(_currentPage),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _pages[_currentPage]['gradientColors'] as List<Color>,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    topSpacing,
                    horizontalPadding,
                    0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTopButton(
                            label: 'Atrás',
                            onPressed: _previousPage,
                            visible: _currentPage > 0,
                            isSmall: isSmall,
                          ),
                          _buildTopButton(
                            label: 'Omitir',
                            onPressed: _finishOnboarding,
                            visible: true,
                            isSmall: isSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: isVerySmall ? 6 : 10),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: pageBottomSpacing),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _pages.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (_, index) {
                              final page = _pages[index];
                              return OnboardingPage(
                                imagePath: page['imagePath'] as String,
                                title: page['title'] as String,
                                description: page['description'] as String,
                                gradientColors: page['gradientColors'] as List<Color>,
                              );
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -4),
                        child: Container(
                          margin: EdgeInsets.only(bottom: bottomMargin),
                          padding: EdgeInsets.fromLTRB(
                            bottomCardPaddingH,
                            bottomCardPaddingV,
                            bottomCardPaddingH,
                            isVerySmall ? 14 : 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.94),
                            borderRadius: BorderRadius.circular(isVerySmall ? 24 : 28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: isVerySmall ? 36 : 42,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9E4DD),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              SizedBox(height: isVerySmall ? 10 : 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _pages.length,
                                      (index) => _buildIndicator(
                                    index == _currentPage,
                                    isSmall,
                                  ),
                                ),
                              ),
                              SizedBox(height: isVerySmall ? 12 : 16),
                              SizedBox(
                                width: double.infinity,
                                height: buttonHeight,
                                child: ElevatedButton(
                                  onPressed: _nextPage,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xFF7ABFA6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        isVerySmall ? 16 : 18,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    isLastPage ? 'Empezar ahora ✨' : 'Siguiente',
                                    style: TextStyle(
                                      fontSize: isVerySmall ? 15 : 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}