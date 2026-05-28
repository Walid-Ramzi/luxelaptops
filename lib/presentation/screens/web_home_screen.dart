import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/layout/page_container.dart';
import 'package:luxelaptops/core/layout/responsive.dart';
import 'package:luxelaptops/core/l10n/app_strings.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/core/utils/scroll_utils.dart';
import 'package:luxelaptops/data/models/product_model.dart';
import 'package:luxelaptops/presentation/providers/cart_provider.dart';
import 'package:luxelaptops/presentation/providers/locale_provider.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:luxelaptops/presentation/widgets/hero_carousel.dart';
import 'package:luxelaptops/presentation/widgets/product_card.dart';
import 'package:luxelaptops/presentation/widgets/shop_sidebar.dart';
import 'package:luxelaptops/presentation/widgets/web_header.dart';
import 'package:provider/provider.dart';

/// Single-page AXON-style web storefront.
class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _topSectionKey = GlobalKey();
  final _featuredSectionKey = GlobalKey();
  final _shopSectionKey = GlobalKey();
  String _activeNav = 'Home';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    setState(() => _activeNav = 'Home');
    context.read<ProductProvider>().setCategory('All');
    scrollToSection(_topSectionKey);
  }

  void _scrollToShop({String? category, String nav = 'Shop'}) {
    setState(() => _activeNav = nav);
    if (category != null) {
      context.read<ProductProvider>().setCategory(category);
    }
    scrollToSection(_shopSectionKey);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WebHeader(
        activeNav: _activeNav,
        onHomeTap: _scrollToTop,
        onShopTap: () => _scrollToShop(category: 'All'),
        onGamingTap: () => _scrollToShop(category: 'Gaming', nav: 'Gaming'),
        onBusinessTap: () =>
            _scrollToShop(category: 'Business', nav: 'Business'),
        onBudgetTap: () => _scrollToShop(category: 'Budget', nav: 'Budget'),
        onSearchTap: () => _scrollToShop(category: 'All'),
        searchController: _searchController,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: constraints.maxWidth > 600,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minWidth: AppBreakpoints.minContentWidth),
                child: SizedBox(
                  width: constraints.maxWidth < AppBreakpoints.minContentWidth
                      ? AppBreakpoints.minContentWidth
                      : constraints.maxWidth,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        KeyedSubtree(
                          key: _topSectionKey,
                          child: PageContainer(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                HeroCarousel(
                                  height:
                                      constraints.maxWidth > 800 ? 420 : 320,
                                  exploreLabel: AppStrings.t(
                                      lang, AppStrings.exploreModel),
                                  viewAllLabel: AppStrings.t(
                                      lang, AppStrings.viewAllModels),
                                  onExplore: () =>
                                      scrollToSection(_featuredSectionKey),
                                  onViewAll: () => _scrollToShop(),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                        KeyedSubtree(
                          key: _featuredSectionKey,
                          child: PageContainer(
                            child: _FeaturedSection(
                                lang: lang,
                                onViewCatalog: () => _scrollToShop()),
                          ),
                        ),
                        const SizedBox(height: 40),
                        KeyedSubtree(
                          key: _shopSectionKey,
                          child: PageContainer(
                            child: _ShopSection(lang: lang),
                          ),
                        ),
                        const SizedBox(height: 56),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.lang, required this.onViewCatalog});

  final AppLanguage lang;
  final VoidCallback onViewCatalog;

  @override
  Widget build(BuildContext context) {
    final featured = context.watch<ProductProvider>().featuredProducts;
    final columns = AppBreakpoints.productGridColumns(context).clamp(1, 3);

    if (featured.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              AppStrings.t(lang, AppStrings.featuredSystems),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewCatalog,
              child: Text(
                AppStrings.t(lang, AppStrings.viewCatalog),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.68,
          ),
          itemCount: featured.length,
          itemBuilder: (context, index) =>
              _FeaturedCard(product: featured[index], lang: lang),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.product, required this.lang});

  final Product product;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return ProductCard(
      product: product,
      buyLabel: AppStrings.t(lang, AppStrings.buyNow),
      onTap: () => Navigator.of(context).pushNamed(
        '${AppRoutes.productDetail}/${product.id}',
      ),
      onBuy: () {
        cart.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppStrings.t(lang, AppStrings.addedToCart)}: ${product.name}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}

class _ShopSection extends StatelessWidget {
  const _ShopSection({required this.lang});

  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final useSidebar = AppBreakpoints.useSidebarLayout(context);
    final columns = AppBreakpoints.productGridColumns(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.t(lang, AppStrings.shopSection),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.t(lang, AppStrings.shopSubtitle),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        if (products.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          )
        else if (useSidebar)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 260, child: ShopSidebar()),
              const SizedBox(width: 24),
              Expanded(child: _ProductGrid(columns: columns, lang: lang)),
            ],
          )
        else ...[
          const ShopSidebar(),
          const SizedBox(height: 20),
          _ProductGrid(columns: columns, lang: lang),
        ],
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.columns, required this.lang});

  final int columns;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final cart = context.read<CartProvider>();

    if (products.error != null) {
      return Center(child: Text(products.error!));
    }

    final list = products.products;
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            AppStrings.t(lang, AppStrings.noResults),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.68,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return ProductCard(
          product: product,
          buyLabel: AppStrings.t(lang, AppStrings.buyNow),
          onTap: () => Navigator.of(context).pushNamed(
            '${AppRoutes.productDetail}/${product.id}',
          ),
          onBuy: () {
            cart.addProduct(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppStrings.t(lang, AppStrings.addedToCart)}: ${product.name}',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}
