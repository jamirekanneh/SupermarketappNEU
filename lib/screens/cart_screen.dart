import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import 'card_payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _paymentMethod = "Cash";

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Shopping cart'), centerTitle: true),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Cart is empty'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final item = cart.items[i];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x14000000),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    item.product.imageUrl.startsWith('assets/')
                                        ? Image.asset(
                                            item.product.imageUrl,
                                            width: 52,
                                            height: 52,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            item.product.imageUrl,
                                            width: 52,
                                            height: 52,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.product.subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: const Color(0x99000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        cart.decrease(item.product.id),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        cart.increase(item.product.id),
                                    icon: const Icon(Icons.keyboard_arrow_up),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 6),
                              Text(
                                '\$${item.product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),

                              IconButton(
                                onPressed: () => cart.remove(item.product.id),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // PAYMENT METHOD SELECTION
            if (cart.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Method",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Cash"),
                            value: "Cash",
                            groupValue: _paymentMethod,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              setState(() => _paymentMethod = val!);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Card"),
                            value: "Card",
                            groupValue: _paymentMethod,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              setState(() => _paymentMethod = val!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0x0A000000),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Total  \$${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: cart.items.isEmpty
                        ? null
                        : () {
                            if (_paymentMethod == "Card") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CardPaymentScreen(),
                                ),
                              );
                            } else {
                              // Cash Payment
                              Provider.of<OrdersProvider>(context,
                                      listen: false)
                                  .addOrder(
                                cart.items,
                                cart.totalPrice,
                                _paymentMethod,
                              );
                              cart.clear();
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.blue, size: 60),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Your order is being processed. You can pay at the door.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
