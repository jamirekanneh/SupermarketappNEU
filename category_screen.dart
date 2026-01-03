import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/demo_data.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  List<Product> get _filteredProducts {
    final lowerName = categoryName.toLowerCase();
    
    if (lowerName.contains('fruit') || lowerName.contains('vegetable')) {
      return demoProducts
          .where((p) => p.category == 'Fruits' || p.category == 'Vegetables')
          .toList();
    }
    if (lowerName.contains('grocery')) {
      return demoProducts.where((p) => p.category == 'Grocery').toList();
    }
    if (lowerName.contains('frozen')) {
      return demoProducts.where((p) => p.category == 'Frozen').toList();
    }
    
    return demoProducts;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName.replaceAll('\n', ' ')),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products found in this category'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (_, index) {
                    final p = products[index];
                    final qty = cart.quantityOf(p.id);

                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F64FF).withOpacity(.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: p.imageUrl.startsWith('assets/')
                                  ? Image.asset(p.imageUrl, fit: BoxFit.cover)
                                  : Image.network(p.imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: qty > 0 ? () => cart.decrease(p.id) : null,
                                icon: const Icon(Icons.remove),
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${qty == 0 ? 1 : qty}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => cart.add(p),
                                icon: const Icon(Icons.add),
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => cart.add(p),
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
