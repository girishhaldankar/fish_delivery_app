import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import '../../models/product.dart';
import '../services/order_service.dart'; // ✅ Import the order service

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final OrderService orderService = OrderService(); // ✅ Create instance

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    double totalPrice = 0;
    cartItems.forEach((product, qty) {
      totalPrice += product.price * qty;
    });

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer Name'),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Order Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems.keys.elementAt(index);
                        final qty = cartItems[product]!;
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('Quantity: $qty'),
                          trailing: Text('₹${(product.price * qty).toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text('Total: ₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      child: Text('Place Order'),
                      onPressed: () async {
                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter your name')),
                          );
                          return;
                        }

                        await orderService.placeOrder(
                          cartItems,
                          totalPrice,
                          _nameController.text.trim(), // ✅ Send customer name
                        );

                        cartProvider.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order placed successfully!')),
                        );
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
