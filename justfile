set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

_default:
    @printf "After cloning: run just setup\n\n"
    @just --list

# 🛠️ Install everything — first thing after cloning
setup:
    bash setup/setup.sh

# 📦 Install system packages only (apt/brew)
packages:
    bash setup/packages.sh

# 🐍 Install uv and Python
python:
    bash setup/uv.sh

# 🟢 Install nvm and Node.js
node:
    bash setup/node.sh

# ✏️ Install latest stable Neovim
neovim:
    bash setup/neovim.sh

# 🔧 Install CLI tools (starship, shfmt)
tools:
    bash setup/tools.sh

# 🏠 Install homeshick and link dotfiles
link:
    bash setup/homeshick.sh

# 🔍 Find stale symlinks pointing to this repo
stale-links:
    #!/usr/bin/env bash
    set -euo pipefail
    repo="$HOME/.homesick/repos/dotfiles"
    echo "Scanning for broken symlinks pointing to $repo..."
    found=0
    while IFS= read -r -d '' link; do
      target="$(readlink "$link")"
      if [[ "$target" == *"$repo"* ]] && [ ! -e "$link" ]; then
        echo "  stale: $link -> $target"
        found=$((found + 1))
      fi
    done < <(find "$HOME" -maxdepth 4 -type l -print0 2>/dev/null)
    if [ "$found" -eq 0 ]; then
      echo "  No stale symlinks found."
    else
      echo ""
      echo "  Found $found stale link(s). Remove with: just stale-links-clean"
    fi

# 🧹 Remove stale symlinks pointing to this repo
stale-links-clean:
    #!/usr/bin/env bash
    set -euo pipefail
    repo="$HOME/.homesick/repos/dotfiles"
    while IFS= read -r -d '' link; do
      target="$(readlink "$link")"
      if [[ "$target" == *"$repo"* ]] && [ ! -e "$link" ]; then
        echo "  removing: $link"
        rm "$link"
      fi
    done < <(find "$HOME" -maxdepth 4 -type l -print0 2>/dev/null)
    echo "  Done."

# 🎨 Format shell scripts with shfmt
fmt:
    shfmt -w setup/*.sh setup/install/*.sh
    @echo "Format complete."

# ✅ Lint shell scripts with shellcheck
lint:
    shellcheck setup/*.sh setup/install/*.sh || true
    @echo "Lint complete."

# 🚦 Format + lint gate
check: fmt lint
    @echo "Check complete."

# 🩺 Verify expected tools are installed
doctor:
    #!/usr/bin/env bash
    set -euo pipefail
    ok=1
    check() {
      if command -v "$1" &>/dev/null; then
        printf "  %-20s ok\n" "$1"
      else
        printf "  %-20s MISSING\n" "$1"
        ok=0
      fi
    }
    echo "=== doctor ==="
    check git
    check curl
    check fish
    check fzf
    check fd
    check bat
    check eza
    check rg
    check tmux
    check tig
    check nvim
    check starship
    check shfmt
    check shellcheck
    check node
    check python3
    check uv
    check homeshick
    echo ""
    if [ "$ok" -eq 1 ]; then
      echo "All tools present."
    else
      echo "Some tools are missing — run: just setup"
      exit 1
    fi

# 🔄 Nuclear reset — remove tool installs, re-run setup
reset:
    @echo "This will remove ~/.nvm, ~/.nvim, and re-run setup."
    @echo "Press Ctrl-C to cancel, or Enter to continue."
    @read _
    rm -rf ~/.nvm ~/.nvim
    just setup
