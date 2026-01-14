import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/splash/splash_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/splash/app_logo_animated.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/splash/app_slogan_animated.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;

  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    _logoScaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );
  }

  Future<void> _startAnimationSequence() async {
    await _logoController.forward();
    await _textController.forward();
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogoAnimated(
              fadeAnimation: _logoFadeAnimation,
              scaleAnimation: _logoScaleAnimation,
            ),
            const SizedBox(height: 32),
            AppSloganAnimated(fadeAnimation: _textFadeAnimation),
            const SizedBox(height: 48),
            SplashLoadingIndicator(fadeAnimation: _textFadeAnimation),
          ],
        ),
      ),
    );
  }
}
