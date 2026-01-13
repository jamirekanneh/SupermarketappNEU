import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/demo_data.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class MarketScreen extends StatelessWidget {
  final Market market;
  const MarketScreen({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    const tabs = [
      'Popular',
      'Vegetables',
      'Fruits',
      'Frozen',
      'Grocery & Staples',
      'Technology'
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(title: Text(market.name), centerTitle: true),
        body: Column(
          children: [
            // Header Content (Logo + Name)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      market.logoUrl,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0x1F2F64FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        market.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // TabBar (Swipeable Tabs Header)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0x1F2F64FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  tabs: tabs.map((t) => Tab(text: t)).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // TabBarView (Swipeable Content)
            Expanded(
              child: TabBarView(
                children: tabs.map((tabName) {
                  return _ProductGrid(category: tabName);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final String category;

  const _ProductGrid({required this.category});

  List<Product> get _filteredProducts {
    if (category == 'Popular') {
      return demoProducts.take(8).toList();
    }
    // Staples are essentially grocery items
    if (category == 'Grocery & Staples') {
      return demoProducts.where((p) => p.category == 'Grocery').toList();
    }
    return demoProducts.where((p) => p.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    final cart = context.watch<CartProvider>();

    if (products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
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
            color: const Color(0x1F2F64FF),
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
                p.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),

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
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        qty == 0 ? cart.add(p) : cart.increase(p.id),
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
    );
  }
}
