import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/layout/page_container.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/data/models/product_model.dart';
import 'package:luxelaptops/presentation/providers/cart_provider.dart';
import 'package:luxelaptops/presentation/widgets/asset_image_box.dart';
import 'package:luxelaptops/presentation/widgets/custom_button.dart';
import 'package:luxelaptops/presentation/widgets/glass_container.dart';
import 'package:luxelaptops/presentation/widgets/price_tag.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return SafeArea(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Text(
                    'Cart',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const Spacer(),
                  if (cart.items.isNotEmpty)
                    TextButton(
                      onPressed: cart.clear,
                      child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: cart.items.isEmpty
                  ? const _EmptyCart()
                  : ListView.separated(
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return _CartLineItem(
                          item: item,
                          onIncrement: () => cart.updateQuantity(
                            item.product.id,
                            item.quantity + 1,
                          ),
                          onDecrement: () => cart.updateQuantity(
                            item.product.id,
                            item.quantity - 1,
                          ),
                          onRemove: () => cart.removeProduct(item.product.id),
                          onTap: () => Navigator.of(context).pushNamed(
                            '${AppRoutes.productDetail}/${item.product.id}',
                          ),
                        );
                      },
                    ),
            ),
            if (cart.items.isNotEmpty) _CheckoutBar(subtotal: cart.subtotal),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text('Your cart is empty', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CartLineItem extends StatelessWidget {
  const _CartLineItem({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onTap,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AssetImageBox(
              asset: item.product.imageAsset,
              width: 56,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                PriceTag(price: item.product.price),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QtyButton(icon: Icons.remove, onTap: onDecrement),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              _QtyButton(icon: Icons.add, onTap: onIncrement),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                onPressed: onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Subtotal', style: TextStyle(color: AppColors.textSecondary)),
              const Spacer(),
              PriceTag(price: subtotal, large: true),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Checkout (Demo)',
            icon: Icons.lock_rounded,
            expanded: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout connects to your payment API later.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
