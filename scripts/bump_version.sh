#!/bin/bash

set -e

BUMP_LEVEL=$1
RELEASE_NOTES=$2
RELEASE_NOTES_FILE=$3

if [[ -z "$BUMP_LEVEL" || -z "$RELEASE_NOTES" ]]; then
  echo "❌ Uso: ./bump_version.sh [patch|minor|major] \"Notas breves\" [ruta_opcional_a_release_notes.txt]"
  exit 1
fi

# Obtener versión actual
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | cut -d ' ' -f2 | cut -d '+' -f1)
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Incrementar versión según nivel
case "$BUMP_LEVEL" in
  patch)
    PATCH=$((PATCH + 1))
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  *)
    echo "❌ Tipo de incremento inválido: $BUMP_LEVEL"
    exit 1
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
BUILD_NUMBER=$(date +%s)
NEW_VERSION_LINE="version: $NEW_VERSION+$BUILD_NUMBER"

# Reemplazar línea en pubspec.yaml
sed -i "s/^version: .*/$NEW_VERSION_LINE/" pubspec.yaml
echo "📌 Nueva versión: $NEW_VERSION_LINE"

# 📝 Formato de fecha
DATE=$(date +'%Y-%m-%d')

# 📄 Preparar bloque para el CHANGELOG.md
echo "📄 Actualizando CHANGELOG.md..."

CHANGELOG_ENTRY="## [$NEW_VERSION] - $DATE  🔖 $RELEASE_NOTES"

# Añadir contenido de archivo de notas si existe
if [[ -n "$RELEASE_NOTES_FILE" && -f "$RELEASE_NOTES_FILE" ]]; then
  BODY=$(cat "$RELEASE_NOTES_FILE")
  CHANGELOG_ENTRY="$CHANGELOG_ENTRY

$BODY"
fi

# Insertar al inicio del CHANGELOG.md
{ echo "$CHANGELOG_ENTRY"; echo; cat CHANGELOG.md; } > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md

echo "✅ CHANGELOG.md actualizado correctamente."
