import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrdersProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total, String paymentMethod) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
        status: "Arriving",
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }

  void removeOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }
}
