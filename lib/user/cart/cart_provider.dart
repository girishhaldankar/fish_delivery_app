import 'package:flutter/material.dart';
import '../../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<Product, int> _cartItems = {};

  Map<Product, int> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! > 1) {
        _cartItems[product] = _cartItems[product]! - 1;
      } else {
        _cartItems.remove(product);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems.remove(product);
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    _cartItems.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }
}
