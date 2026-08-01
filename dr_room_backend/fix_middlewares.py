import glob

# 1. EnsureDoctorProfileComplete.php
with open('app/Http/Middleware/EnsureDoctorProfileComplete.php', 'r') as f:
    content = f.read()
content = content.replace("&& $doctor->consultation_fee !== null", "")
with open('app/Http/Middleware/EnsureDoctorProfileComplete.php', 'w') as f:
    f.write(content)

# 2. app.blade.php
with open('resources/views/doctor/layouts/app.blade.php', 'r') as f:
    content = f.read()
content = content.replace("&& $doctor->consultation_fee !== null", "")
with open('resources/views/doctor/layouts/app.blade.php', 'w') as f:
    f.write(content)
