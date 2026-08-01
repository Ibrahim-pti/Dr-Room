with open('lib/features/home/home_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("final pharmaciesList = _topPharmacies.length > 2", "final pharmaciesList = _topPharmacies.isNotEmpty")

with open('lib/features/home/home_screen.dart', 'w') as f:
    f.write(content)
