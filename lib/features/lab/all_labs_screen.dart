import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/utils/api_client.dart';
import '../../core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class AllLabsScreen extends StatefulWidget {
  const AllLabsScreen({super.key});

  @override
  State<AllLabsScreen> createState() => _AllLabsScreenState();
}

class _AllLabsScreenState extends State<AllLabsScreen> {
  List<dynamic> _allLabs = [];
  List<dynamic> _filteredLabs = [];
  bool _isLoading = true;
  String _selectedCity = 'All';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _cities = [
    'All',
    'Erbil',
    'Sulaymaniyah',
    'Duhok',
    'Halabja',
    'Kirkuk'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLabs();
  }

  Future<void> _fetchLabs() async {
    setState(() => _isLoading = true);
    try {
      // Typically, you'd fetch all approved labs from the backend
      final response = await ApiClient.get('/admin/labs');
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> labs = jsonDecode(response.body);
        setState(() {
          _allLabs = labs.where((l) => l['status'] == 'approved').toList();
          
          // Mock data if API is empty for better UI demonstration
          if (_allLabs.isEmpty) {
            _allLabs = [
              {'id': 1, 'name': 'تاقیگەی ناوەندی هەولێر', 'city': 'Erbil', 'phone': '0750 123 4567', 'type': 'گشتی'},
              {'id': 2, 'name': 'تاقیگەی سلێمانی نموونەیی', 'city': 'Sulaymaniyah', 'phone': '0770 123 4567', 'type': 'تایبەت'},
              {'id': 3, 'name': 'تاقیگەی دهۆک', 'city': 'Duhok', 'phone': '0751 123 4567', 'type': 'گشتی'},
              {'id': 4, 'name': 'تاقیگەی کەرکوک مێدیکا', 'city': 'Kirkuk', 'phone': '0771 123 4567', 'type': 'تایبەت'},
              {'id': 5, 'name': 'تاقیگەی هەڵەبجە', 'city': 'Halabja', 'phone': '0750 987 6543', 'type': 'گشتی'},
            ];
          }
          _filteredLabs = _allLabs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterLabs() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredLabs = _allLabs.where((lab) {
        final nameMatches = lab['name']?.toString().toLowerCase().contains(query) ?? false;
        final cityMatches = _selectedCity == 'All' || lab['city'] == _selectedCity;
        return nameMatches && cityMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchAndFilter(),
                const SizedBox(height: 20),
                if (_isLoading)
                  const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                    ),
                  )
                else if (_filteredLabs.isEmpty)
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.search_normal_1, size: 48, color: Color(0xFFCBD5E1)),
                          const SizedBox(height: 16),
                          Text(
                            'هیچ تاقیگەیەک نەدۆزرایەوە',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredLabs.length,
                    itemBuilder: (context, index) {
                      return _buildLabCard(_filteredLabs[index], index);
                    },
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: const Color(0xFF3B82F6),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تاقیگە پزیشکییەکان',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'باشترین تاقیگەکان لە هەموو شارەکانی کوردستان',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Iconsax.search_normal, color: Color(0xFF94A3B8), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (value) => _filterLabs(),
                    style: const TextStyle(fontFamily: 'Rabar', fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'گەڕان بەدوای تاقیگە...',
                      hintStyle: TextStyle(fontFamily: 'Rabar', color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // City Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                final city = _cities[index];
                final isSelected = _selectedCity == city;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCity = city);
                    _filterLabs();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      city == 'All' ? 'هەمووی' : city,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabCard(dynamic lab, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Can navigate to lab details here
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Lab Logo Placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0F2FE)),
                  ),
                  child: const Center(
                    child: Icon(Iconsax.building_3, color: Color(0xFF3B82F6), size: 32),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Lab Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              lab['name'] ?? 'تاقیگە',
                              style: const TextStyle(
                                fontFamily: 'Rabar',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFF10B981), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '4.8',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF059669),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          const Icon(Iconsax.location, color: Color(0xFF94A3B8), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            lab['city'] ?? 'نەزانراو',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Iconsax.category, color: Color(0xFF94A3B8), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            lab['type'] ?? 'گشتی',
                            style: const TextStyle(
                              fontFamily: 'Rabar',
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Divider
                      Container(height: 1, color: const Color(0xFFF1F5F9)),
                      const SizedBox(height: 12),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.call, color: Color(0xFF3B82F6), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                lab['phone'] ?? '-',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B82F6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Color(0xFFCBD5E1), size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
  }
}
