import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:luxelaptops/presentation/widgets/asset_image_box.dart';
import 'package:luxelaptops/presentation/widgets/glass_container.dart';
import 'package:luxelaptops/presentation/widgets/telemetry_widget.dart';
import 'package:provider/provider.dart';

/// Hardware Lab — compare live telemetry across flagships.
class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final list = products.products.isNotEmpty
        ? products.products
        : products.featuredProducts;

    if (products.isLoading) {
      return const SafeArea(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (list.isEmpty) {
      return const SafeArea(child: Center(child: Text('No devices in lab')));
    }

    final selected = list[_selectedIndex.clamp(0, list.length - 1)];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Hardware Lab',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Simulated live telemetry — select a machine to inspect.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final p = list[index];
                final active = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: active ? AppColors.primaryGlow : null,
                      color: active ? null : AppColors.card,
                      border: Border.all(
                        color: active ? Colors.transparent : AppColors.border,
                      ),
                      boxShadow: active ? AppColors.neonGlow(AppColors.primary) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AssetImageBox(
                            asset: p.imageAsset,
                            width: 48,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: active ? AppColors.background : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          GlassContainer(
            glowColor: AppColors.primary.withValues(alpha: 0.25),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AssetImageBox(
                    asset: selected.imageAsset,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Text(selected.tagline, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TelemetryPanel(telemetry: selected.telemetry),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(
              '${AppRoutes.productDetail}/${selected.id}',
            ),
            icon: const Icon(Icons.open_in_new_rounded, color: AppColors.primary),
            label: const Text('View full specifications'),
          ),
        ],
      ),
    );
  }
}
