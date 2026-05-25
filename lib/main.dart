import 'package:flutter/material.dart';
import 'package:luxelaptops/core/routes/app_routes.dart';
import 'package:luxelaptops/core/theme/app_theme.dart';
import 'package:luxelaptops/presentation/providers/cart_provider.dart';
import 'package:luxelaptops/presentation/providers/locale_provider.dart';
import 'package:luxelaptops/presentation/providers/product_provider.dart';
import 'package:luxelaptops/presentation/screens/cart_screen.dart';
import 'package:luxelaptops/presentation/screens/product_detail_screen.dart';
import 'package:luxelaptops/presentation/screens/web_home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LuxeLaptopsApp());
}

class LuxeLaptopsApp extends StatelessWidget {
  const LuxeLaptopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, locale, _) {
          return MaterialApp(
            title: 'LuxeLaptops',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            locale: locale.locale,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(
                    media.size.width > 1400 ? 0.95 : 1.0,
                  ),
                ),
                child: Directionality(
                  textDirection:
                      locale.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            initialRoute: AppRoutes.home,
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }

  static Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? AppRoutes.home;

    if (name.startsWith(AppRoutes.productDetail)) {
      final id = name.replaceFirst('${AppRoutes.productDetail}/', '');
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ProductDetailScreen(productId: id),
      );
    }

    if (name == AppRoutes.cart) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const _CartPage(),
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const WebHomeScreen(),
    );
  }
}

/// Cart as full page with web header spacing (no bottom nav).
class _CartPage extends StatelessWidget {
  const _CartPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CartScreen());
  }
}
