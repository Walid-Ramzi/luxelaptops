import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/data/mock/mock_products.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:luxelaptops/presentation/widgets/search_bar.dart';
import 'package:luxelaptops/presentation/widgets/filter_chip.dart';
import 'package:luxelaptops/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() => setState(() {});

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Shop',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AppSearchBar(
              controller: _searchController,
              onChanged: provider.setSearchQuery,
              onClear: () {
                _searchController.clear();
                provider.setSearchQuery('');
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: productCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cat = productCategories[index];
                return FilterChipWidget(
                  label: cat,
                  selected: provider.selectedCategory == cat,
                  onTap: () => provider.setCategory(cat),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _ProductGrid(provider: provider)),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.provider});

  final ProductProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    final products = provider.products;
    if (products.isEmpty) {
      return const Center(
        child: Text('No laptops match your filters.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final crossAxisCount = MediaQuery.sizeOf(context).width > 700 ? 2 : 1;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => Navigator.of(context).pushNamed(
            '${AppRoutes.productDetail}/${product.id}',
          ),
        );
      },
    );
  }
}
