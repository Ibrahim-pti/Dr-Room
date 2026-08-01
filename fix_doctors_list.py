with open('lib/features/home/home_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("final doctorsList = _topDoctors.length > 2 ? _topDoctors : _fallbackDoctors;", "final doctorsList = _topDoctors.isNotEmpty ? _topDoctors : _fallbackDoctors;")

with open('lib/features/home/home_screen.dart', 'w') as f:
    f.write(content)
