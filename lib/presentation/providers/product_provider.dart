import 'package:flutter/foundation.dart';
import 'package:luxelaptops/data/models/product_model.dart';
import 'package:luxelaptops/data/services/api_service.dart';

enum ProductSort { none, priceAsc, priceDesc }

class ProductProvider extends ChangeNotifier {
  ProductProvider({ProductService? productService})
      : _productService = productService ?? ProductService();

  final ProductService _productService;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 10000;
  ProductSort _sort = ProductSort.none;

  double _catalogMin = 0;
  double _catalogMax = 10000;

  List<Product> get products => _filteredProducts;
  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get catalogMin => _catalogMin;
  double get catalogMax => _catalogMax;
  ProductSort get sort => _sort;

  Future<void> loadProducts() async {
    if (_allProducts.isNotEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _productService.fetchProducts();
      if (_allProducts.isNotEmpty) {
        _catalogMin = _allProducts.map((p) => p.price).reduce((a, b) => a < b ? a : b);
        _catalogMax = _allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b);
        _minPrice = _catalogMin;
        _maxPrice = _catalogMax;
      }
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load catalog';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
    notifyListeners();
  }

  void setSort(ProductSort sort) {
    _sort = sort;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<Product>.from(_allProducts);

    if (_selectedCategory == 'Budget') {
      result = result.where((p) => p.price <= 3000).toList();
    } else if (_selectedCategory == 'Business') {
      result = result.where((p) => p.category == 'Workstation').toList();
    } else if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    result = result
        .where((p) => p.price >= _minPrice && p.price <= _maxPrice)
        .toList();

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) => _matchesSearch(p, q)).toList();
    }

    switch (_sort) {
      case ProductSort.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.none:
        break;
    }

    _filteredProducts = result;
  }

  bool _matchesSearch(Product p, String q) {
    if (p.name.toLowerCase().contains(q)) return true;
    if (p.brand.toLowerCase().contains(q)) return true;
    if (p.tagline.toLowerCase().contains(q)) return true;
    if (p.category.toLowerCase().contains(q)) return true;
    if (p.description.toLowerCase().contains(q)) return true;
    return p.specs.entries.any(
      (e) =>
          e.key.toLowerCase().contains(q) || e.value.toLowerCase().contains(q),
    );
  }

  Product? findById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
