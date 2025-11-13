import 'package:flutter/foundation.dart';
class CartItem {
  final String id;       // The unique product ID
  final String name;
  final double price;
  int quantity;          // Quantity can change, so it's not final

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1, // Default to 1 when added
  });
}

// 2. The CartProvider class "mixes in" ChangeNotifier
class CartProvider with ChangeNotifier {

  // 3. This is the private list of items.
  //    No one outside this class can access it directly.
  final List<CartItem> _items = [];

  // 4. A public "getter" to let widgets *read* the list of items
  List<CartItem> get items => _items;

  // 5. A public "getter" to calculate the total number of items
  int get itemCount {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  // 6. A public "getter" to calculate the total price
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += (item.price * item.quantity);
    }
    return total;
  }

  // 7. The main logic: "Add Item to Cart"
  void addItem(String id, String name, double price) {
    // 8. Check if the item is already in the cart
    var index = _items.indexWhere((item) => item.id == id);

    if (index != -1) {
      // 9. If YES: just increase the quantity
      _items[index].quantity++;
    } else {
      // 10. If NO: add it to the list as a new item
      _items.add(CartItem(id: id, name: name, price: price));
    }

    // 11. CRITICAL: This tells all "listening" widgets to rebuild!
    notifyListeners();
  }

  // 12. The "Remove Item from Cart" logic
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners(); // Tell widgets to rebuild
  }
}