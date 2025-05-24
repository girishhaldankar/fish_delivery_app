class Product {
  final String id;
  final String name;
  final double price;
  final bool available;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      available: data['available'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'available': available,
    };
  }
}
