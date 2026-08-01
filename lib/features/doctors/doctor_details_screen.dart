import 'dart:convert';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/providers/favorite_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dr_room_fonts.dart';
import '../../core/utils/api_client.dart';
import '../../main.dart';
import 'doctor_reviews_screen.dart';

/// Sweeps the bottom edge of the hero photo into a soft arc that dips lower in
/// the middle than at the sides.
class _HeroCurveClipper extends CustomClipper<Path> {
  const _HeroCurveClipper();

  /// How far above the bottom the two side edges stop.
  static const double _sideInset = 58;

  /// Rounds off the three points of the V, so it reads as a soft chevron
  /// rather than a shape with knife edges.
  static const double _sideCorner = 22;
  static const double _tipCorner = 28;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final edge = h - _sideInset;
    final mid = w / 2;

    // Pull back from the tip along each diagonal by _tipCorner, then round the
    // gap between the two points.
    final slope = Offset(mid, h - edge);
    final length = slope.distance;
    final backX = mid * (_tipCorner / length);
    final backY = (h - edge) * (_tipCorner / length);

    return Path()
      ..lineTo(0, edge - _sideCorner)
      ..quadraticBezierTo(0, edge, _sideCorner, edge + _sideCorner * 0.35)
      ..lineTo(mid - backX, h - backY)
      ..quadraticBezierTo(mid, h, mid + backX, h - backY)
      ..lineTo(w - _sideCorner, edge + _sideCorner * 0.35)
      ..quadraticBezierTo(w, edge, w, edge - _sideCorner)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// One appointment time, exactly as the server generated it.
class _Slot {
  final DateTime dateTime;
  final bool taken;

  const _Slot({required this.dateTime, required this.taken});
}

/// One bookable day. The server decides which days and slots exist — the app
/// never derives its own grid, so the two can't drift apart.
class _BookableDay {
  final DateTime date;
  final List<_Slot> slots;

  const _BookableDay({required this.date, required this.slots});

  static _BookableDay? fromJson(Map<String, dynamic> json) {
    final date = DateTime.tryParse(json['date']?.toString() ?? '');
    if (date == null) return null;

    final slots = <_Slot>[];
    for (final raw in (json['slots'] as List?) ?? const []) {
      final parts = raw['time'].toString().split(':');
      if (parts.length < 2) continue;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;

      slots.add(
        _Slot(
          dateTime: DateTime(date.year, date.month, date.day, hour, minute),
          taken: raw['taken'] == true,
        ),
      );
    }
    return _BookableDay(date: date, slots: slots);
  }
}

class DoctorDetailsScreen extends StatefulWidget {
  final int doctorId;
  final String name;
  final String specialty;
  final String image;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
    required this.name,
    required this.specialty,
    required this.image,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  static const double _carouselHeight = 258;
  // Carousel (which absorbs the status bar) + name + specialty pills.
  static const double _heroHeight = _carouselHeight + 80;

  Map<String, dynamic>? _doctor;
  List<dynamic> _services = [];
  List<_BookableDay> _days = [];
  bool _slotsLoading = true;

  bool _loading = true;
  bool _loadFailed = false;
  bool _hasFreshData = false;
  bool _isBooking = false;
  bool _bioExpanded = false;
  bool _videoStarted = false;

  int? _selectedServiceId;
  int _dayIndex = 0;
  int _timeIndex = -1;
  int _heroPage = 0;

  final _scrollController = ScrollController();
  final _scheduleKey = GlobalKey();
  final _heroPageController = PageController();

  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _loadCached();
    _fetchDoctor();
    _fetchAvailability();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroPageController.dispose();
    _videoController?.dispose();
    _youtubeController?.close();
    super.dispose();
  }

  // ─────────────────────────── data ───────────────────────────

