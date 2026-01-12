import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Watch cart to see quantity updates
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.id);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1F2F64FF),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.imageUrl.startsWith('assets/')
                  ? Image.asset(product.imageUrl, fit: BoxFit.cover)
                  : Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),

          // Price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),

          // Quantity Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: qty > 0 ? () => cart.decrease(product.id) : null,
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
                  '${qty == 0 ? 1 : qty}', // Show 1 if 0 so it looks nice before adding? 
                  // Wait, existing code showed '1' if qty is 0. 
                  // "qty == 0 ? 1 : qty" was in existing code.
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => cart.add(product),
                icon: const Icon(Icons.add),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),

          const SizedBox(height: 6),
          // Add Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => cart.add(product),
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
