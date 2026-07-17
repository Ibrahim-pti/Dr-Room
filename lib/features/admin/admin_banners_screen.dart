import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminBannersScreen extends StatefulWidget {
  const AdminBannersScreen({super.key});

  @override
  State<AdminBannersScreen> createState() => _AdminBannersScreenState();
}

class _AdminBannersScreenState extends State<AdminBannersScreen> {
  List<dynamic> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.get('/admin/banners');
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _banners = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBanner(int id) async {
    try {
      final response = await ApiClient.delete('/admin/banners/$id');
      if (response.statusCode == 204) _fetchBanners();
    } catch (e) {
      debugPrint('Error deleting banner: $e');
    }
  }

  Future<void> _showAddBannerModal() async {
    File? selectedImage;
    final titleController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Add New Banner',
                    style: TextStyle(
                      color: const Color(0xFF1E293B),
                      fontFamily: 'Rabar', fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: titleController,
                      style: TextStyle(color: const Color(0xFF1E293B), fontFamily: 'Rabar', fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Banner Title (Optional)',
                        hintStyle: TextStyle(color: const Color(0xFF64748B)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final xfile = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                        maxWidth: 1000,
                      );
                      if (xfile != null) {
                        setModalState(() => selectedImage = File(xfile.path));
                      }
                    },
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedImage != null
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(selectedImage!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Iconsax.add_circle, size: 32, color: Color(0xFF3B82F6)),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Tap to select image',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontFamily: 'Rabar', fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedImage == null) return;
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('auth_token');
                        var request = http.MultipartRequest(
                          'POST',
                          Uri.parse('${ApiClient.baseUrl}/admin/banners'),
                        );
                        request.headers['Authorization'] = 'Bearer $token';
                        request.headers['Accept'] = 'application/json';
                        request.fields['title'] = titleController.text;
                        request.files.add(
                          await http.MultipartFile.fromPath('image', selectedImage!.path),
                        );
                        var res = await request.send();
                        if (res.statusCode == 201) {
                          Navigator.pop(ctx);
                          _fetchBanners();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Upload Banner',
                        style: TextStyle(fontFamily: 'Rabar', fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Iconsax.picture_frame, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ڕیکلامەکان',
                      style: TextStyle(
                        color: const Color(0xFF1E293B),
                        fontFamily: 'Rabar', fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_banners.length} active',
                      style: TextStyle(color: const Color(0xFF64748B), fontFamily: 'Rabar', fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _showAddBannerModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: const Color(0xFF1E293B),
                            fontFamily: 'Rabar', fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)))
                : _banners.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.picture_frame, color: Color(0xFFE2E8F0), size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'No banners yet',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontFamily: 'Rabar', fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchBanners,
                        color: const Color(0xFF3B82F6),
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                          itemCount: _banners.length,
                          itemBuilder: (context, index) {
                            final banner = _banners[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                children: [
                                  if (banner['image_path'] != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.network(
                                        'http://127.0.0.1:8000/storage/${banner['image_path']}',
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          height: 160,
                                          color: const Color(0xFFF8FAFC),
                                          child: const Center(
                                            child: Icon(Icons.image_not_supported, color: Color(0xFFE2E8F0), size: 40),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            banner['title'] ?? 'No Title',
                                            style: TextStyle(
                                              color: const Color(0xFF1E293B),
                                              fontFamily: 'Rabar', fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _deleteBanner(banner['id']),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Iconsax.trash,
                                              color: Color(0xFFEF4444),
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animate(delay: Duration(milliseconds: index * 80)).fadeIn().slideY(begin: 0.1, end: 0);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
