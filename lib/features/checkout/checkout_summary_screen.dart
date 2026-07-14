import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'order_success_screen.dart';
import '../../core/providers/order_provider.dart';
import '../../core/providers/checkout_provider.dart';

class CheckoutSummaryScreen extends StatefulWidget {
  const CheckoutSummaryScreen({super.key});

  @override
  State<CheckoutSummaryScreen> createState() => _CheckoutSummaryScreenState();
}

class _CheckoutSummaryScreenState extends State<CheckoutSummaryScreen> {
  int _selectedPaymentMethod = 0; // 0 for Cash, 1 for Card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Summary & Payment',
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 16),

                  // ── Summary Card ──
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Selected Service', 'Lab Tests', false),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Tests Included', 'CBC, Vitamin D', false),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Subtotal', '\$55.00', false),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Home Visit Fee', '\$10.00', false),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                        ),
                        _buildSummaryRow('Total', '\$65.00', true),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 40),

                  // ── Payment Methods ──
                  Text(
                    'Selected Payment Method',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 16),
                  
                  Consumer<CheckoutProvider>(
                    builder: (context, checkoutProvider, child) {
                      return _buildPaymentMethod(
                        index: 0,
                        title: checkoutProvider.selectedPaymentMethod,
                        subtitle: 'Will be used for this transaction',
                        icon: checkoutProvider.selectedPaymentMethod == 'Cash on Delivery' ? Iconsax.money : Iconsax.card,
                        color: checkoutProvider.selectedPaymentMethod == 'Cash on Delivery' ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        delay: 300,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // ── Bottom Container ──
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              border: Border.all(color: AppColors.getBorder(context)),
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(32),
                topEnd: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Consumer<CheckoutProvider>(
                  builder: (context, checkoutProvider, child) {
                    return ElevatedButton(
                      onPressed: checkoutProvider.isProcessing ? null : () async {
                        // Process Payment
                        final success = await checkoutProvider.processPayment();
                        
                        if (success && context.mounted) {
                          // Add to OrderProvider
                          await context.read<OrderProvider>().addOrder(OrderModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: 'Complete Blood Count (CBC)', // Example title based on \$65 total
                            status: 'Pending',
                            statusColor: const Color(0xFFF59E0B),
                            icon: Iconsax.health,
                            iconColor: const Color(0xFF3B82F6),
                            price: 65.00,
                            date: DateTime.now(),
                          ));
                          
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrderSuccessScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        disabledBackgroundColor: const Color(0xFF3B82F6).withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: checkoutProvider.isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Confirm Order - \$65.00',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isTotal ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isTotal ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextSubtitle(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14, color: AppColors.getSurface(context))
                  : null,
            ),
          ],
        ),
      ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1, end: 0),
    );
  }
}
