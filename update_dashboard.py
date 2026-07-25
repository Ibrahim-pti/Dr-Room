import re

with open('lib/features/admin/admin_dashboard_screen.dart', 'r') as f:
    content = f.read()

# Replace imports
content = re.sub(r"import 'admin_banners_screen\.dart';\nimport 'admin_articles_screen\.dart';\nimport 'admin_notifications_screen\.dart';\nimport 'admin_appointments_screen\.dart';", 
                 "import 'admin_notifications_screen.dart';\nimport 'admin_app_bar.dart';", content)

# Replace build
build_match = re.search(r'  Widget build\(BuildContext context\) \{[\s\S]*?    \);\n  \}', content)
new_build = """  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AdminAppBar(
        title: 'پەنێڵی ئەدمین',
        subtitle: 'بەڕێوەبردنی سیستم',
        icon: Icons.dashboard_rounded,
        iconColor: Colors.white,
        iconBackgroundColor: const Color(0xFF3B82F6),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Directionality(
                    textDirection: TextDirection.rtl,
                    child: AdminNotificationsScreen(),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Iconsax.notification,
                color: Color(0xFF1E293B),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchStats,
        color: const Color(0xFF3B82F6),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                _buildLoadingShimmer()
              else ...[
                // ── Stats Grid ──
                _buildStatsGrid(),
                const SizedBox(height: 28),

                // ── Recent Appointments ──
                _buildRecentAppointments(),
              ],
            ],
          ),
        ),
      ),
    );
  }"""
if build_match:
    content = content[:build_match.start()] + new_build + content[build_match.end():]

# Remove _buildHeader
header_match = re.search(r'  Widget _buildHeader\(\) \{[\s\S]*?\.animate\(\)\.fadeIn\(duration: 400\.ms\)\.slideY\(begin: -0\.1, end: 0\);\n  \}\n\n', content)
if header_match:
    content = content[:header_match.start()] + content[header_match.end():]

# Remove _buildAppManagement
app_mgmt_match = re.search(r'  Widget _buildAppManagement\(\) \{[\s\S]*?  Widget _buildStatCard', content)
if app_mgmt_match:
    content = content[:app_mgmt_match.start()] + "  Widget _buildStatCard" + content[app_mgmt_match.end():]

with open('lib/features/admin/admin_dashboard_screen.dart', 'w') as f:
    f.write(content)
