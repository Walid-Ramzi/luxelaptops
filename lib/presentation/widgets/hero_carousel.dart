import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/layout/responsive.dart';
import 'package:luxelaptops/data/mock/hero_slides.dart';
import 'package:luxelaptops/presentation/widgets/asset_image_box.dart';

/// Full-width hero carousel — background photos, overlay copy, line indicators.
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({
    super.key,
    this.height = 420,
    this.onExplore,
    this.onViewAll,
    this.exploreLabel = 'Explore Model',
    this.viewAllLabel = 'View All Models',
  });

  final double height;
  final VoidCallback? onExplore;
  final VoidCallback? onViewAll;
  final String exploreLabel;
  final String viewAllLabel;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final _pageController = PageController();
  Timer? _autoTimer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _autoTimer = Timer.periodic(const Duration(seconds: 6), (_) => _next());
  }

  void _next() {
    if (!mounted) return;
    final next = (_index + 1) % heroSlides.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goTo(int i) {
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        //child: SizedBox(
        //height: _responsiveHeight(context),
        //height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _index = i),
              itemCount: heroSlides.length,
              itemBuilder: (context, index) => _SlideView(
                slide: heroSlides[index],
                exploreLabel: widget.exploreLabel,
                viewAllLabel: widget.viewAllLabel,
                onExplore: widget.onExplore,
                onViewAll: widget.onViewAll,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _LineIndicators(
                count: heroSlides.length,
                index: _index,
                onTap: _goTo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({
    required this.slide,
    required this.exploreLabel,
    required this.viewAllLabel,
    this.onExplore,
    this.onViewAll,
  });

  final HeroSlide slide;
  final String exploreLabel;
  final String viewAllLabel;
  final VoidCallback? onExplore;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AssetImageBox(asset: slide.imageAsset, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withValues(alpha: 0.82),
                Colors.black.withValues(alpha: 0.45),
                Colors.black.withValues(alpha: 0.15),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 56),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  // minWidth: AppBreakpoints.minContentWidth
                  maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slide.overline,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontFamily: "inter",
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    slide.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          fontSize: 45,
                          fontFamily: "inter",
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsetsGeometry.only(right: 40),
                    child: Text(
                      slide.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "inter",
                        height: 1.55,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      _HeroCta(
                          label: exploreLabel, filled: true, onTap: onExplore),
                      _HeroCta(
                          label: viewAllLabel, filled: false, onTap: onViewAll),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCta extends StatefulWidget {
  const _HeroCta({required this.label, required this.filled, this.onTap});

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  State<_HeroCta> createState() => _HeroCtaState();
}

class _HeroCtaState extends State<_HeroCta> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: widget.filled
                ? (_hovered ? AppColors.secondary : AppColors.primary)
                : (_hovered
                    ? AppColors.cardElevated
                    : Colors.black.withValues(alpha: 0.35)),
            border: widget.filled ? null : Border.all(color: AppColors.border),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: "inter",
              letterSpacing: 1.1,
              color:
                  widget.filled ? AppColors.background : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _LineIndicators extends StatelessWidget {
  const _LineIndicators({
    required this.count,
    required this.index,
    required this.onTap,
  });

  final int count;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final active = i == index;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: active ? 70 : 50,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: active
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.35),
                boxShadow: active
                    ? AppColors.neonGlow(AppColors.primary, blur: 6)
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
