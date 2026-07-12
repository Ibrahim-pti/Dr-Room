import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, String>> _favoriteDoctors = [];

  List<Map<String, String>> get favoriteDoctors => _favoriteDoctors;

  bool isFavorite(String doctorName) {
    return _favoriteDoctors.any((doc) => doc['doctor'] == doctorName);
  }

  void toggleFavorite(Map<String, String> doctor) {
    final index = _favoriteDoctors.indexWhere((doc) => doc['doctor'] == doctor['doctor']);
    if (index >= 0) {
      _favoriteDoctors.removeAt(index);
    } else {
      _favoriteDoctors.add(doctor);
    }
    notifyListeners();
  }
}
