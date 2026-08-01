import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyReelItem extends StatefulWidget {
  final Map<String, dynamic> reelData;

  /// Whether this reel is the page currently on screen. Only the active reel
  /// plays — otherwise off-screen pages keep playing audio in the background.
  final bool isActive;

  const EmergencyReelItem({
    super.key,
    required this.reelData,
    this.isActive = true,
  });

  @override
  State<EmergencyReelItem> createState() => _EmergencyReelItemState();
}

class _EmergencyReelItemState extends State<EmergencyReelItem> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  bool _isInitialized = false;
  bool _isPlaying = false;

  bool get _isYoutube => widget.reelData['type'] == 'youtube';

  @override
  void initState() {
    super.initState();
    _isYoutube ? _initYoutube() : _initVideoFile();
  }

  void _initYoutube() {
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: widget.reelData['youtube_id'],
      autoPlay: widget.isActive,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        showVideoAnnotations: false,
        enableCaption: false,
        strictRelatedVideos: true,
        playsInline: true,
        loop: true,
        // Let taps and vertical swipes reach the PageView instead of the
        // embedded web player.
        pointerEvents: PointerEvents.none,
      ),
    );
    _isInitialized = true;
    _isPlaying = widget.isActive;
  }

  void _initVideoFile() {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.reelData['video_url']),
    );
    _videoController = controller;
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _isInitialized = true);
      controller.setLooping(true);
      if (widget.isActive) {
        controller.play();
        setState(() => _isPlaying = true);
      }
    });
  }

  @override
  void didUpdateWidget(EmergencyReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _play() : _pause();
    }
  }

  void _play() {
    _youtubeController?.playVideo();
    _videoController?.play();
    if (mounted) setState(() => _isPlaying = true);
  }

  void _pause() {
    _youtubeController?.pauseVideo();
    _videoController?.pause();
    if (mounted) setState(() => _isPlaying = false);
  }

  void _togglePlay() => _isPlaying ? _pause() : _play();

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.close();
    super.dispose();
  }

  Widget _buildPlayer() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_isYoutube) {
      // Channel footage is landscape, so letterbox it rather than cropping
      // away the demonstration.
      return Center(
        child: YoutubePlayer(
          controller: _youtubeController!,
          aspectRatio: 16 / 9,
          enableFullScreenOnVerticalDrag: false,
          autoFullScreen: false,
        ),
      );
    }

    final controller = _videoController!;
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player Background
          _buildPlayer(),

          // Gradient Overlay to make text readable
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),

          // Pause Icon Overlay (If paused)
          if (_isInitialized && !_isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),

          // Details and Actions
          Positioned(
            left: 16,
            right: 80, // Leave space for side action buttons
            bottom: 32, // Leave space for navigation bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Author tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.health, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        widget.reelData['author'] ?? 'Dr. Room',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  widget.reelData['title'] ?? 'Emergency Guide',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  widget.reelData['description'] ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Source credit (required by the stock/channel licenses)
                if ((widget.reelData['attribution'] ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.reelData['attribution'],
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Right Side Action Buttons
          Positioned(
            right: 16,
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: Iconsax.heart,
                  label: '${widget.reelData['likes'] ?? 0}',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: widget.reelData['views'] != null
                      ? Iconsax.eye
                      : Iconsax.message,
                  label: '${widget.reelData['views'] ?? 0}',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: Iconsax.send_2,
                  label: '${widget.reelData['shares'] ?? 0}',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: Iconsax.more,
                  label: '',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
