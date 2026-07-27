import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/utils/api_client.dart';
import '../doctors/doctor_details_screen.dart';
import '../pharmacy/screens/pharmacy_detail_screen.dart';
import '../pharmacy/models/pharmacy_model.dart';
import '../lab/lab_details_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  
  List<dynamic> _doctors = [];
  List<dynamic> _pharmacies = [];
  List<dynamic> _medications = [];
  List<dynamic> _labs = [];
  
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Doctors', 'Pharmacies', 'Medications', 'Labs'];

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty) {
      setState(() {
        _doctors = [];
        _pharmacies = [];
        _medications = [];
        _labs = [];
        _isLoading = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.get('/global-search?q=$query');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _doctors = data['data']['doctors'] ?? [];
            _pharmacies = data['data']['pharmacies'] ?? [];
            _medications = data['data']['medications'] ?? [];
            _labs = data['data']['labs'] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search doctors, pharmacies, labs...',
              hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.grey, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategory = category),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchController.text.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.search_status, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Text('What are you looking for?', style: GoogleFonts.inter(color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if ((_selectedCategory == 'All' || _selectedCategory == 'Doctors') && _doctors.isNotEmpty) ...[
                            _buildSectionHeader('Doctors'),
                            ..._doctors.map((d) => _buildResultItem(
                              title: d['name'] ?? '',
                              subtitle: d['specialization'] ?? '',
                              imageUrl: d['image'],
                              icon: Iconsax.user,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetailsScreen(
                                  doctorId: d['id'],
                                  name: d['name'] ?? '',
                                  specialty: d['specialization'] ?? '',
                                  image: d['image'] ?? 'assets/images/doctor1.png',
                                )));
                              },
                            )),
                            const SizedBox(height: 16),
                          ],
                          
                          if ((_selectedCategory == 'All' || _selectedCategory == 'Pharmacies') && _pharmacies.isNotEmpty) ...[
                            _buildSectionHeader('Pharmacies'),
                            ..._pharmacies.map((p) => _buildResultItem(
                              title: p['name'] ?? '',
                              subtitle: p['address'] ?? 'Pharmacy',
                              imageUrl: p['image'],
                              icon: Iconsax.shop,
                              onTap: () {
                                final pharmacyModel = Pharmacy(
                                  id: p['id'],
                                  name: p['name'] ?? '',
                                  profileImage: p['image'] != null ? 'http://127.0.0.1:8000/storage/${p['image']}' : 'https://ui-avatars.com/api/?name=${p['name']}',
                                  rating: p['rating']?.toDouble() ?? 5.0,
                                  isOpen: p['is_open'] == 1,
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyDetailScreen(pharmacy: pharmacyModel)));
                              },
                            )),
                            const SizedBox(height: 16),
                          ],

                          if ((_selectedCategory == 'All' || _selectedCategory == 'Labs') && _labs.isNotEmpty) ...[
                            _buildSectionHeader('Laboratories'),
                            ..._labs.map((l) => _buildResultItem(
                              title: l['name'] ?? '',
                              subtitle: l['address'] ?? 'Lab',
                              imageUrl: l['image'],
                              icon: Iconsax.health,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LabDetailsScreen(lab: l)));
                              },
                            )),
                            const SizedBox(height: 16),
                          ],

                          if ((_selectedCategory == 'All' || _selectedCategory == 'Medications') && _medications.isNotEmpty) ...[
                            _buildSectionHeader('Medications'),
                            ..._medications.map((m) => _buildResultItem(
                              title: m['name'] ?? '',
                              subtitle: m['pharmacy']?['name'] ?? 'Available in pharmacy',
                              imageUrl: m['image'],
                              icon: Iconsax.box,
                              onTap: () {
                                if (m['pharmacy_id'] != null) {
                                   // Create dummy pharmacy model to navigate to it, ideally we want to go straight to medicine detail or add to cart
                                   // Since we don't have Medicine Detail screen right now, we can just navigate to the pharmacy that has it.
                                   final pharmacyModel = Pharmacy(
                                      id: m['pharmacy_id'],
                                      name: m['pharmacy']?['name'] ?? '',
                                      profileImage: 'https://ui-avatars.com/api/?name=${m['pharmacy']?['name'] ?? 'P'}',
                                      rating: 5.0,
                                      isOpen: true,
                                    );
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyDetailScreen(pharmacy: pharmacyModel)));
                                }
                              },
                            )),
                            const SizedBox(height: 16),
                          ],

                          if (_doctors.isEmpty && _pharmacies.isEmpty && _labs.isEmpty && _medications.isEmpty)
                             Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Column(
                                    children: [
                                      Icon(Iconsax.search_favorite, size: 48, color: Colors.grey.withValues(alpha: 0.3)),
                                      const SizedBox(height: 16),
                                      Text('No results found', style: GoogleFonts.inter(color: Colors.grey, fontSize: 16)),
                                    ],
                                  ),
                                ),
                             ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildResultItem({
    required String title,
    required String subtitle,
    String? imageUrl,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl.startsWith('http') ? imageUrl : 'http://127.0.0.1:8000/storage/$imageUrl'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null ? Icon(icon, color: Colors.grey) : null,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}
