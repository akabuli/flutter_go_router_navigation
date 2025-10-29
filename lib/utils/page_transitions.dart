import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Creates a slide transition from right to left (like WhatsApp)
CustomTransitionPage slideFromRightTransition({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start from right
      const end = Offset.zero; // End at center
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

/// Creates a slide transition from bottom to top
CustomTransitionPage slideFromBottomTransition({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start from bottom
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

/// Creates a fade transition
CustomTransitionPage fadeTransition({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
