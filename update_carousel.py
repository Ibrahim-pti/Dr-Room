with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

# Add page controller and current index state
state_vars = """  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedServiceIndex = 0;
  int _currentImageIndex = 0;
  final PageController _imagePageController = PageController();"""

content = content.replace("""  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedServiceIndex = 0;""", state_vars)

# Create method to get image list
image_list_func = """  List<String> _getDoctorImages() {
    List<String> list = [];
    if (widget.image.isNotEmpty) {
      list.add(widget.image);
    }
    // Add additional gallery photos if present in _doctorDetails or fallbacks
    if (_doctorDetails != null && _doctorDetails!['gallery'] != null && (_doctorDetails!['gallery'] as List).isNotEmpty) {
      for (var img in _doctorDetails!['gallery']) {
        list.add(ApiClient.getImageUrl(img.toString()));
      }
    } else {
      // Add tasteful fallback gallery images for carousel experience
      list.addAll([
        'assets/images/doctor1.png',
        'assets/images/doctor2.png',
      ]);
    }
    return list.toSet().toList(); // Unique
  }"""

content = content.replace("  String _getDoctorName() {", image_list_func + "\n\n  String _getDoctorName() {")

# Replace single Image with PageView Carousel in FlexibleSpaceBar
old_hero_bg = """                      // Hero Image
                      Hero(
                        tag: widget.name,
                        child: widget.image.startsWith('http')
                            ? Image.network(widget.image, fit: BoxFit.cover, alignment: Alignment.topCenter)
                            : Image.asset(widget.image, fit: BoxFit.cover, alignment: Alignment.topCenter),
                      ),"""

new_hero_bg = """                      // Carousel Image PageView
                      Builder(
                        builder: (context) {
                          final images = _getDoctorImages();
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              PageView.builder(
                                controller: _imagePageController,
                                itemCount: images.length,
                                onPageChanged: (idx) {
                                  setState(() {
                                    _currentImageIndex = idx;
                                  });
                                },
                                itemBuilder: (context, idx) {
                                  final img = images[idx];
                                  return Hero(
                                    tag: idx == 0 ? widget.name : 'doctor_img_$idx',
                                    child: img.startsWith('http')
                                        ? Image.network(img, fit: BoxFit.cover, alignment: Alignment.topCenter)
                                        : Image.asset(img, fit: BoxFit.cover, alignment: Alignment.topCenter),
                                  );
                                },
                              ),
                              // Carousel Indicator Dots
                              if (images.length > 1)
                                Positioned(
                                  top: 50,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(images.length, (idx) {
                                      final isSelected = _currentImageIndex == idx;
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        width: isSelected ? 22 : 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),"""

content = content.replace(old_hero_bg, new_hero_bg)

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
