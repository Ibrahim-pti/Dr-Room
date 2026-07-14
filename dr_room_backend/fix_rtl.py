import re

with open('resources/views/welcome.blade.php', 'r') as f:
    content = f.read()

replacements = {
    'text-left': 'text-start',
    'text-right': 'text-end',
    'left-4': 'start-4',
    'right-4': 'end-4',
    'left-24': 'start-24',
    'right-16': 'end-16',
    'pl-8': 'ps-8',
    'pr-8': 'pe-8',
    'ml-4': 'ms-4',
    'mr-4': 'me-4',
    'left-[60%]': 'start-[60%]',
    'left-0': 'start-0',
    'right-0': 'end-0',
    '-right-10': '-end-10',
    '-bottom-16': '-bottom-16', # no change
}

for old, new in replacements.items():
    content = content.replace(old, new)

with open('resources/views/welcome.blade.php', 'w') as f:
    f.write(content)
