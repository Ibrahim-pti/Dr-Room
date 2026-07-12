import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isProcessing = false;

  String get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isProcessing => _isProcessing;

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<bool> processPayment() async {
    _isProcessing = true;
    notifyListeners();

    // Simulate network latency for payment processing
    await Future.delayed(const Duration(seconds: 2));

    _isProcessing = false;
    notifyListeners();
    
    // Return true assuming payment is successful
    return true;
  }
}
