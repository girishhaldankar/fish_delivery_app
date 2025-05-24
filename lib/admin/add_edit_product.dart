import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditProduct extends StatelessWidget {
  final Map<String, dynamic>? product;
  final String? productId;

  AddEditProduct({this.product, this.productId});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(
      text: product?['price']?.toString() ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price (₹)'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (name.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid name and price')),
                  );
                  return;
                }

                try {
                  final productsRef = FirebaseFirestore.instance.collection('products');

                  if (product == null) {
                    // Add new product
                    await productsRef.add({
                      'name': name,
                      'price': price,
                      'createdAt': FieldValue.serverTimestamp(),
                      'available': true,
                    });
                  } else {
                    // Update existing product
                    await productsRef.doc(productId).update({
                    'name': name,
                    'price': price,
                    'updatedAt': FieldValue.serverTimestamp(),
                    });

                  }

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
