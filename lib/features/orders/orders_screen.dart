import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'In Transit', 'Pending', 'Completed'];

  final List<Map<String, dynamic>> _orders = [
    {
      'title': 'Complete Blood Count (CBC)',
      'status': 'In Transit',
      'statusColor': const Color(0xFF3B82F6),
      'icon': Iconsax.health,
      'iconColor': const Color(0xFF3B82F6),
      'price': '\$15.00',
      'date': 'Today, 10:30 AM',
    },
    {
      'title': 'Video Consultation',
      'status': 'Pending',
      'statusColor': const Color(0xFFF59E0B),
      'icon': Iconsax.video,
      'iconColor': const Color(0xFFF59E0B),
      'price': '\$20.00',
      'date': 'Tomorrow, 2:00 PM',
    },
    {
      'title': 'Pharmacy Delivery',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981),
      'icon': Iconsax.box_1,
      'iconColor': const Color(0xFF10B981),
      'price': '\$12.50',
      'date': 'Yesterday, 6:45 PM',
    },
    {
      'title': 'Nursing Home Visit',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981),
      'icon': Iconsax.hospital,
      'iconColor': const Color(0xFFEF4444),
      'price': '\$25.00',
      'date': '3 days ago',
    },
    {
      'title': 'Chest X-Ray',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981),
      'icon': Iconsax.scan,
      'iconColor': const Color(0xFF8B5CF6),
      'price': '\$45.00',
      'date': 'Last week',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hidden back button for main shell
        title: Text(
          'My Orders',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          
          // ── Filter Tabs ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(
                _filters.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedFilterIndex == index
                            ? const Color(0xFF3B82F6)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedFilterIndex == index
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        boxShadow: _selectedFilterIndex == index
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        _filters[index],
                        style: GoogleFonts.poppins(
                          color: _selectedFilterIndex == index
                              ? Colors.white
                              : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: _selectedFilterIndex == index ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, end: 0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Orders List ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                
                // Simple filtering logic
                if (_selectedFilterIndex != 0) {
                  if (_filters[_selectedFilterIndex] != order['status']) {
                    return const SizedBox.shrink();
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: (order['iconColor'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            order['icon'] as IconData,
                            color: order['iconColor'] as Color,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['title'] as String,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF0F172A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (order['statusColor'] as Color).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      order['status'] as String,
                                      style: GoogleFonts.poppins(
                                        color: order['statusColor'] as Color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      order['date'] as String,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              order['price'] as String,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF3B82F6),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF94A3B8),
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate(delay: (100 * index).ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                );
              },
            ),
          ),
          
          // Extra space at bottom to ensure it clears the floating bottom nav bar
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
