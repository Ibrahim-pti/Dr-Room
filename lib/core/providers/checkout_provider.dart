import 'package:flutter/material.dart';
import 'package:dr_room/core/utils/api_client.dart';
import 'dart:convert';
import 'cart_provider.dart';

class CheckoutProvider extends ChangeNotifier {
  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isProcessing = false;

  String get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isProcessing => _isProcessing;

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<bool> processPayment(CartProvider cart) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final payload = {
        'service_type': cart.serviceType ?? 'General',
        'subtotal': cart.subtotal,
        'extra_fee': cart.extraFee,
        'total_price': cart.total,
        'payment_method': _selectedPaymentMethod,
        'patient_details': cart.patientDetails ?? {},
        'items': cart.items.map((e) => e.toJson()).toList(),
      };

      final response = await ApiClient.post('/orders', body: payload);
      
      _isProcessing = false;
      notifyListeners();

      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Checkout Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Checkout Error: $e');
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
