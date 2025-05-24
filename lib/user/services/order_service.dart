import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';

class OrderService {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> placeOrder(Map<Product, int> cartItems, double total, String customerName) async {
    List<Map<String, dynamic>> items = cartItems.entries.map((entry) {
      return {
        'name': entry.key.name,
        'price': entry.key.price,
        'quantity': entry.value,
      };
    }).toList();

    await ordersCollection.add({
      'customerName': customerName,
      'items': items,
      'total': total,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}
