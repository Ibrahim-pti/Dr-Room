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

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderProvider() {
    // Optionally fetch initial orders here
  }

  // Simulate network request to fetch orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    // Fake network delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // For now we don't overwrite if we already have local orders,
    // but in a real app, this would fetch from Firebase.
    _isLoading = false;
    notifyListeners();
  }

  // Simulate network request to add an order
  Future<void> addOrder(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    // Fake network delay (1.5 seconds) to simulate saving to DB
    await Future.delayed(const Duration(milliseconds: 1500));

    _orders = [order, ..._orders];
    
    _isLoading = false;
    notifyListeners();
  }

  void updateOrderStatus(String id, String newStatus, Color newColor) {
    _orders = _orders.map((order) {
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
    notifyListeners();
  }
}
