import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double parallaxOffset;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.parallaxOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with parallax effect
          Transform.translate(
            offset: Offset(parallaxOffset, 0),
            child: Container(
              height: 250,
              margin: const EdgeInsets.only(bottom: 32),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),

          // Title with fade animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: parallaxOffset.abs() < 10 ? 1 : 0.5,
            child: Transform.translate(
              offset: Offset(parallaxOffset * 0.5, 0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description with fade animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: parallaxOffset.abs() < 10 ? 1 : 0.5,
            child: Transform.translate(
              offset: Offset(parallaxOffset * 0.3, 0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
