import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // productId -> CartItem

  List<CartItem> get items => _items.values.toList();

  int get totalItemsCount {
    int sum = 0;
    for (final item in _items.values) {
      sum += item.quantity;
    }
    return sum;
  }

  double get totalPrice {
    double sum = 0;
    for (final item in _items.values) {
      sum += item.lineTotal;
    }
    return sum;
  }

  int quantityOf(String productId) => _items[productId]?.quantity ?? 0;

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void increase(String productId) {
    if (!_items.containsKey(productId)) return;
    _items[productId]!.quantity += 1;
    notifyListeners();
  }

  void decrease(String productId) {
    if (!_items.containsKey(productId)) return;
    final item = _items[productId]!;
    item.quantity -= 1;
    if (item.quantity <= 0) _items.remove(productId);
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
