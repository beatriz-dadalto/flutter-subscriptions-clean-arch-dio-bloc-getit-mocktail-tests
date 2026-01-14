import 'package:flutter/material.dart';

class SplashLoadingIndicator extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashLoadingIndicator({
    super.key,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: fadeAnimation,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            colorScheme.primary.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
