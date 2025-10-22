import 'package:flutter/material.dart';

import '../../routing/app_router.dart';

/*
Navigator.push(
  context,
  animatedRouteTo(
  context,
  const MiNuevaPantalla(),
  curve: Curves.CURVE,
  type: RouteTransitionType.TYPE,
  duration: Duration(milliseconds: XXX),
);
 */

enum RouteTransitionType {
  fadeUp, // Fade + Slide Up (default)
  slideFromRight, // Slide in from right
  slideFromLeft, // Slide in from left
  modalFromBottom, // Slide in from bottom
  pureFade, // Only fade
  scale, // Scale up
  fadeScale, // Fade + Scale
  fadeSlide, // Fade + slight slide
}

Route animatedRouteTo(BuildContext context, String routeName,
    {Map<String, dynamic>? args,
    Duration duration = const Duration(milliseconds: 1000),
    RouteTransitionType type = RouteTransitionType.fadeUp,
    Curve curve = Curves.fastOutSlowIn}) {
  final page = AppRouter.getPageFromRoute(routeName, args: args);
  return PageRouteBuilder(
    settings: RouteSettings(
      name: routeName,
      arguments: args,
    ),
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page!,
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

        case RouteTransitionType.pureFade:
          return FadeTransition(
            opacity: curved,
            child: child,
          );

        case RouteTransitionType.scale:
          return ScaleTransition(scale: curved, child: child);

        case RouteTransitionType.fadeScale:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );

        case RouteTransitionType.fadeSlide:
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );

        case RouteTransitionType.fadeUp:
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
