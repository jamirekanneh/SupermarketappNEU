import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const primaryBlue = Color(0xFF1E63FF);
  static const silverBlue = Color(0xFF5F7D8A);

  @override
  Widget build(BuildContext context) {
    final ordersData = context.watch<OrdersProvider>();
    final orders = ordersData.orders;

    return Scaffold(
      backgroundColor: Colors.white,

      /// ✅ NO bottomNavigationBar here
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Row(
                children: [
                  if (Navigator.canPop(context))
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  const Expanded(
                    child: Text(
                      "My Orders",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  _iconCircle(Icons.search),
                ],
              ),
            ),
            
            Expanded(
              child: orders.isEmpty
                  ? const Center(
                      child: Text(
                        "No orders yet",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(18),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final order = orders[i];
                        // Use the first product for display
                        final firstProduct = order.products.first.product;
                        final itemCount = order.products.length;
                        final dateStr =
                            "${order.dateTime.day}/${order.dateTime.month}/${order.dateTime.year}";

                        return _orderedItem(
                          title: itemCount > 1
                              ? "${firstProduct.title} & ${itemCount - 1} others"
                              : firstProduct.title,
                          meta:
                              "Date: $dateStr\nTotal: \$${order.amount.toStringAsFixed(2)}",
                          status: order.status,
                          statusColor: order.status == "Delivered"
                              ? primaryBlue
                              : silverBlue,
                          imagePath: firstProduct.imageUrl.startsWith('assets/')
                              ? firstProduct.imageUrl
                              : null,
                          imageUrl: !firstProduct.imageUrl.startsWith('assets/')
                              ? firstProduct.imageUrl
                              : null,
                          onTrackTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailScreen(order: order),
                              ),
                            );
                          },
                          onDeleteTap: () {
                            Provider.of<OrdersProvider>(context, listen: false)
                                .removeOrder(order.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Order removed"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _iconCircle(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _imageBox({String? imagePath, String? imageUrl}) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: imagePath != null
            ? Image.asset(imagePath, fit: BoxFit.cover)
            : imageUrl != null
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : const Icon(Icons.shopping_basket, size: 32),
      ),
    );
  }

  Widget _orderedItem({
    required String title,
    required String meta,
    required String status,
    required Color statusColor,
    String? imagePath,
    String? imageUrl,
    required VoidCallback onTrackTap,
    required VoidCallback onDeleteTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _imageBox(imagePath: imagePath, imageUrl: imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 4),
                Text(meta,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.3)),
                const SizedBox(height: 6),
                Text(status,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDeleteTap,
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: onTrackTap,
            child: const Text(
              "Track",
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFEDEDED)),
    );
  }
}
