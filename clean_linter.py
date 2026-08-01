with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

import re
content = re.sub(r'\.withOpacity\(([0-9\.]+)\)', r'.withValues(alpha: \1)', content)

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
