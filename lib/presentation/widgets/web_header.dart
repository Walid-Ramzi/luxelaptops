import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/layout/page_container.dart';
import 'package:luxelaptops/core/l10n/app_strings.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/presentation/providers/cart_provider.dart';
import 'package:luxelaptops/presentation/providers/locale_provider.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

/// AXON-style web top bar: logo, nav links, pill search, cart.
class WebHeader extends StatelessWidget implements PreferredSizeWidget {
  const WebHeader({
    super.key,
    required this.onHomeTap,
    required this.onShopTap,
    required this.onGamingTap,
    required this.onBusinessTap,
    required this.onBudgetTap,
    required this.searchController,
    this.activeNav = 'Home',
  });

  final VoidCallback onHomeTap;
  final VoidCallback onShopTap;
  final VoidCallback onGamingTap;
  final VoidCallback onBusinessTap;
  final VoidCallback onBudgetTap;
  final TextEditingController searchController;
  final String activeNav;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;
    final cartCount = context.watch<CartProvider>().itemCount;
    final products = context.read<ProductProvider>();

    return Material(
      color: AppColors.background.withValues(alpha: 0.96),
      elevation: 0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 68,
            child: PageContainer(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onHomeTap,
                    child: const Text(
                      'LUXE.LABS',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _NavLink(
                          label: AppStrings.t(lang, AppStrings.home),
                          active: activeNav == 'Home',
                          onTap: onHomeTap,
                        ),
                        _NavLink(
                          label: AppStrings.t(lang, AppStrings.shop),
                          active: activeNav == 'Shop',
                          onTap: onShopTap,
                        ),
                        _NavLink(
                          label: AppStrings.t(lang, AppStrings.gaming),
                          active: activeNav == 'Gaming',
                          onTap: onGamingTap,
                        ),
                        _NavLink(
                          label: AppStrings.t(lang, AppStrings.business),
                          active: activeNav == 'Business',
                          onTap: onBusinessTap,
                        ),
                        _NavLink(
                          label: AppStrings.t(lang, AppStrings.budget),
                          active: activeNav == 'Budget',
                          onTap: onBudgetTap,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: _PillSearch(
                      controller: searchController,
                      hint: AppStrings.t(lang, AppStrings.searchHardware),
                      onChanged: products.setSearchQuery,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _LanguageMenu(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
                    icon: Badge(
                      isLabelVisible: cartCount > 0,
                      label: Text('$cartCount'),
                      child: const Icon(Icons.shopping_cart_outlined, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active || _hovered ? AppColors.primary : AppColors.textSecondary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _PillSearch extends StatefulWidget {
  const _PillSearch({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  State<_PillSearch> createState() => _PillSearchState();
}

class _PillSearchState extends State<_PillSearch> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          isDense: true,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

class _LanguageMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    return PopupMenuButton<AppLanguage>(
      tooltip: 'Language',
      icon: const Icon(Icons.language_rounded, size: 20, color: AppColors.textSecondary),
      onSelected: locale.setLanguage,
      itemBuilder: (_) => AppLanguage.values
          .map((l) => PopupMenuItem(value: l, child: Text(l.label)))
          .toList(),
    );
  }
}
