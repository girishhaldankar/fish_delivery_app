import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../models/app_order.dart';

class AdminOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<List<AppOrder>>(
        stream: firestoreService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error loading orders'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final orders = snapshot.data!;
          if (orders.isEmpty) return Center(child: Text('No orders found'));

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Customer: ${order.customerName}'),
                  subtitle: Text('Items: ${order.itemsSummary}\nStatus: ${order.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        value: order.status,
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            firestoreService.updateOrderStatus(order.id, newStatus);
                          }
                        },
                        items: ['pending', 'served', 'cancelled']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(context, firestoreService, order.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, FirestoreService service, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Order?'),
        content: Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              service.deleteOrder(orderId);
              Navigator.pop(ctx);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
