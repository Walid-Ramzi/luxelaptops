import 'package:luxelaptops/core/constants/app_assets.dart';

class HeroSlide {
  const HeroSlide({
    required this.overline,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String overline;
  final String title;
  final String subtitle;
  final String imageAsset;
}

const List<HeroSlide> heroSlides = [
  HeroSlide(
    overline: 'NEW ARRIVAL / SERIES X',
    title: 'Find Your Perfect Laptop',
    subtitle:
        'Precision-engineered hardware for creators and engineers. '
        'Discover flagship machines built for performance.',
    imageAsset: AppAssets.heroWorkstation,
  ),
  HeroSlide(
    overline: 'GAMING ELITE / RTX 5090',
    title: 'Dominate Every Frame',
    subtitle:
        'Desktop-class GPUs, high-refresh mini-LED panels, and advanced cooling '
        'for uncompromising play.',
    imageAsset: AppAssets.heroGaming,
  ),
  HeroSlide(
    overline: 'ULTRABOOK / PORTABLE POWER',
    title: 'Thin. Light. Unstoppable.',
    subtitle:
        'Premium materials, all-day battery, and studio-grade displays in a '
        'travel-ready chassis.',
    imageAsset: AppAssets.heroUltrabook,
  ),
  HeroSlide(
    overline: 'THERMAL LAB / CRYO-TECH',
    title: 'Engineered to Stay Cool',
    subtitle:
        'Vapor chambers, dual fans, and intelligent power delivery keep thermals '
        'silent under load.',
    imageAsset: AppAssets.videoThermal,
  ),
];
