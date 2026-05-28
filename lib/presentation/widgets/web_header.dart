import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/core/layout/page_container.dart';
import 'package:luxelaptops/core/l10n/app_strings.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/presentation/providers/cart_provider.dart';
import 'package:luxelaptops/presentation/providers/locale_provider.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' show lerpDouble;

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
    this.onSearchTap,
    this.activeNav = 'Home',
  });

  final VoidCallback onHomeTap;
  final VoidCallback onShopTap;
  final VoidCallback onGamingTap;
  final VoidCallback onBusinessTap;
  final VoidCallback onBudgetTap;
  final VoidCallback? onSearchTap;
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
          border:
              Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
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
                        fontFamily: 'ArchivoBlack',
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      const fullWidth =
                          210.0; // approx width needed for all 5 links
                      final show = constraints.maxWidth >= fullWidth;
                      if (!show) return const SizedBox.shrink();
                      return Wrap(
                        alignment: WrapAlignment.center,
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
                      );
                    }),
                  ),
                  _CollapsibleSearch(
                    controller: searchController,
                    hint: AppStrings.t(lang, AppStrings.searchHardware),
                    onChanged: products.setSearchQuery,
                    onTap: onSearchTap,
                  ),
                  const SizedBox(width: 8),
                  _LanguageMenu(),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.cart),
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
    final color =
        widget.active || _hovered ? AppColors.primary : AppColors.textSecondary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
            fontSize: 15,
            fontFamily: "inter",
          ),
        ),
      ),
    );
  }
}

class _CollapsibleSearch extends StatefulWidget {
  const _CollapsibleSearch({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onTap,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  @override
  State<_CollapsibleSearch> createState() => _CollapsibleSearchState();
}

class _CollapsibleSearchState extends State<_CollapsibleSearch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _widthAnim;
  bool _expanded = false;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _widthAnim = CurvedAnimation(parent: _anim, curve: Curves.easeInOut);
    _focus.addListener(() {
      if (!_focus.hasFocus) _collapse();
    });
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _anim.dispose();
    _focus.dispose();
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _expand() {
    setState(() => _expanded = true);
    _anim.forward();
    Future.delayed(
        const Duration(milliseconds: 50), () => _focus.requestFocus());
    widget.onTap?.call();
  }

  void _collapse() {
    if (widget.controller.text.isEmpty) {
      _anim.reverse().then((_) => setState(() => _expanded = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final forceCollapse = screenWidth < 860 && screenWidth > 550;

    if (!forceCollapse) {
      return SizedBox(
        width: 200,
        child: _buildPill(),
      );
    }

    return AnimatedBuilder(
      animation: _widthAnim,
      builder: (context, _) {
        final expandedWidth = (screenWidth * 0.4).clamp(160.0, 240.0);
        final currentWidth =
            _expanded ? lerpDouble(36, expandedWidth, _widthAnim.value)! : 36.0;

        return SizedBox(
          width: currentWidth,
          child: _expanded ? _buildPill() : _buildIconOnly(),
        );
      },
    );
  }

  Widget _buildIconOnly() {
    return GestureDetector(
      onTap: _expand,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child:
            const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildPill() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        onChanged: widget.onChanged,
        onTap: widget.onTap, // <-- this was missing
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle:
              const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          isDense: true,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search,
              size: 18, color: AppColors.textSecondary),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                    _collapse();
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
      icon: const Icon(Icons.language_rounded,
          size: 20, color: AppColors.textSecondary),
      onSelected: locale.setLanguage,
      itemBuilder: (_) => AppLanguage.values
          .map((l) => PopupMenuItem(value: l, child: Text(l.label)))
          .toList(),
    );
  }
}
