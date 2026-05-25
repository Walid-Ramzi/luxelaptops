import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/data/models/product_model.dart';
import 'package:luxelaptops/presentation/widgets/asset_image_box.dart';
import 'package:luxelaptops/presentation/widgets/price_tag.dart';
import 'package:luxelaptops/presentation/widgets/rating_stars.dart';

/// Product card with laptop photo, rating, and buy CTA.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onBuy,
    this.buyLabel = 'Buy',
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onBuy;
  final String buyLabel;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border,
          ),
          boxShadow: _hovered ? AppColors.neonGlow(AppColors.primary, blur: 14) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AssetImageBox(
                      asset: widget.product.imageAsset,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    if (widget.product.isFeatured)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'FEATURED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.background,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: widget.onTap,
                    child: Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingStars(rating: widget.product.rating, size: 12, showValue: true),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      PriceTag(price: widget.product.price),
                      const Spacer(),
                      if (widget.onBuy != null) _BuyChip(label: widget.buyLabel, onTap: widget.onBuy!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyChip extends StatefulWidget {
  const _BuyChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_BuyChip> createState() => _BuyChipState();
}

class _BuyChipState extends State<_BuyChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _hovered ? AppColors.secondary : AppColors.primary,
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}