  Future<void> _loadCached() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_doctor_details_${widget.doctorId}');
      // The network call runs in parallel; if it already won, the cache is
      // stale and applying it would flip the screen back to older data.
      if (cached == null || cached.isEmpty || !mounted || _hasFreshData) return;
      _applyDoctor(jsonDecode(cached));
    } catch (_) {
      // A bad cache entry is not worth surfacing — the network call follows.
    }
  }

  Future<void> _fetchDoctor() async {
    try {
      final response = await ApiClient.get('/doctors/${widget.doctorId}');
      if (response.statusCode == 200) {
        _hasFreshData = true;
        if (mounted) _applyDoctor(jsonDecode(response.body));

        // Painting comes first; writing the cache can finish afterwards.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'cached_doctor_details_${widget.doctorId}',
          response.body,
        );
        return;
      }
    } catch (_) {
      // Fall through to the failure state below.
    }
    if (mounted && _doctor == null) {
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  void _applyDoctor(Map<String, dynamic> data) {
    setState(() {
      _doctor = data;
      _loading = false;
      _loadFailed = false;
      _services = (data['services'] as List?) ?? const [];
      _selectedServiceId ??= _services.isNotEmpty ? _asInt(_services.first['id']) : null;
    });
    _startVideo();
  }

  /// The server owns slot generation — it knows the doctor's slot length and
  /// which times are already booked, neither of which the app can infer.
  Future<void> _fetchAvailability() async {
    try {
      final response =
          await ApiClient.get('/doctors/${widget.doctorId}/availability');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final days = <_BookableDay>[];
        for (final raw in (data['days'] as List?) ?? const []) {
          final day = _BookableDay.fromJson(Map<String, dynamic>.from(raw));
          if (day != null) days.add(day);
        }
        if (!mounted) return;
        setState(() {
          _days = days;
          _slotsLoading = false;
          if (_dayIndex >= _days.length) _dayIndex = 0;
          _timeIndex = -1;
        });
        return;
      }
    } catch (_) {
      // Falls through — the schedule section shows its empty state.
    }
    if (mounted) setState(() => _slotsLoading = false);
  }

  List<_Slot> get _slots =>
      _days.isEmpty || _dayIndex >= _days.length ? const [] : _days[_dayIndex].slots;

  // ─────────────────────── value helpers ───────────────────────

  static int? _asInt(dynamic v) => v == null ? null : int.tryParse(v.toString());

  static double _asDouble(dynamic v) =>
      v == null ? 0 : double.tryParse(v.toString()) ?? 0;

  String get _doctorName =>
      _doctor?['user']?['name']?.toString() ?? widget.name;

  String get _doctorSpecialty {
    final locale = context.locale.languageCode;
    final localized = _doctor?['specialty_$locale']?.toString();
    if (localized != null && localized.isNotEmpty) return localized;
    final fallback = _doctor?['specialty']?.toString();
    if (fallback != null && fallback.isNotEmpty) return fallback;
    return widget.specialty;
  }

  String get _doctorImage {
    final path = _doctor?['image_path']?.toString();
    if (path != null && path.isNotEmpty) return ApiClient.getImageUrl(path);
    return widget.image;
  }

  /// Profile photo first, then any gallery images the API sends back.
  List<String> get _heroImages {
    final images = <String>{};
    if (_doctorImage.isNotEmpty) images.add(_doctorImage);
    for (final item in (_doctor?['gallery'] as List?) ?? const []) {
      final path = item.toString();
      if (path.isNotEmpty) images.add(ApiClient.getImageUrl(path));
    }
    return images.isEmpty ? [widget.image] : images.toList();
  }

  /// Service names are stored per-language; fall back through the other
  /// columns so a card never renders as an empty box.
  String _serviceName(Map service) {
    final locale = context.locale.languageCode;
    for (final key in ['name_$locale', 'name_ckb', 'name_en', 'name_ar', 'name']) {
      final value = service[key]?.toString();
      if (value != null && value.trim().isNotEmpty) return value;
    }
    return 'dd_service'.tr();
  }

  String _money(double price) {
    if (price <= 0) return 'free'.tr();
    return '${NumberFormat('#,###').format(price)} ${'dd_currency'.tr()}';
  }

  Map<String, dynamic>? get _selectedService {
    if (_selectedServiceId == null) return null;
    for (final s in _services) {
      if (_asInt(s['id']) == _selectedServiceId) {
        return Map<String, dynamic>.from(s as Map);
      }
    }
    return null;
  }

  double get _selectedPrice {
    final service = _selectedService;
    if (service != null) return _asDouble(service['price']);
    return _asDouble(_doctor?['consultation_fee']);
  }

  DateTime? get _selectedDateTime => _timeIndex >= 0 && _timeIndex < _slots.length
      ? _slots[_timeIndex].dateTime
      : null;

  ImageProvider _imageProvider(String path) {
    if (path.isEmpty) return const AssetImage('assets/images/doctor.png');
    if (path.startsWith('assets/')) return AssetImage(path);
    if (path.startsWith('http')) return NetworkImage(path);
    return NetworkImage(ApiClient.getImageUrl(path));
  }

  // intl ships no date symbols for Kurdish, so day and month names come from
  // the translation files instead of DateFormat.
  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return 'dd_today'.tr();
    if (diff == 1) return 'dd_tomorrow'.tr();
    return _weekdayName(date);
  }

  String _weekdayName(DateTime date) => 'wd_${date.weekday}'.tr();

  String _monthName(DateTime date) => 'mo_${date.month}'.tr();

  String _fullDate(DateTime date) =>
      '${_weekdayName(date)} • ${date.day} ${_monthName(date)} ${date.year}';

  String _clock(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'am'.tr() : 'pm'.tr();
    return '$hour:$minute $period';
  }

  // ───────────────────────── booking ─────────────────────────

  void _scrollToSchedule() {
    final ctx = _scheduleKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      alignment: 0.1,
    );
  }

  Future<void> _onBookPressed() async {
    if (_selectedDateTime == null) {
      _scrollToSchedule();
      _toast('dd_select_time_first'.tr(), AppColors.warning);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      _showLoginPrompt();
      return;
    }
    _showSummarySheet();
  }

  /// [refreshSheet] rebuilds the summary sheet, which lives on its own route
  /// and therefore does not react to this screen's setState.
  Future<void> _submitBooking(StateSetter refreshSheet) async {
    final slot = _selectedDateTime;
    if (slot == null) return;

    _isBooking = true;
    refreshSheet(() {});

    var booked = false;
    var slotGone = false;
    try {
      final body = <String, dynamic>{
        'doctor_id': widget.doctorId,
        'appointment_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(slot),
        'type': 'in_person',
        if (_selectedServiceId != null) 'service_id': _selectedServiceId,
      };

      final response = await ApiClient.post('/appointments', body: body);
      booked = response.statusCode == 200 || response.statusCode == 201;
      // 409: someone else took this slot between loading and confirming.
      slotGone = response.statusCode == 409;
    } catch (_) {
      booked = false;
    }

    if (!mounted) return;
    _isBooking = false;

    if (booked) {
      Navigator.pop(context); // close the summary sheet
      _toast('dd_booked'.tr(), AppColors.success);
      setState(() => _timeIndex = -1);
      _fetchAvailability();
    } else if (slotGone) {
      Navigator.pop(context);
      _toast('dd_slot_taken'.tr(), AppColors.warning);
      _fetchAvailability();
    } else {
      refreshSheet(() {});
      _toast('dd_book_failed'.tr(), AppColors.error);
    }
  }

  void _toast(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _callDoctor() async {
    final phone = _doctor?['phone']?.toString();
    if (phone == null || phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  // ───────────────────────── video ─────────────────────────

  String? get _videoUrl {
    final url = _doctor?['video_url']?.toString();
    return (url == null || url.isEmpty) ? null : url;
  }

  bool get _isYoutube {
    final url = _videoUrl;
    if (url == null) return false;
    return _doctor?['video_type'] == 'youtube' ||
        url.contains('youtube.com') ||
        url.contains('youtu.be');
  }

  String _youtubeId(String url) {
    if (url.contains('v=')) return url.split('v=')[1].split('&').first;
    if (url.contains('youtu.be/')) return url.split('youtu.be/')[1].split('?').first;
    if (url.contains('/embed/')) return url.split('/embed/')[1].split('?').first;
    return url;
  }

  /// Runs as soon as the doctor's data lands — the intro video autoplays.
  void _startVideo() {
    final url = _videoUrl;
    if (url == null || _videoStarted || !mounted) return;

    if (_isYoutube) {
      final id = _youtubeId(url);
      if (id.isEmpty) return;
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: id,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          showVideoAnnotations: false,
          strictRelatedVideos: true,
        ),
      );
    } else {
      final full = url.startsWith('http') ? url : ApiClient.getImageUrl(url);
      _videoController = VideoPlayerController.networkUrl(Uri.parse(full))
        ..initialize().then((_) {
          _videoController?.setLooping(true);
          _videoController?.play();
          if (mounted) setState(() {});
        }).catchError((_) {});
    }
    setState(() => _videoStarted = true);
  }

  // ───────────────────────── build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = AppColors.getBackground(context);

    return Scaffold(
      backgroundColor: background,
      body: _loadFailed && _doctor == null
          ? _buildErrorState()
          : CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHero(isDark),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _loading && _doctor == null
                          ? _buildSkeleton(isDark)
                          : _buildSections(isDark),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar:
          _doctor == null && _loading ? null : _buildBottomBar(isDark),
    );
  }

  List<Widget> _buildSections(bool isDark) {
    final sections = <Widget>[
      _buildAbout(isDark),
    ];

    if (_videoUrl != null) {
      sections
        ..add(const SizedBox(height: 22))
        ..add(_buildVideo(isDark));
    }

    sections
      ..add(const SizedBox(height: 24))
      ..add(_buildServices(isDark))
      ..add(const SizedBox(height: 24))
      ..add(_buildSchedule(isDark));

    // Last: once the slot is picked, "where do I go?" is the next question.
    final address = _doctor?['address']?.toString().trim() ?? '';
    final clinic = _doctor?['clinic_name']?.toString().trim() ?? '';
    if (_hasLocation || address.isNotEmpty || clinic.isNotEmpty) {
      sections
        ..add(const SizedBox(height: 24))
        ..add(_buildLocation(isDark));
    }

    return sections
        .animate(interval: 40.ms)
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOut);
  }

  // ── hero ──

  Widget _buildHero(bool isDark) {
    final topPadding = MediaQuery.of(context).padding.top;
    final background = AppColors.getBackground(context);

    return SliverAppBar(
      pinned: true,
      stretch: true,
      elevation: 0,
      expandedHeight: _heroHeight,
      backgroundColor: background,
      automaticallyImplyLeading: false,
      systemOverlayStyle: null,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = _heroHeight + topPadding;
          final minHeight = kToolbarHeight + topPadding;
          final t = ((maxHeight - constraints.maxHeight) /
                  (maxHeight - minHeight))
              .clamp(0.0, 1.0);

          // The photo runs under the status bar, so its icons have to be white
          // while it is on screen and flip back once the bar collapses.
          final overStatusBar = t < 0.5;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: overStatusBar || isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: background),
                // Expanded content fades out as the bar collapses.
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Opacity(
                    opacity: (1 - t * 1.6).clamp(0.0, 1.0),
                    child: _buildHeroContent(),
                  ),
                ),
                // Collapsed title fades in.
                Positioned(
                  left: 56,
                  right: 56,
                  top: topPadding,
                  height: kToolbarHeight,
                  child: Opacity(
                    opacity: ((t - 0.6) / 0.4).clamp(0.0, 1.0),
                    child: Center(
                      child: Text(
                        _doctorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextTitle(context),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding + 4,
                  left: 12,
                  right: 12,
                  child: _buildHeroActions(t, isDark),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroContent() {
    final rating = _asDouble(_doctor?['rating']);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeroCarousel(),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _doctorName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: AppColors.getTextTitle(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _heroPill(Iconsax.health, _doctorSpecialty),
            if (rating > 0) ...[
              const SizedBox(width: 8),
              _heroPill(
                Icons.star_rounded,
                rating.toStringAsFixed(1),
                iconColor: const Color(0xFFFBBF24),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Full-bleed swipeable strip of the doctor's photos. It reaches every screen
  /// edge and runs under the status bar, with only the bottom corners rounded.
  Widget _buildHeroCarousel() {
    final images = _heroImages;
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipPath(
      clipper: const _HeroCurveClipper(),
      child: SizedBox(
        height: topPadding + _carouselHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _heroPageController,
              itemCount: images.length,
              onPageChanged: (index) => setState(() => _heroPage = index),
              itemBuilder: (context, index) => Image(
                image: _imageProvider(images[index]),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.primary,
                  child: const Icon(Iconsax.user, color: Colors.white, size: 44),
                ),
              ),
            ),
            // Keeps the status bar icons and the floating back / favourite
            // buttons legible on light photos.
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.black.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.18, 0.4],
                  ),
                ),
              ),
            ),
            if (images.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 70,
                child: Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _heroPage,
                    count: images.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 3.5,
                      spacing: 5,
                      dotColor: Colors.white.withValues(alpha: 0.5),
                      activeDotColor: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _heroPill(IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor ?? AppColors.primary),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: AppColors.getTextTitle(context),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroActions(double t, bool isDark) {
    // White over the photo, switching to the normal text colour once the
    // photo has scrolled away.
    final fade = ((t - 0.5) / 0.5).clamp(0.0, 1.0);
    final iconColor =
        Color.lerp(Colors.white, AppColors.getTextTitle(context), fade)!;
    final chipColor = Color.lerp(
      Colors.black.withValues(alpha: 0.3),
      AppColors.getSurface(context),
      fade,
    )!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _heroIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          color: iconColor,
          background: chipColor,
          onTap: () => Navigator.pop(context),
        ),
        Consumer<FavoriteProvider>(
          builder: (context, favorites, _) {
            final isFavorite = favorites.isFavorite(widget.doctorId);
            return _heroIconButton(
              icon: isFavorite ? Icons.favorite_rounded : Iconsax.heart,
              color: isFavorite ? AppColors.error : iconColor,
              background: chipColor,
              onTap: () => favorites.toggleFavorite({
                'id': widget.doctorId,
                'doctor': _doctorName,
                'specialty': _doctorSpecialty,
                'image': _doctorImage,
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _heroIconButton({
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, size: 19, color: color),
        ),
      ),
    );
  }

  // ── stats ──

  /// Bare row — it lives inside the about card rather than in one of its own.
  Widget _buildStatsRow() {
    final rating = _asDouble(_doctor?['rating']);
    final reviews = _asInt(_doctor?['total_reviews']) ?? 0;
    final years = _asInt(_doctor?['experience_years']) ?? 0;
    final phone = _doctor?['phone']?.toString().trim() ?? '';

    // Always three columns — a card with a single centred stat reads as broken
    // when the doctor hasn't filled in their profile yet.
    final stats = <Widget>[
      // The rating column doubles as the entry point to the reviews screen.
      _stat(
        icon: Icons.star_rounded,
        color: const Color(0xFFF59E0B),
        value: rating > 0 ? rating.toStringAsFixed(1) : '—',
        label: '$reviews ${'dd_reviews'.tr()}',
        onTap: _openReviews,
      ),
      _stat(
        icon: Iconsax.medal_star,
        color: AppColors.primary,
        value: years > 0 ? '$years' : '—',
        label: 'dd_years_exp'.tr(),
      ),
      // Tapping dials — a number you can't call is just decoration.
      _stat(
        icon: Iconsax.call,
        color: AppColors.success,
        value: phone.isNotEmpty ? phone : '—',
        valueSize: 12.5,
        label: 'call'.tr(),
        onTap: phone.isNotEmpty ? _callDoctor : null,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0)
            Container(
              width: 1,
              height: 34,
              color: AppColors.getDivider(context),
            ),
          Expanded(child: stats[i]),
        ],
      ],
    );
  }

  Widget _stat({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    double valueSize = 15,
    VoidCallback? onTap,
  }) {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
          style: GoogleFonts.poppins(
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextTitle(context),
          ),
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: onTap != null
                      ? AppColors.primary
                      : AppColors.getTextSubtitle(context),
                  fontWeight: onTap != null ? FontWeight.w600 : null,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 14,
                color: AppColors.primary,
              ),
          ],
        ),
      ],
    );

    if (onTap == null) return column;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: column,
      ),
    );
  }

  // ── quick actions ──

  // ── location ──

  double? get _latitude => double.tryParse(_doctor?['latitude']?.toString() ?? '');
  double? get _longitude => double.tryParse(_doctor?['longitude']?.toString() ?? '');
  bool get _hasLocation => _latitude != null && _longitude != null;

  Future<void> _openInMaps() async {
    final lat = _latitude;
    final lng = _longitude;
    if (lat == null || lng == null) return;

    final label = Uri.encodeComponent(
      _doctor?['clinic_name']?.toString().trim().isNotEmpty == true
          ? _doctor!['clinic_name'].toString()
          : _doctorName,
    );
    final uri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($label)');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return;
    }
    // No maps app registered for geo: — fall back to the browser.
    await launchUrl(
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng'),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget _buildLocation(bool isDark) {
    final clinic = _doctor?['clinic_name']?.toString().trim() ?? '';
    final address = _doctor?['address']?.toString().trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Iconsax.location, 'dd_location'.tr()),
        const SizedBox(height: 10),
        _card(
          isDark: isDark,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_hasLocation)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(21),
                  ),
                  child: SizedBox(
                    height: 170,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_latitude!, _longitude!),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('doctor-${widget.doctorId}'),
                              position: LatLng(_latitude!, _longitude!),
                            ),
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          liteModeEnabled: true, // static preview, cheap to draw
                        ),
                        // Lite mode swallows taps, so the whole preview opens
                        // the real maps app instead.
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(onTap: _openInMaps),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (clinic.isNotEmpty)
                            Text(
                              clinic,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.getTextTitle(context),
                              ),
                            ),
                          if (clinic.isNotEmpty && address.isNotEmpty)
                            const SizedBox(height: 3),
                          Text(
                            address.isNotEmpty ? address : 'dd_no_address'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              height: 1.6,
                              color: address.isNotEmpty
                                  ? AppColors.getTextSubtitle(context)
                                  : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_hasLocation) ...[
                      const SizedBox(width: 10),
                      TextButton.icon(
                        onPressed: _openInMaps,
                        icon: const Icon(Iconsax.direct_right, size: 16),
                        label: Text(
                          'dd_open_maps'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorReviewsScreen(
          doctorId: widget.doctorId,
          doctorName: _doctorName,
          rating: _asDouble(_doctor?['rating']).toStringAsFixed(1),
        ),
      ),
    );
  }

  // ── about ──

  Widget _buildAbout(bool isDark) {
    final bio = _doctor?['bio']?.toString().trim() ?? '';
    final hasBio = bio.isNotEmpty;
    final isLong = bio.length > 160;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Iconsax.profile_circle, 'about_doctor'.tr()),
        const SizedBox(height: 10),
        _card(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasBio ? bio : 'dd_no_bio'.tr(),
                maxLines: isLong && !_bioExpanded ? 3 : null,
                overflow: isLong && !_bioExpanded ? TextOverflow.ellipsis : null,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  height: 1.75,
                  color: hasBio
                      ? AppColors.getTextSubtitle(context)
                      : AppColors.textLight,
                ),
              ),
              if (isLong) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                  child: Text(
                    _bioExpanded ? 'dd_read_less'.tr() : 'read_more'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
              // Rating / experience / price share this card — they describe the
              // same doctor, so a second card between them was just a seam.
              const SizedBox(height: 12),
              Divider(height: 1, color: AppColors.getDivider(context)),
              const SizedBox(height: 12),
              _buildStatsRow(),
            ],
          ),
        ),
      ],
    );
  }

  // ── video ──

  Widget _buildVideo(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_videoStarted && _youtubeController != null)
              YoutubePlayer(
                controller: _youtubeController!,
                backgroundColor: Colors.black,
              )
            else if (_videoStarted &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              )
            else
              _buildVideoPoster(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPoster() {
    return GestureDetector(
      onTap: _startVideo,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: _imageProvider(_doctorImage), fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),
          ),
          if (_videoStarted)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
    );
  }

  // ── services ──

  Widget _buildServices(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          Iconsax.health,
          'dd_services'.tr(),
          subtitle: _services.isEmpty ? null : 'dd_choose_service'.tr(),
        ),
        const SizedBox(height: 12),
        if (_services.isEmpty)
          _emptyBox('dd_no_services'.tr(), isDark)
        else
          ...List.generate(_services.length, (index) {
            final service = _services[index] as Map;
            final id = _asInt(service['id']);
            final isSelected = id != null && id == _selectedServiceId;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _selectableTile(
                isDark: isDark,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedServiceId = id),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.getSurfaceSecondary(context),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Iconsax.activity,
                        size: 20,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.getTextSubtitle(context),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _serviceName(service),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextTitle(context),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _money(_asDouble(service['price'])),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _radio(isSelected),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _radio(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.getBorder(context),
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }

  // ── schedule ──

  Widget _buildSchedule(bool isDark) {
    return Column(
      key: _scheduleKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Iconsax.calendar_1, 'dd_schedule'.tr()),
        const SizedBox(height: 12),
        if (_slotsLoading)
          const SizedBox(
            height: 84,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
          )
        else if (_days.isEmpty)
          _emptyBox('dd_no_days'.tr(), isDark)
        else ...[
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = _dayIndex == index;

                return GestureDetector(
                  onTap: () => setState(() {
                    _dayIndex = index;
                    _timeIndex = -1;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 68,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.getBorder(context),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayLabel(day.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : AppColors.getTextSubtitle(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd').format(day.date),
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.getTextTitle(context),
                          ),
                        ),
                        Text(
                          _monthName(day.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          if (_slots.isEmpty)
            _emptyBox('dd_no_times'.tr(), isDark)
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_slots.length, (index) {
                final slot = _slots[index];
                final isSelected = _timeIndex == index;
                // Taken slots stay visible but dead, so the patient can see
                // how busy the doctor is rather than wondering what vanished.
                final isTaken = slot.taken;

                return GestureDetector(
                  onTap: isTaken
                      ? null
                      : () => setState(() => _timeIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isTaken
                          ? AppColors.getSurfaceSecondary(context)
                          : isSelected
                              ? AppColors.primary
                              : AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected && !isTaken
                            ? AppColors.primary
                            : AppColors.getBorder(context),
                      ),
                    ),
                    child: Text(
                      _clock(slot.dateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight:
                            isSelected && !isTaken ? FontWeight.bold : FontWeight.w500,
                        decoration: isTaken ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textLight,
                        color: isTaken
                            ? AppColors.textLight
                            : isSelected
                                ? Colors.white
                                : AppColors.getTextTitle(context),
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ],
    );
  }

  // ── bottom bar ──

  Widget _buildBottomBar(bool isDark) {
    final ready = _selectedDateTime != null;
    final price = _selectedPrice;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        border: Border(top: BorderSide(color: AppColors.getDivider(context))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'total_price'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.getTextSubtitle(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _money(price),
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextTitle(context),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isBooking ? null : _onBookPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ready ? AppColors.primary : AppColors.getSurfaceSecondary(context),
                    foregroundColor:
                        ready ? Colors.white : AppColors.getTextSubtitle(context),
                    elevation: ready ? 6 : 0,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    ready ? 'dd_book_now'.tr() : 'select_time'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── summary sheet ──

  void _showSummarySheet() {
    final slot = _selectedDateTime;
    if (slot == null) return;
    final service = _selectedService;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.getDivider(context),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'dd_summary'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextTitle(context),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _summaryRow(Iconsax.user, 'dd_doctor'.tr(), _doctorName),
                    if (service != null)
                      _summaryRow(
                        Iconsax.health,
                        'dd_service'.tr(),
                        _serviceName(service),
                      ),
                    _summaryRow(
                      Iconsax.calendar_1,
                      'dd_date'.tr(),
                      _fullDate(slot),
                    ),
                    _summaryRow(
                      Iconsax.clock,
                      'dd_time'.tr(),
                      _clock(slot),
                    ),
                    const SizedBox(height: 6),
                    Divider(color: AppColors.getDivider(context)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total_price'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextSubtitle(context),
                          ),
                        ),
                        Text(
                          _money(_selectedPrice),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            _isBooking ? null : () => _submitBooking(setSheetState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isBooking
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'dd_confirm'.tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.getTextSubtitle(context),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextTitle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── login prompt ──

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'dd_login_title'.tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: AppColors.getTextTitle(context),
          ),
        ),
        content: Text(
          'dd_login_desc'.tr(),
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            height: 1.7,
            color: AppColors.getTextSubtitle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'dd_later'.tr(),
              style: GoogleFonts.poppins(color: AppColors.getTextSubtitle(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppFlow(startAtLogin: true),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'dd_login'.tr(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── shared building blocks ──

  Widget _sectionHeader(IconData icon, String title, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextTitle(context),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: AppColors.getTextSubtitle(context),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({
    required bool isDark,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(14),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _selectableTile({
    required bool isDark,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.14 : 0.06)
                : AppColors.getSurface(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.getBorder(context),
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _emptyBox(String message, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: AppColors.getTextSubtitle(context),
        ),
      ),
    );
  }

  // ── loading / error ──

  List<Widget> _buildSkeleton(bool isDark) {
    Widget bar(double height, double widthFactor) => FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: widthFactor,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: AppColors.getSurfaceSecondary(context),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

    return [
      bar(86, 1),
      const SizedBox(height: 24),
      bar(20, 0.4),
      const SizedBox(height: 12),
      bar(90, 1),
      const SizedBox(height: 24),
      bar(20, 0.5),
      const SizedBox(height: 12),
      bar(70, 1),
      const SizedBox(height: 12),
      bar(70, 1),
    ].animate(onPlay: (c) => c.repeat()).fadeIn(duration: 700.ms).then().fadeOut(
          duration: 700.ms,
          begin: 0.4,
        );
  }

  Widget _buildErrorState() {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.getTextTitle(context),
              ),
            ),
          ),
          const Spacer(),
          Icon(Iconsax.cloud_cross, size: 56, color: AppColors.textLight),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'dd_load_failed'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.7,
                color: AppColors.getTextSubtitle(context),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _loading = true;
                _loadFailed = false;
              });
              _fetchDoctor();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'dd_retry'.tr(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
