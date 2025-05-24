class Product {
  String id;
  String name;
  double price;
  String description;
  String imageUrl;
  bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'],
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'description': description,
    'imageUrl': imageUrl,
    'isAvailable': isAvailable,
  };
}
