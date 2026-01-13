import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Determine timeline step status based on order status
    // Simple logic:
    // Arriving -> Confirmed (Done), Packaging (Done/In Progress), Delivered (Pending)
    // Delivered -> All Done
    bool isDelivered = order.status == "Delivered";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER with Back Button & Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo/Title Area
                  Row(
                    children: [
                       Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade50,
                        ),
                        child: const Icon(Icons.shopping_cart, color: Color(0xFF1E63FF), size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Order Tracking",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Signal/Battery icons are system level, skipping those
                ],
              ),

              const SizedBox(height: 30),

              // ORDER DETAILS BLUE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF90CAF9).withOpacity(0.4), // Light blue
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Details:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Order ID: #${order.id.substring(0, 4)}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Order Date: ${order.dateTime.day}/${order.dateTime.month}/${order.dateTime.year}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // TIMELINE
              _buildTimeline(isDelivered),

              const SizedBox(height: 30),

              // ITEMS BLUE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF90CAF9).withOpacity(0.4), // Light blue
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Items",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: order.products.length,
                      itemBuilder: (ctx, i) {
                        final item = order.products[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              // Image
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: item.product.imageUrl
                                          .startsWith('assets/')
                                      ? Image.asset(item.product.imageUrl,
                                          fit: BoxFit.cover)
                                      : Image.network(item.product.imageUrl,
                                          fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Name
                              Expanded(
                                child: Text(
                                  item.product.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              ),
                              // Qty
                              Text(
                                "${item.quantity}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                              const SizedBox(width: 30),
                              // Price
                              Text(
                                "\$${item.product.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // BOTTOM DETAILS (Payment & Address)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Payment",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              order.paymentMethod,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            if (order.paymentMethod == "Card")
                              const Icon(Icons.credit_card,
                                  size: 16, color: Color(0xFF1E63FF))
                            else
                              const Icon(Icons.money,
                                  size: 16, color: Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Delivery",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const Text("Address",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text(
                          "Dereboyu, Lefkosa",
                          style:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 20),
               // Back Button
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back to Orders"),
                ),
              ),
               const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(bool isDelivered) {
    const activeColor = Color(0xFF1E63FF); // Blue
    const inactiveColor = Color(0xFFE0E0E0); // Grey

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _timelineStep("Order\nConfirmed", "Wed, 5th", true, activeColor),
        _timelineLine(true, activeColor),
        _timelineStep("Packaging", "Wed, 6th", true, activeColor),
        _timelineLine(isDelivered, isDelivered ? activeColor : inactiveColor),
        _timelineStep("Delivered", isDelivered ? "Included" : "Expected",
            isDelivered, isDelivered ? activeColor : inactiveColor),
      ],
    );
  }

  Widget _timelineStep(
      String title, String date, bool isActive, Color color) {
    return Column(
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(date,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _timelineLine(bool isActive, Color color) {
    return Expanded(
      child: Container(
        height: 2,
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 14), 
        // vertical 14 aligns it roughly with the dot
        // Adjust based on font sizes above
        transform: Matrix4.translationValues(0, -10, 0), 
      ),
    );
  }
}
