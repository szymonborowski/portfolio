#!/bin/bash
# Prosta konwersja Markdown do HTML używając podstawowego formatowania
cat MINIKUBE_DEPLOYMENT.md | \
  sed 's/^# \(.*\)/<h1>\1<\/h1>/g' | \
  sed 's/^## \(.*\)/<h2>\1<\/h2>/g' | \
  sed 's/^### \(.*\)/<h3>\1<\/h3>/g' | \
  sed 's/^#### \(.*\)/<h4>\1<\/h4>/g' | \
  sed 's/^\* \(.*\)/<li>\1<\/li>/g' | \
  sed 's/^- \(.*\)/<li>\1<\/li>/g' | \
  sed 's/```\(.*\)/<pre><code>/g; s/```/<\/code><\/pre>/g' | \
  sed 's/`\([^`]*\)`/<code>\1<\/code>/g' | \
  sed 's/\*\*\([^*]*\)\*\*/<strong>\1<\/strong>/g' > temp.html

# Dodaj HTML wrapper
cat > MINIKUBE_DEPLOYMENT.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dokumentacja Wdrożenia Mikrousług Portfolio na Minikube</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; max-width: 900px; margin: 40px auto; padding: 0 20px; }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; margin-top: 30px; border-bottom: 2px solid #95a5a6; padding-bottom: 8px; }
        h3 { color: #7f8c8d; margin-top: 20px; }
        code { background: #f4f4f4; padding: 2px 6px; border-radius: 3px; font-family: 'Courier New', monospace; }
        pre { background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px; overflow-x: auto; }
        pre code { background: transparent; color: #ecf0f1; }
        li { margin: 5px 0; }
        strong { color: #e74c3c; }
        .success { color: #27ae60; }
    </style>
</head>
<body>
HTMLEOF

cat temp.html >> MINIKUBE_DEPLOYMENT.html
echo '</body></html>' >> MINIKUBE_DEPLOYMENT.html
rm temp.html
