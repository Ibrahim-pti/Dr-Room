import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String title;
  final String status;
  final Color statusColor;
  final IconData icon;
  final Color iconColor;
  final double price;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.iconColor,
    required this.price,
    required this.date,
  });
}

class OrderProvider {
  // Singleton
  static final OrderProvider _instance = OrderProvider._internal();
  factory OrderProvider() => _instance;
  OrderProvider._internal();

  final ValueNotifier<List<OrderModel>> ordersNotifier = ValueNotifier([]);

  List<OrderModel> get orders => ordersNotifier.value;

  void addOrder(OrderModel order) {
    // Add to the top of the list
    ordersNotifier.value = [order, ...ordersNotifier.value];
  }

  void updateOrderStatus(String id, String newStatus, Color newColor) {
    final updatedList = ordersNotifier.value.map((order) {
      if (order.id == id) {
        return OrderModel(
          id: order.id,
          title: order.title,
          status: newStatus,
          statusColor: newColor,
          icon: order.icon,
          iconColor: order.iconColor,
          price: order.price,
          date: order.date,
        );
      }
      return order;
    }).toList();
    ordersNotifier.value = updatedList;
  }
}
