import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value * 2 - 1, 0),
              end: Alignment(_animation.value * 2, 0),
              colors: [
                Colors.grey[800]!,
                Colors.grey[700]!,
                Colors.grey[600]!,
                Colors.grey[700]!,
                Colors.grey[800]!,
              ],
              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class ClubSkeletonCard extends StatelessWidget {
  const ClubSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[850],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonLoader(
                width: double.infinity,
                height: 20,
                borderRadius: 8,
              ),
              const SizedBox(height: 12),
              SkeletonLoader(
                width: double.infinity,
                height: 16,
                borderRadius: 8,
              ),
              const SizedBox(height: 8),
              SkeletonLoader(
                width: double.infinity,
                height: 14,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainerSkeletonCard extends StatelessWidget {
  const TrainerSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[850],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonLoader(width: 60, height: 60, borderRadius: 30),
            const SizedBox(height: 12),
            SkeletonLoader(width: 80, height: 16, borderRadius: 8),
            const SizedBox(height: 8),
            SkeletonLoader(width: 60, height: 14, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

class MembershipSkeletonContent extends StatelessWidget {
  const MembershipSkeletonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(width: 92, height: 14, borderRadius: 7),
          const SizedBox(height: 12),
          const SkeletonLoader(
            width: double.infinity,
            height: 11,
            borderRadius: 6,
          ),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 112, height: 11, borderRadius: 6),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 86, height: 11, borderRadius: 6),
        ],
      ),
    );
  }
}

class HotOfferSkeletonContent extends StatelessWidget {
  const HotOfferSkeletonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonLoader(
              width: double.infinity,
              height: 14,
              borderRadius: 7,
            ),
            const SizedBox(height: 8),
            const SkeletonLoader(width: 104, height: 14, borderRadius: 7),
          ],
        ),
        const SkeletonLoader(
          width: double.infinity,
          height: 36,
          borderRadius: 8,
        ),
      ],
    );
  }
}
