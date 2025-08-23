import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final bool? shadow;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    required this.width,
    required this.height,
    this.shadow,
    this.borderRadius,
    this.padding,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}
class _AnimatedButtonState extends State<AnimatedButton> {
    double scale = 1.0;
    
    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTapDown: (_) => setState(() => scale = 0.9),
        onTapUp: (_) => setState(() => scale = 1.0),
        onTapCancel: () => setState(() => scale = 1.0),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
              boxShadow: widget.shadow == true
                  ? [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      );
    }
}