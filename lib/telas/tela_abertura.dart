// tela_abertura.dart - Tela de abertura/splash
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/app_state.dart';
import '../l10n/l10n.dart';

class TelaAbertura extends StatefulWidget {
  const TelaAbertura({super.key});

  @override
  State<TelaAbertura> createState() => _TelaAberturaState();
}

class _TelaAberturaState extends State<TelaAbertura>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(seconds: 4);

  late final AnimationController _controller;
  late final Animation<double> _iconScale;
  late final Animation<double> _contentFade;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();

    _iconScale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final navigationDelay = Future<void>.delayed(_animationDuration);
    await navigationDelay;

    if (!mounted || _didNavigate) return;

    final nextRoute = AppState.isLogado ? '/home' : '/login';
    _didNavigate = true;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildAnimatedBackground(),
            _buildAnimatedContent(context),
          ],
        ),
      );

  Widget _buildAnimatedBackground() => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = _controller.value;
          final angle = value * 2 * math.pi;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B7A4B),
                  Color(0xFF045D39),
                  Color(0xFF033021),
                ],
              ),
            ),
            child: Stack(
              children: [
                _floatingIcon(
                  top: 80 + math.sin(angle) * 16,
                  left: 32,
                  icon: Icons.eco,
                  opacity: 0.45 + 0.4 * value,
                  size: 72,
                ),
                _floatingIcon(
                  bottom: 60 + math.cos(angle) * 18,
                  right: 40,
                  icon: Icons.public,
                  opacity: 0.35 + 0.5 * (1 - value),
                  size: 64,
                ),
                _floatingIcon(
                  top: 140 + math.sin(angle / 2) * 24,
                  right: 120,
                  icon: Icons.water_drop,
                  opacity: 0.25 + 0.3 * value,
                  size: 48,
                ),
                _floatingIcon(
                  bottom: 100 + math.cos(angle / 1.5) * 22,
                  left: 80,
                  icon: Icons.local_florist,
                  opacity: 0.3 + 0.2 * (1 - value),
                  size: 54,
                ),
              ],
            ),
          );
        },
      );

  Widget _floatingIcon({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required IconData icon,
    required double opacity,
    required double size,
  }) =>
      Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: Opacity(
          opacity: opacity.clamp(0, 1),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: size,
          ),
        ),
      );

  Widget _buildAnimatedContent(BuildContext context) => SafeArea(
        child: FadeTransition(
          opacity: _contentFade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _iconScale,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0FCF6B),
                        Color(0xFF07A85B),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.travel_explore,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              _buildAnimatedTitle(),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).onboardingSubtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 0.8,
                    ),
              ),
              const SizedBox(height: 60),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => _buildProgressIndicator(
                  context,
                  progress: _controller.value,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildAnimatedTitle() => TweenAnimationBuilder<double>(
        tween: Tween(begin: -1, end: 2),
        duration: _animationDuration,
        builder: (context, value, child) => ShaderMask(
          shaderCallback: (bounds) {
            final width = bounds.width;
            final gradient = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white,
                Colors.white.withOpacity(0.1),
              ],
              stops: [
                (value - 0.2).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.2).clamp(0.0, 1.0),
              ],
            );
            return gradient.createShader(Rect.fromLTWH(0, 0, width, bounds.height));
          },
          child: child,
        ),
        child: const Text(
          'Amazonia Experience',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      );

  Widget _buildProgressIndicator(
    BuildContext context, {
    required double progress,
  }) =>
      Column(
        children: [
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.15),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppState.isLogado
                ? AppLocalizations.of(context).onboardingMessageLogged
                : AppLocalizations.of(context).onboardingMessageGuest,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      );

}
