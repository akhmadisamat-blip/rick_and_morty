import 'package:flutter/material.dart';

class PortalPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  PortalPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutBack,
            );

            // Portal "Goo" colors
            const Color portalInner =
                Color(0xFFD5E857); // Lighter yellowish green
            const Color portalOuter = Color(0xFF97CE4C); // Classic Rick Green

            return Stack(
              alignment: Alignment.center,
              children: [
                // The Spinning Green Portal Background
                RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(curvedAnimation),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 3.0)
                        .animate(curvedAnimation),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.transparent,
                            portalInner.withOpacity(0.8),
                            portalOuter,
                            portalOuter.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.4, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                // The Page emerging from the portal
                RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(curvedAnimation),
                  child: ScaleTransition(
                    scale: curvedAnimation,
                    child: child,
                  ),
                ),
              ],
            );
          },
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          opaque:
              false, // Allows seeing the previous route during transition if needed
          barrierColor: Colors.black.withOpacity(0.5),
        );
}
