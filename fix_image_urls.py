import re

# Fix home_screen.dart
with open('lib/features/home/home_screen.dart', 'r') as f:
    content = f.read()

old_image = """                        final image = (doc['image_path'] != null)
                            ? '${ApiClient.storageUrl}/${doc['image_path']}'
                            : fallbackImage;"""
new_image = """                        final image = (doc['image_path'] != null)
                            ? ApiClient.getImageUrl(doc['image_path'])
                            : fallbackImage;"""
content = content.replace(old_image, new_image)

with open('lib/features/home/home_screen.dart', 'w') as f:
    f.write(content)

# Fix all_doctors_screen.dart
with open('lib/features/doctors/all_doctors_screen.dart', 'r') as f:
    content = f.read()

old_image2 = """                    final image = (doc['image_path'] != null)
                        ? '${ApiClient.storageUrl}/${doc['image_path']}'
                        : 'assets/images/doctor1.png'; // Fallback"""
new_image2 = """                    final image = (doc['image_path'] != null)
                        ? ApiClient.getImageUrl(doc['image_path'])
                        : 'assets/images/doctor1.png'; // Fallback"""
content = content.replace(old_image2, new_image2)

with open('lib/features/doctors/all_doctors_screen.dart', 'w') as f:
    f.write(content)

