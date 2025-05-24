// screens/user_home.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class UserHome extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Fish')),
      body: StreamBuilder<List<Product>>(
        stream: firestoreService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final availableProducts =
              snapshot.data!.where((product) => product.available).toList();

          if (availableProducts.isEmpty) return Center(child: Text('No fish available.'));

          return ListView.builder(
            itemCount: availableProducts.length,
            itemBuilder: (context, index) {
              final product = availableProducts[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('₹ ${product.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
