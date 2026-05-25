import 'package:luxelaptops/data/mock/mock_products.dart';
import 'package:luxelaptops/data/models/product_model.dart';

/// Product data access — swap mock for HTTP client when backend is ready.
class ProductService {
  Future<List<Product>> fetchProducts() async {
    // TODO: connect API later — e.g. GET /api/v1/products
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List<Product>.from(mockProducts);
  }

  Future<Product?> fetchProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return mockProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
