import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import 'add_edit_product.dart';
import 'product_tile.dart';
import 'admin_orders.dart';  // Import the Admin Orders Page

class AdminHome extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            tooltip: 'View Orders',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminOrdersPage()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: firestoreService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final products = snapshot.data!;
          if (products.isEmpty) return Center(child: Text('No products found.'));

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductTile(
                product: product,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditProduct(
                        product: {
                          'name': product.name,
                          'price': product.price,
                          'available': product.available,
                        },
                        productId: product.id,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  await firestoreService.deleteProduct(product.id);
                },
                onToggleAvailability: (value) async {
                  final updatedProduct = Product(
                    id: product.id,
                    name: product.name,
                    price: product.price,
                    available: value,
                  );
                  await firestoreService.updateProduct(updatedProduct);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditProduct()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
