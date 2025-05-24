import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/app_order.dart'; // renamed model

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _db.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
  }

  Future<void> setProductAvailability(String productId, bool available) async {
    await _db.collection('products').doc(productId).update({'available': available});
  }

  Stream<List<AppOrder>> getOrders() {
    return _db.collection('orders').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AppOrder.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  
  // Update order status
Future<void> updateOrderStatus(String orderId, String newStatus) async {
  await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
    'status': newStatus,
  });
}

// Delete order
Future<void> deleteOrder(String orderId) async {
  await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
}

}
