import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/l10n/app_strings.dart';
import 'package:luxelaptops/presentation/providers/locale_provider.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:luxelaptops/presentation/widgets/glass_container.dart';
import 'package:provider/provider.dart';

/// Left sidebar: price range slider + sort controls.
class ShopSidebar extends StatelessWidget {
  const ShopSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;
    final products = context.watch<ProductProvider>();

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.t(lang, AppStrings.priceRange),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: RangeValues(products.minPrice, products.maxPrice),
            min: products.catalogMin,
            max: products.catalogMax,
            divisions: 20,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              '\$${products.minPrice.round()}',
              '\$${products.maxPrice.round()}',
            ),
            onChanged: products.isLoading
                ? null
                : (v) => products.setPriceRange(v.start, v.end),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.t(lang, AppStrings.min)}: \$${products.minPrice.round()}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '${AppStrings.t(lang, AppStrings.max)}: \$${products.maxPrice.round()}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.t(lang, AppStrings.sort),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          _SortTile(
            label: AppStrings.t(lang, AppStrings.sortLowHigh),
            selected: products.sort == ProductSort.priceAsc,
            onTap: () => products.setSort(ProductSort.priceAsc),
          ),
          const SizedBox(height: 8),
          _SortTile(
            label: AppStrings.t(lang, AppStrings.sortHighLow),
            selected: products.sort == ProductSort.priceDesc,
            onTap: () => products.setSort(ProductSort.priceDesc),
          ),
        ],
      ),
    );
  }
}

class _SortTile extends StatefulWidget {
  const _SortTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SortTile> createState() => _SortTileState();
}

class _SortTileState extends State<_SortTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.selected
                ? AppColors.primary.withValues(alpha: 0.2)
                : _hovered
                    ? AppColors.cardElevated
                    : Colors.transparent,
            border: Border.all(
              color: widget.selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
              color: widget.selected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
