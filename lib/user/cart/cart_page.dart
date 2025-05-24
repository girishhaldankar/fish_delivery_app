import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import 'cart_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    double totalPrice = 0;
    cartItems.forEach((product, qty) {
      totalPrice += product.price * qty;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems.keys.elementAt(index);
                final quantity = cartItems[product]!;
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Quantity: $quantity'),
                  trailing: Text('₹${(product.price * quantity).toStringAsFixed(2)}'),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          cartProvider.decreaseQuantity(product);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          cartProvider.addToCart(product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          child: Text('Checkout (₹${totalPrice.toStringAsFixed(2)})'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage()));
          },
        ),
      ),
    );
  }
}
