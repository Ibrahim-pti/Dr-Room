import re

with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

video_widget = """
                // ── Video Section ──
                if (_isLoadingDetails)
                  const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                else if (_youtubeController != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                      ),
                    ),
                  )
                else if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_videoPlayerController!),
                            VideoProgressIndicator(_videoPlayerController!, allowScrubbing: true),
                            Center(
                              child: IconButton(
                                icon: Icon(
                                  _videoPlayerController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _videoPlayerController!.value.isPlaying
                                        ? _videoPlayerController!.pause()
                                        : _videoPlayerController!.play();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
"""

content = content.replace('                // ── About Section ──', video_widget + '\n                // ── About Section ──')

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
