#!/bin/bash

if [ -z "$1" ]; then
  echo "❌ Debes escribir una nota de versión."
  echo "Uso: ./deploy.sh \"Notas de esta versión\""
  exit 1
fi

NOTES=$1
APP_ID="1:576719437400:android:ce6faf4a8b78c0f02d542d"
TESTERS="cuchcafabrizzio@gmail.com,elvia.arteaga98@gmail.com,elvitagu98@hotmail.com"
VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
VERSION_NAME=${VERSION%%+*}

echo "📦 Compilando APK versión $VERSION_NAME en modo release..."
flutter build apk --release

if [ $? -ne 0 ]; then
  echo "❌ Falló la compilación del APK."
  exit 1
fi

echo "🚀 Subiendo a Firebase App Distribution..."
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app "$APP_ID" \
  --testers "$TESTERS" \
  --release-notes "$NOTES"

if [ $? -eq 0 ]; then
  echo "✅ Distribución completada con éxito."
else
  echo "❌ Ocurrió un error durante la distribución."
fi
