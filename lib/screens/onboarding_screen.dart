import 'package:flutter/material.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/primary_button.dart';
import '../core/app_theme.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  double _pageOffset = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onb_choose.png",
      "title": "Discover Products",
      "description":
          "Browse a wide range of items and pick what you love to get started. It's quick, easy, and tailored just for you.",
    },
    {
      "image": "assets/images/onb_get.png",
      "title": "Simple Ordering",
      "description":
          "Add items to your cart and checkout seamlessly with our secure payment options.",
    },
    {
      "image": "assets/images/onb_pay.png",
      "title": "Track Your Orders",
      "description":
          "Receive your order with reliable delivery and track every step until it arrives at your door.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _pageOffset = _controller.page!;
      });
    });
  }

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background elements
            Positioned.fill(
              child: CustomPaint(painter: _BackgroundPainter(_pageOffset)),
            ),

            Column(
              children: [
                // Skip Button with animation
                AnimatedOpacity(
                  opacity: _currentPage == onboardingData.length - 1 ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const LoginScreen(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                              transitionDuration: const Duration(
                                milliseconds: 600,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Onboarding Pages
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      // Calculate parallax effect based on page offset
                      double difference = index - _pageOffset;
                      double parallaxValue = difference * 50;

                      return OnboardingContent(
                        image: onboardingData[index]['image']!,
                        title: onboardingData[index]['title']!,
                        description: onboardingData[index]['description']!,
                        parallaxOffset: parallaxValue,
                      );
                    },
                  ),
                ),

                // Indicator Dots with animation
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primary
                              : Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),

                // Next / Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: PrimaryButton(
                    text: _currentPage == onboardingData.length - 1
                        ? "Get Started"
                        : "Next",
                    onPressed: _nextPage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom background painter with animated elements
class _BackgroundPainter extends CustomPainter {
  final double pageOffset;

  _BackgroundPainter(this.pageOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppTheme.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw floating circles that move with page scroll
    for (int i = 0; i < 5; i++) {
      double x = size.width * 0.2 + (i * size.width * 0.15);
      double y = size.height * 0.1 + (i * size.height * 0.1);

      // Animate position based on page offset
      x += pageOffset * 20 * (i % 2 == 0 ? 1 : -1);
      y += pageOffset * 10 * (i % 2 == 0 ? -1 : 1);

      canvas.drawCircle(
        Offset(x, y),
        30 + i * 5,
        paint..color = AppTheme.primary.withOpacity(0.03 + 0.02 * i),
      );
    }

    // Draw gradient overlay at bottom
    final Rect rect = Rect.fromPoints(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height),
    );
    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppTheme.background.withOpacity(0),
        AppTheme.background.withOpacity(0.9),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
