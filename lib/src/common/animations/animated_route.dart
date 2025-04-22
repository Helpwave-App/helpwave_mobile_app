import 'package:flutter/material.dart';

/*
Navigator.push(
  context,
  animatedRouteTo(
  context,
  const MiNuevaPantalla(),
  curve: Curves.TYPE,
  duration: Duration(milliseconds: 800),
);
 */

enum RouteTransitionType {
  fadeUp, // Default: Fade and slide up
  slideFromRight, // From right to left
  slideFromLeft, // From left to right
  modalFromBottom, // From bottom to top
}

Route animatedRouteTo(Widget page,
    {Duration duration = const Duration(milliseconds: 1000),
    RouteTransitionType type = RouteTransitionType.fadeUp,
    Curve curve = Curves.fastOutSlowIn}) {
  return PageRouteBuilder(
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: curve, reverseCurve: curve);

      switch (type) {
        case RouteTransitionType.slideFromRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        case RouteTransitionType.slideFromLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        case RouteTransitionType.modalFromBottom:
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: curve, reverseCurve: curve)),
            child: child,
          );
        case RouteTransitionType.fadeUp:
        default:
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
      }
    },
  );
}
