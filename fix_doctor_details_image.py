with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

old_image_widget = """                        child: Image.asset(
                          widget.image,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.contain, // Prevents cropping
                          alignment: Alignment.center,
                        ),"""

new_image_widget = """                        child: widget.image.startsWith('http')
                            ? Image.network(
                                widget.image,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              )
                            : Image.asset(
                                widget.image,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),"""

content = content.replace(old_image_widget, new_image_widget)

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
