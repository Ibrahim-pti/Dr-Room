import re

with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

# Replace dispose for youtube controller
content = content.replace('_youtubeController?.dispose();', '_youtubeController?.close();')

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
