import 'package:cloud_firestore/cloud_firestore.dart';

class AppOrder {
  final String id;
  final String customerName;
  final List<dynamic> items;
  final String status;
  final DateTime timestamp;

  AppOrder({
    required this.id,
    required this.customerName,
    required this.items,
    required this.status,
    required this.timestamp,
  });

  factory AppOrder.fromMap(String id, Map<String, dynamic> data) {
    return AppOrder(
      id: id,
      customerName: data['customerName'] ?? '',
      items: data['items'] ?? [],
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'items': items,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  String get itemsSummary {
    return items.map((item) {
      final name = item['name'] ?? '';
      final qty = item['quantity'] ?? 1;
      return '$name x$qty';
    }).join(', ');
  }
}
