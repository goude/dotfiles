#!/usr/bin/env bash
set -e

#source "$RUNCOM2_PATH/localenv"
#pyenv activate 3.8.10/envs/neovim3

python3 -m venv neovim3-venv
source neovim3-venv/bin/activate

ln -sf "$(which python3)" ~/bin/neovim-python3
ln -sf "$(which pip3)" ~/bin/neovim-pip3
#ln -sf "$(which pip)" ~/bin/neovim-pip

pip_cmd="$(which pip)"

$pip_cmd install --upgrade pip wheel

$pip_cmd install --upgrade \
  autopep8 \
  black \
  click \
  docker-compose \
  flake8 \
  httpie \
  icdiff \
  isort \
  jedi \
  mypy \
  pipx \
  pyscaffold[all] \
  neovim \
  pynvim \
  pytest \
  pydocstyle \
  pyscaffold[all] \
  reorder-python-imports \
  requests \
  tmuxp \
  tox \
  topydo \
  tox \
  vim-vint \
  visidata \
  yamllint \
  yapf

pyenv_symlinks=(
  "black"
  "docker-compose"
  "flake8"
  "git-icdiff"
  "http"
  "icdiff"
  "isort"
  "mypy"
  "pipx"
  "putup"
  "pydocstyle"
  "reorder-python-imports"
  "tmuxp"
  "tox"
  "topydo"
  "vd"
  "yapf"
  "yamllint"
)

for i in "${pyenv_symlinks[@]}"
do
  echo "Symlinking $i to ~/bin/..."
  ln -sf "$(which $i)" "$HOME/bin/$i"
done
