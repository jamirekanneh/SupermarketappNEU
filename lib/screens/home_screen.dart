import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/market.dart';
import 'market_screen.dart';
import 'category_screen.dart'; // Import CategoryScreen
import 'search_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openMarket(BuildContext context, Market market) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MarketScreen(market: market)),
    );
  }

  void _openCategory(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(categoryName: title),
      ),
    );
  }

  // ✅ Market adına göre kart rengi
  Color _marketColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('ikas')) return const Color(0xFF3E7B3B);
    if (n.contains('dima')) return const Color(0xFF2E5AA8);
    if (n.contains('macro')) return const Color(0xFFD77A2B);
    if (n.contains('kiler')) return const Color(0xFFB63A32);
    return const Color(0xFF2F64FF);
  }

  // ✅ Market adını kısa yaz
  String _marketShortName(String name) {
    final n = name.toLowerCase();
    if (n.contains('ikas')) return 'IKAS';
    if (n.contains('dima')) return 'DIMA';
    if (n.contains('macro')) return 'MACRO';
    if (n.contains('kiler')) return 'KILER';
    return name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top bar
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    'assets/products/logo.jpeg',
                    fit: BoxFit.cover,
                    width: 52,
                    height: 52,
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(onPressed: () {}, child: const Text('Login')),
            ],
          ),

          const SizedBox(height: 16),

          // Search
          InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0x1F2F64FF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Text('Search', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ✅ BANNER (Network Image – asset yok)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF2F64FF),
            ),
            child: Stack(
              children: [
                // Right image
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1542838132-92c53300491e',
                      width: 190,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Left text
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  right: 190, // Ensure text doesn't overlap with the 190px wide image
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enjoy the special\noffer up to 30%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Markets',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // ✅ Markets (ARTIK RESİM YOK → KÜÇÜK YAZI VAR)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: markets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.7,
            ),
            itemBuilder: (_, i) {
              final m = markets[i];
              final shortName = _marketShortName(m.name);
              final bg = _marketColor(m.name);

              return InkWell(
                onTap: () => _openMarket(context, m),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: bg,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        shortName,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 22, // ✅ küçültülmüş font
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 22),
          const Text(
            'Categories',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CategoryItem(
                title: 'Grocery\n& Staples',
                icon: Icons.shopping_basket_outlined,
                onTap: () => _openCategory(context, 'Grocery & Staples'),
              ),
              _CategoryItem(
                title: 'Frozen\nFood',
                icon: Icons.ac_unit_outlined,
                onTap: () => _openCategory(context, 'Frozen Food'),
              ),
              _CategoryItem(
                title: 'Fruits &\nVegetables',
                icon: Icons.local_florist_outlined,
                onTap: () => _openCategory(context, 'Fruits & Vegetables'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 105,
        child: Column(
          children: [
            Container(
              height: 64,
              width: 105,
              decoration: BoxDecoration(
                color: const Color(0x1A2F64FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
