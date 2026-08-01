with open('resources/views/doctor/profile/index.blade.php', 'r') as f:
    content = f.read()

old_headers = """headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},"""
new_headers = """headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'X-CSRF-TOKEN': '{{ csrf_token() }}'},"""

content = content.replace(old_headers, new_headers)

with open('resources/views/doctor/profile/index.blade.php', 'w') as f:
    f.write(content)
