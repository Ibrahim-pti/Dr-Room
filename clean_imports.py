with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("import '../../core/theme/app_colors.dart';\n", "")

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
