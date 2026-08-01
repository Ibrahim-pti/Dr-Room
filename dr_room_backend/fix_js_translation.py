with open('resources/views/doctor/profile/index.blade.php', 'r') as f:
    content = f.read()

# Fix data.en to data.translations.en
content = content.replace("data.en || ''", "data.translations?.en || ''")
content = content.replace("data.ar || ''", "data.translations?.ar || ''")

with open('resources/views/doctor/profile/index.blade.php', 'w') as f:
    f.write(content)
