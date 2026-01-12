class Product {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String imageUrl;
  final String category; // "Popular", "Vegetables", "Fruits"

  const Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}
