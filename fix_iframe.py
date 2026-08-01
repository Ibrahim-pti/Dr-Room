import re

with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

# Replace imports
content = content.replace("import 'package:youtube_player_flutter/youtube_player_flutter.dart';", "import 'package:youtube_player_iframe/youtube_player_iframe.dart';")

# Replace initialization
old_init = """      if (videoType == 'youtube') {
        final videoId = YoutubePlayer.convertUrlToId(videoUrl);
        if (videoId != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false),
          );
        }
      }"""

new_init = """      if (videoType == 'youtube') {
        _youtubeController = YoutubePlayerController.fromVideoId(
          videoId: videoUrl.split('v=')[1].split('&')[0],
          autoPlay: false,
          params: const YoutubePlayerParams(showFullscreenButton: true),
        );
      }"""
content = content.replace(old_init, new_init)

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
