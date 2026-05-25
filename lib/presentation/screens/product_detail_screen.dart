import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/data/models/product_model.dart';
import 'package:luxelaptops/presentation/providers/cart_provider.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:luxelaptops/presentation/widgets/asset_image_box.dart';
import 'package:luxelaptops/presentation/widgets/custom_button.dart';
import 'package:luxelaptops/presentation/widgets/glass_container.dart';
import 'package:luxelaptops/presentation/widgets/price_tag.dart';
import 'package:luxelaptops/presentation/widgets/rating_stars.dart';
import 'package:luxelaptops/presentation/widgets/telemetry_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductProvider>().findById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    return _ProductDetailBody(product: product);
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inCart = cart.contains(product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AssetImageBox(asset: product.imageAsset, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  product.brand.toUpperCase(),
                  style: const TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(product.tagline, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    RatingStars(rating: product.rating, reviewCount: product.reviewCount),
                    const Spacer(),
                    PriceTag(price: product.price, large: true),
                  ],
                ),
                const SizedBox(height: 24),
                Text(product.description, style: const TextStyle(height: 1.6, fontSize: 15)),
                const SizedBox(height: 24),
                TelemetryPanel(telemetry: product.telemetry),
                const SizedBox(height: 24),
                Text(
                  'Specifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ...product.specs.entries.map((e) => _SpecRow(label: e.key, value: e.value)),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: inCart ? 'In Cart' : 'Add to Cart',
                  icon: inCart ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                  variant: inCart ? CustomButtonVariant.secondary : CustomButtonVariant.primary,
                  onPressed: inCart
                      ? null
                      : () {
                          cart.addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.cardElevated,
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 12,
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
