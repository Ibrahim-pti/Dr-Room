import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/providers/admin_order_provider.dart';
import 'admin_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AdminOrderProvider>();
      provider.fetchOrders();
      provider.fetchNurses();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AdminAppBar(
        title: 'داواکارییەکان',
        subtitle: 'بەڕێوەبردنی ئۆردەرەکانی نەخۆش',
        icon: Iconsax.document,
        iconColor: const Color(0xFF3B82F6),
        iconBackgroundColor: const Color(0xFFEFF6FF),
      ),
      body: Consumer<AdminOrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.orders.isEmpty) {
            return Center(child: Text(provider.error!));
          }

          final pendingOrders = provider.orders
              .where((o) => o['status'] == 'pending')
              .toList();
          final processingOrders = provider.orders
              .where((o) => o['status'] == 'processing')
              .toList();
          final completedOrders = provider.orders
              .where((o) =>
                  o['status'] == 'completed' || o['status'] == 'cancelled')
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'نوێ (${pendingOrders.length})'),
                      Tab(text: 'لە جێبەجێکردن (${processingOrders.length})'),
                      Tab(text: 'تەواوبوو (${completedOrders.length})'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrderList(pendingOrders, provider, isPending: true),
                    _buildOrderList(processingOrders, provider, isPending: false),
                    _buildOrderList(completedOrders, provider, isPending: false),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<dynamic> orders, AdminOrderProvider provider,
      {required bool isPending}) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'هیچ داواکارییەک نییە',
          style: TextStyle(
            fontFamily: 'Rabar',
            fontSize: 16,
            color: Color(0xFF94A3B8),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.fetchOrders,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, provider, isPending)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 100 * index))
              .slideX(begin: 0.05, end: 0);
        },
      ),
    );
  }

  Widget _buildOrderCard(
      dynamic order, AdminOrderProvider provider, bool isPending) {
    final serviceType = order['service_type'] ?? 'Unknown';
    final patientDetails = order['patient_details'] ?? {};
    final patientName = patientDetails['name'] ?? 'نەخۆش';
    final locationDetails = order['location_details'] ?? {};
    final address = locationDetails['address'] ?? 'ناونیشان نەزانراوە';
    final totalPrice = order['total_price'] ?? 0;
    final items = order['items'] as List? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  serviceType,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '\$$totalPrice',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Iconsax.user, size: 18, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                patientName,
                style: const TextStyle(
                  fontFamily: 'Rabar',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Iconsax.location, size: 18, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isNotEmpty) ...[
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 8),
            const Text(
              'خزمەتگوزارییەکان:',
              style: TextStyle(
                fontFamily: 'Rabar',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            ...items.map((item) {
              return Text(
                '- ${item['item_name']}',
                style: const TextStyle(
                  fontFamily: 'Rabar',
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
          if (isPending)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => _showAssignDialog(context, order, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'دیاریکردنی پەرستار',
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else if (order['status'] == 'processing')
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => provider.updateStatus(order['id'], 'completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'تەواوکردن',
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  void _showAssignDialog(
      BuildContext context, dynamic order, AdminOrderProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(
              'دیاریکردنی پەرستار',
              style: TextStyle(
                fontFamily: 'Rabar',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: provider.nurses.isEmpty
                ? const Text(
                    'هیچ پەرستارێک نەدۆزرایەوە',
                    style: TextStyle(fontFamily: 'Rabar'),
                  )
                : SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.nurses.length,
                      itemBuilder: (context, index) {
                        final nurse = provider.nurses[index];
                        return ListTile(
                          title: Text(
                            nurse['name'] ?? '',
                            style: const TextStyle(fontFamily: 'Rabar'),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            final success = await provider.assignNurse(
                                order['id'], nurse['id']);
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('پەرستار بەسەرکەوتوویی دیاریکرا')),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'داخستن',
                  style: TextStyle(fontFamily: 'Rabar', color: Colors.grey),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}
