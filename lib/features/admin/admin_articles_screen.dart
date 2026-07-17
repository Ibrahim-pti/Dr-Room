import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminArticlesScreen extends StatefulWidget {
  const AdminArticlesScreen({super.key});

  @override
  State<AdminArticlesScreen> createState() => _AdminArticlesScreenState();
}

class _AdminArticlesScreenState extends State<AdminArticlesScreen> {
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.get('/admin/articles');
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _articles = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteArticle(int id) async {
    try {
      final response = await ApiClient.delete('/admin/articles/$id');
      if (response.statusCode == 204) _fetchArticles();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _showAddArticleModal() async {
    File? selectedImage;
    final titleController = TextEditingController();
    final contentController = TextEditingController();

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
              child: SingleChildScrollView(
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
                      'Write New Article',
                      style: TextStyle(
                        color: const Color(0xFF1E293B),
                        fontFamily: 'Rabar', fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDarkInput(controller: titleController, hint: 'Article Title'),
                    const SizedBox(height: 12),
                    _buildDarkInput(controller: contentController, hint: 'Article Content', maxLines: 5),
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
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedImage != null
                                ? const Color(0xFF10B981)
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
                                  const Icon(Iconsax.add_circle, color: Color(0xFF10B981), size: 30),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add cover image (optional)',
                                    style: TextStyle(color: const Color(0xFF64748B), fontFamily: 'Rabar', fontSize: 13),
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
                          if (titleController.text.isEmpty || contentController.text.isEmpty) return;
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('auth_token');
                          var request = http.MultipartRequest(
                            'POST',
                            Uri.parse('${ApiClient.baseUrl}/admin/articles'),
                          );
                          request.headers['Authorization'] = 'Bearer $token';
                          request.headers['Accept'] = 'application/json';
                          request.fields['title'] = titleController.text;
                          request.fields['content'] = contentController.text;
                          if (selectedImage != null) {
                            request.files.add(
                              await http.MultipartFile.fromPath('image', selectedImage!.path),
                            );
                          }
                          var res = await request.send();
                          if (res.statusCode == 201) {
                            Navigator.pop(ctx);
                            _fetchArticles();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Publish Article',
                          style: TextStyle(fontFamily: 'Rabar', fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDarkInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: const Color(0xFF1E293B), fontFamily: 'Rabar', fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
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
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Iconsax.book_1, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وتارەکان',
                      style: TextStyle(
                        color: const Color(0xFF1E293B),
                        fontFamily: 'Rabar', fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_articles.length} published',
                      style: TextStyle(color: const Color(0xFF64748B), fontFamily: 'Rabar', fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _showAddArticleModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Write',
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
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
                : _articles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.book, color: Color(0xFFE2E8F0), size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'No articles yet',
                              style: TextStyle(color: const Color(0xFF64748B), fontFamily: 'Rabar', fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchArticles,
                        color: const Color(0xFF10B981),
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                          itemCount: _articles.length,
                          itemBuilder: (context, index) {
                            final article = _articles[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (article['image_path'] != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.network(
                                        'http://127.0.0.1:8000/storage/${article['image_path']}',
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => const SizedBox.shrink(),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                article['title'] ?? 'No Title',
                                                style: TextStyle(
                                                  color: const Color(0xFF1E293B),
                                                  fontFamily: 'Rabar', fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                article['content'] ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: const Color(0xFF64748B),
                                                  fontFamily: 'Rabar', fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () => _deleteArticle(article['id']),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(Iconsax.trash, color: Color(0xFFEF4444), size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animate(delay: Duration(milliseconds: index * 70)).fadeIn().slideY(begin: 0.08, end: 0);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
