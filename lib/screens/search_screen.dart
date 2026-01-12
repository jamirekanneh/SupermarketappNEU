import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/demo_data.dart';
import '../widgets/product_card.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = demoProducts.where((p) {
      final q = query.toLowerCase();
      // Search by title or subtitle (or even category if desired)
      return p.title.toLowerCase().contains(q) ||
             p.subtitle.toLowerCase().contains(q);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No products found for "$query"',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return _buildGrid(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show all or filter as typing
    final suggestions = query.isEmpty
        ? <Product>[] // or demoProducts.take(4).toList() for recent?
        : demoProducts.where((p) {
            final q = query.toLowerCase();
            return p.title.toLowerCase().contains(q) ||
                   p.subtitle.toLowerCase().contains(q);
          }).toList();

    if (query.isEmpty) {
       return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.black12),
            SizedBox(height: 16),
            Text('Search your favorite products', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (suggestions.isEmpty) {
      return const Center(child: Text('No matches found'));
    }

    return _buildGrid(suggestions);
  }

  Widget _buildGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75, // Adjust based on your card design
      ),
      itemBuilder: (_, i) => ProductCard(product: products[i]),
    );
  }
}
