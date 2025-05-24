import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import 'cart/cart_provider.dart';
import 'cart/cart_page.dart';

class UserProducts extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
            },
          )
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: firestoreService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final availableProducts = snapshot.data!.where((p) => p.available).toList();

          if (availableProducts.isEmpty) return Center(child: Text('No products available right now.'));

          return ListView.builder(
            itemCount: availableProducts.length,
            itemBuilder: (context, index) {
              final product = availableProducts[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Price: ₹${product.price.toStringAsFixed(2)}'),
                trailing: Icon(Icons.add_shopping_cart),
                onTap: () {
                  Provider.of<CartProvider>(context, listen: false).addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
