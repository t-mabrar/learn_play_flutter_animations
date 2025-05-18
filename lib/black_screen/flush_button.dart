import 'package:flutter/material.dart';

class FlushButton extends StatefulWidget {
  const FlushButton({super.key});

  @override
  State<FlushButton> createState() => _FlushButtonState();
}

class _FlushButtonState extends State<FlushButton>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;

  late AnimationController _controller;
  late Animation<double> _slideAnimation; // Renamed for clarity
  late Animation<double> _overlaySlideAnimation; // Renamed for clarity

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ), // Significantly shorter duration
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 27.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    ); // Smoother easing

    _overlaySlideAnimation = Tween<double>(
      begin: 23.0, // Start from the final position
      end: 0.0, // Move to the top
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    ); // Smoother easing

    _controller.addStatusListener((status) {
      if (!mounted) return;
      if (status == AnimationStatus.completed) {
        setState(() {
          isHovered = true;
        });
      } else {
        setState(() {
          isHovered = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 250.0,
      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  // Changed to Positioned for simpler control
                  top: _slideAnimation.value,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const SizedBox.expand(),
                  ),
                );
              },
            ),
            const Center(
              child: Text(
                "HOVER ME!",
                style: TextStyle(
                  letterSpacing: 1.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            if (isHovered)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    // Changed to Positioned for simpler control
                    top: _overlaySlideAnimation.value, // Animate from bottom up
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),
            if (isHovered)
              const Center(
                child: Text(
                  "HOVER ME!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 2.25,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
