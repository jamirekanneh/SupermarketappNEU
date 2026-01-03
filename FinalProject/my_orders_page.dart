import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  static const primaryBlue = Color(0xFF1E63FF);

  int qty = 2;
  final double unitPrice = 12.50;

  double get total => qty * unitPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "My Orders",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _circleIcon(Icons.search),
                ],
              ),

              const SizedBox(height: 18),

              /// Order Summary + Menu
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Order Summary",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                  
                ],
              ),

              const SizedBox(height: 12),

              /// Summary Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Product image
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color(0xFFF2F2F2),
                          ),
                          child: const Icon(Icons.local_grocery_store, size: 34),
                        ),

                        const SizedBox(width: 12),

                        /// Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Family package",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Family package with fresh\ngroceries from Molto",
                                style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.3),
                              ),
                            ],
                          ),
                        ),

                        /// Price
                        const Text(
                          "\$12.50",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 10),

                    /// Total row
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Total 2 items",
                            style: TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ),
                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Qty stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _qtyButton(Icons.remove, () {
                          setState(() => qty = (qty - 1).clamp(1, 99));
                        }),
                        SizedBox(
                          width: 36,
                          child: Center(
                            child: Text("$qty",
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        _qtyButton(Icons.add, () {
                          setState(() => qty = (qty + 1).clamp(1, 99));
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Place Order Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 111, 248),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Place Order",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// Ordered items header
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      "Ordered Items",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(color: Color.fromARGB(255, 46, 106, 247), fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _orderedItem(
                title: "Fresh Juicy Oranges",
                meta: "Delivery · 123 Gonyeli\nFrom killer Market",
                status: "Arriving",
              ),

              const SizedBox(height: 12),

              _orderedItem(
                title: "Organic Fresh Tomatoes",
                meta: "Delivery · 123 Girne\nFrom Dima Market",
                status: "Delivered",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Helpers =====

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE9E9E9)),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      );

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _orderedItem({
    required String title,
    required String meta,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_basket_outlined),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 4),
                Text(meta,
                    style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.3)),
                const SizedBox(height: 6),
                Text(
                  status,
                  style: const TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 51, 111, 249),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            onPressed: () {},
            child: const Text("Track", style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
