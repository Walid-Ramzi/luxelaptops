import 'package:luxelaptops/presentation/providers/locale_provider.dart';

/// Translation keys — extend maps when adding new copy.
abstract final class AppStrings {
  static const home = 'home';
  static const shop = 'shop';
  static const searchHint = 'search_hint';
  static const shopSection = 'shop_section';
  static const shopSubtitle = 'shop_subtitle';
  static const priceRange = 'price_range';
  static const sort = 'sort';
  static const sortLowHigh = 'sort_low_high';
  static const sortHighLow = 'sort_high_low';
  static const buyNow = 'buy_now';
  static const featured = 'featured';
  static const cart = 'cart';
  static const noResults = 'no_results';
  static const addedToCart = 'added_to_cart';
  static const language = 'language';
  static const heroCta = 'hero_cta';
  static const min = 'min';
  static const max = 'max';
  static const products = 'products';
  static const gaming = 'gaming';
  static const business = 'business';
  static const budget = 'budget';
  static const searchHardware = 'search_hardware';
  static const featuredSystems = 'featured_systems';
  static const viewCatalog = 'view_catalog';
  static const exploreModel = 'explore_model';
  static const viewAllModels = 'view_all_models';

  static String t(AppLanguage language, String key) {
    return _maps[language]?[key] ?? _maps[AppLanguage.en]![key] ?? key;
  }

  static final Map<AppLanguage, Map<String, String>> _maps = {
    AppLanguage.en: {
      home: 'Home',
      shop: 'Shop',
      searchHint: 'Search name, brand, specs…',
      shopSection: 'Shop Flagships',
      shopSubtitle: 'Filter by price, sort, and find your machine.',
      priceRange: 'Price range',
      sort: 'Sort by price',
      sortLowHigh: 'Lowest → Highest',
      sortHighLow: 'Highest → Lowest',
      buyNow: 'Buy',
      featured: 'Featured',
      cart: 'Cart',
      noResults: 'No laptops match your filters.',
      addedToCart: 'Added to cart',
      language: 'Language',
      heroCta: 'Explore Shop',
      min: 'Min',
      max: 'Max',
      products: 'products',
      gaming: 'Gaming',
      business: 'Business',
      budget: 'Budget',
      searchHardware: 'Search hardware…',
      featuredSystems: 'Featured Systems',
      viewCatalog: 'View catalog →',
      exploreModel: 'Explore Model',
      viewAllModels: 'View All Models',
    },
    AppLanguage.fr: {
      home: 'Accueil',
      shop: 'Boutique',
      searchHint: 'Nom, marque, specs…',
      shopSection: 'Nos Flagships',
      shopSubtitle: 'Filtrez par prix et triez votre sélection.',
      priceRange: 'Fourchette de prix',
      sort: 'Trier par prix',
      sortLowHigh: 'Croissant',
      sortHighLow: 'Décroissant',
      buyNow: 'Acheter',
      featured: 'En vedette',
      cart: 'Panier',
      noResults: 'Aucun ordinateur ne correspond.',
      addedToCart: 'Ajouté au panier',
      language: 'Langue',
      heroCta: 'Voir la boutique',
      min: 'Min',
      max: 'Max',
      products: 'produits',
      gaming: 'Gaming',
      business: 'Professionnel',
      budget: 'Budget',
      searchHardware: 'Rechercher…',
      featuredSystems: 'Systèmes vedettes',
      viewCatalog: 'Voir le catalogue →',
      exploreModel: 'Explorer',
      viewAllModels: 'Tous les modèles',
    },
    AppLanguage.ar: {
      home: 'الرئيسية',
      shop: 'المتجر',
      searchHint: 'ابحث بالاسم أو العلامة أو المواصفات…',
      shopSection: 'أجهزة مميزة',
      shopSubtitle: 'صفّ حسب السعر ورتّب النتائج.',
      priceRange: 'نطاق السعر',
      sort: 'ترتيب السعر',
      sortLowHigh: 'الأقل ← الأعلى',
      sortHighLow: 'الأعلى ← الأقل',
      buyNow: 'شراء',
      featured: 'مميز',
      cart: 'السلة',
      noResults: 'لا توجد نتائج مطابقة.',
      addedToCart: 'تمت الإضافة للسلة',
      language: 'اللغة',
      heroCta: 'تصفح المتجر',
      min: 'الحد الأدنى',
      max: 'الحد الأعلى',
      products: 'منتجات',
      gaming: 'ألعاب',
      business: 'أعمال',
      budget: 'اقتصادي',
      searchHardware: 'بحث في الأجهزة…',
      featuredSystems: 'أنظمة مميزة',
      viewCatalog: 'عرض الكتالوج ←',
      exploreModel: 'استكشف الطراز',
      viewAllModels: 'كل الطرز',
    },
  };
}
