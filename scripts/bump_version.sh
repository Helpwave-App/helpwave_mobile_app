#!/bin/bash
set -e

USAGE="Uso: ./scripts/bump_version.sh [patch|minor|major] \"Notas de la versión\""
LEVEL=$1
NOTES=$2

if [[ "$LEVEL" != "patch" && "$LEVEL" != "minor" && "$LEVEL" != "major" ]]; then
  echo "$USAGE"
  exit 1
fi

if [[ -z "$NOTES" ]]; then
  echo "❌ Debes proporcionar notas de la versión como segundo parámetro."
  echo "$USAGE"
  exit 1
fi

PUBSPEC="pubspec.yaml"
CHANGELOG="CHANGELOG.md"

CURRENT_VERSION=$(grep "^version:" $PUBSPEC | awk '{print $2}')
IFS='+' read -r VERSION_NAME VERSION_CODE <<< "$CURRENT_VERSION"
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION_NAME"

case $LEVEL in
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
esac

NEW_VERSION_NAME="${MAJOR}.${MINOR}.${PATCH}"
NEW_VERSION_CODE=$((VERSION_CODE + 1))
NEW_VERSION="${NEW_VERSION_NAME}+${NEW_VERSION_CODE}"

# 🔧 Actualizar pubspec.yaml
sed -i.bak "s/^version: .*/version: ${NEW_VERSION}/" $PUBSPEC
rm "${PUBSPEC}.bak"

# 📝 Agregar al CHANGELOG.md
DATE=$(date +'%Y-%m-%d')
echo -e "## [$NEW_VERSION_NAME] - $DATE\n$NOTES\n" | cat - $CHANGELOG > temp && mv temp $CHANGELOG

# ✅ Commit automático
git config --global user.email "github-actions@helpwave.org"
git config --global user.name "HelpWave CI"
git add pubspec.yaml CHANGELOG.md
git commit -m "🔖 Bump version to $NEW_VERSION"
