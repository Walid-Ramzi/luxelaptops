/// Hardware telemetry snapshot for the Lab screen.
class ProductTelemetry {
  const ProductTelemetry({
    required this.cpuLoad,
    required this.gpuLoad,
    required this.ramUsage,
    required this.tempCelsius,
    required this.batteryHealth,
    required this.fanRpm,
  });

  final double cpuLoad;
  final double gpuLoad;
  final double ramUsage;
  final double tempCelsius;
  final double batteryHealth;
  final int fanRpm;
}

/// High-end laptop product entity.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageAsset,
    required this.category,
    required this.tagline,
    required this.description,
    required this.specs,
    required this.telemetry,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String brand;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageAsset;
  final String category;
  final String tagline;
  final String description;
  final Map<String, String> specs;
  final ProductTelemetry telemetry;
  final bool isFeatured;

  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
}

/// Cart line item with quantity.
class CartItem {
  const CartItem({required this.product, this.quantity = 1});

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}
