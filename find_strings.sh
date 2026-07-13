#!/bin/bash
# Extract all hardcoded user-facing strings from Dart files
for f in $(find lib/features -name "*.dart" -type f | sort); do
  strings=$(grep -n "'" "$f" | grep -E "'[A-Za-z\u0600-\u06FF]" | grep -vE "import |package:|assets/|\.dart|\.png|\.svg|\.json|const String|// |Key\(|ValueKey|google_fonts|poppins|inter|xmlns|viewBox|fill=|stroke=|path d=|rect |circle |svg |rx=|ry=|width=|height=|opacity|\.tr\(\)")
  if [ -n "$strings" ]; then
    echo "=== $f ==="
    echo "$strings"
    echo ""
  fi
done
