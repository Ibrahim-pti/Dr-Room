import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/utils/api_client.dart';
import 'emergency_reel_item.dart';

class EmergencyReelsScreen extends StatefulWidget {
  const EmergencyReelsScreen({super.key});

  @override
  State<EmergencyReelsScreen> createState() => _EmergencyReelsScreenState();
}

class _EmergencyReelsScreenState extends State<EmergencyReelsScreen> {
  final PageController _pageController = PageController();
  List<dynamic> _reels = [];
  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchReels();
  }

  Future<void> _fetchReels() async {
    try {
      final response = await ApiClient.get('/emergency-reels');
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _reels = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching reels: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_reels.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No emergency reels available.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return EmergencyReelItem(
            reelData: _reels[index],
            isActive: index == _currentPage,
          );
        },
      ),
    );
  }
}
