import 'package:bloomind/features/onboarding/data/onboarding_local_service.dart';
import 'package:bloomind/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';

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

    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF7ABFA6)
            : const Color(0xFFD7DEE7),
        borderRadius: BorderRadius.circular(20),
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
    final current = _pages[_currentPage];
    final bool isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
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
                gradientColors:
                (page['gradientColors'] as List<Color>),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _currentPage > 0 ? 1 : 0,
                    child: TextButton(
                      onPressed: _currentPage > 0
                          ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                          : null,
                      child: const Text('Atrás'),
                    ),
                  ),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text('Omitir'),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (index) => _buildIndicator(index == _currentPage),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF7ABFA6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          isLastPage ? 'Comenzar' : 'Siguiente',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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