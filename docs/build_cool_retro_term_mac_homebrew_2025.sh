#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
#  build-cool-retro-term.sh
#
#  This script builds and installs *Cool Retro Term* on macOS (late 2025+),
#  including fixes for removed AGL framework on macOS 15 “Sequoia/Tahoe”
#  and compatibility with modern Apple Silicon hardware.
#
#  It automates:
#    1. Homebrew dependency setup (Qt 5, git, cmake)
#    2. Cloning the upstream GitHub repo (with submodules)
#    3. Stripping all AGL references from qmltermwidget
#    4. Adding a guard file to prevent qmake from re-injecting AGL
#    5. Regenerating makefiles with modern macOS target
#    6. Building the app with Homebrew’s Qt 5
#
#  Tested on: macOS 15.x (Apple Silicon & Intel)
#  Last updated: October 2025
# -----------------------------------------------------------------------------

# --- Config ------------------------------------------------------------------
REPO_URL="https://github.com/Swordfish90/cool-retro-term.git"
TARGET_DIR="${1:-cool-retro-term}"   # pass a custom path as first arg if desired

# --- Prereqs (Homebrew, Qt 5) ------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install from https://brew.sh"
  exit 1
fi

brew update
brew install qt@5
# Optional but handy tools
brew install git cmake || true

# Resolve Homebrew Qt 5 qmake path (ARM first, then Intel)
/opt/homebrew/opt/qt@5/bin/qmake  >/dev/null 2>&1 && QT5_QMAKE="/opt/homebrew/opt/qt@5/bin/qmake"
[[ -x "${QT5_QMAKE:-}" ]] || QT5_QMAKE="/usr/local/opt/qt@5/bin/qmake"
if [[ ! -x "$QT5_QMAKE" ]]; then
  echo "qt@5 qmake not found. Ensure qt@5 installed correctly."
  exit 1
fi

# --- Clone or update the repo ------------------------------------------------
if [[ -d "$TARGET_DIR/.git" ]]; then
  echo "Updating existing repo at: $TARGET_DIR"
  git -C "$TARGET_DIR" fetch --recurse-submodules
  git -C "$TARGET_DIR" pull --rebase --autostash --recurse-submodules
  git -C "$TARGET_DIR" submodule update --init --recursive
else
  echo "Cloning into: $TARGET_DIR"
  git clone --recursive "$REPO_URL" "$TARGET_DIR"
fi

cd "$TARGET_DIR"

# --- Strip AGL everywhere in qmltermwidget metadata --------------------------
echo "Removing AGL framework references..."
/usr/bin/find qmltermwidget -type f \( -name '*.pro' -o -name '*.pri' -o -name '*.prl' \) -print0 \
  | xargs -0 sed -i '' -E 's/(,|\s)-framework AGL//g' || true
/usr/bin/find qmltermwidget -type f \( -name '*.pro' -o -name '*.pri' -o -name '*.prl' \) -print0 \
  | xargs -0 sed -i '' -E 's#.*AGL\.framework/Headers/?##g' || true

# --- Add a guard to block any re-injection of AGL ----------------------------
cat > no-agl.pri <<'EOF'
QMAKE_LIBS_OPENGL -= -framework AGL
LIBS               -= -framework AGL
QMAKE_LFLAGS       -= -framework\ AGL
EOF

# Include guard in top-level and subproject if missing
grep -q 'no-agl.pri' cool-retro-term.pro || printf '\ninclude(no-agl.pri)\n' >> cool-retro-term.pro
grep -q 'no-agl.pri' qmltermwidget/QMLTermWidget/QMLTermWidget.pro || \
  printf '\ninclude(../../no-agl.pri)\n' >> qmltermwidget/QMLTermWidget/QMLTermWidget.pro

# --- Clean generated files so qmake re-resolves everything -------------------
echo "Cleaning old build files..."
( cd qmltermwidget && make distclean || true )
make distclean || true
git clean -fdX || true   # removes ignored build artifacts; keeps your edits

# --- Generate Makefiles with modern macOS target + explicit OpenGL -----------
echo "Regenerating Makefiles..."
"$QT5_QMAKE" QMAKE_MACOSX_DEPLOYMENT_TARGET=11.0 QMAKE_LIBS_OPENGL="-framework OpenGL"

# --- Build -------------------------------------------------------------------
echo "Building Cool Retro Term..."
make -j"$(sysctl -n hw.ncpu)"

echo
echo "✅ Build complete!"
echo "To install and launch:"
echo '  mkdir -p ~/Applications && cp -R cool-retro-term.app ~/Applications/'
echo '  open ~/Applications/cool-retro-term.app'
