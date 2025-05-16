#!/bin/bash

# Validar que se haya pasado un mensaje de versión
if [ -z "$1" ]; then
  echo "❌ Debes escribir una nota de versión."
  echo "Uso: ./deploy.sh \"Notas de esta versión\""
  exit 1
fi

NOTES=$1

APP_ID="1:576719437400:android:443846195d47e99d2d542d"
GROUPS="developers"

# Construir el APK en modo release
flutter build apk --release

# Subir a Firebase App Distribution
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app $APP_ID \
  --groups "$GROUPS" \
  --release-notes "$NOTES"
