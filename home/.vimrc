" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={,} foldmethod=marker spell:

" vim configuration. Mappings are shared with neovim, see end of file.

" Initialization / load bundles {
if has('vim_starting')
  set nocompatible
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  au VimEnter * PlugInstall
endif

call plug#begin(expand('~/.vim/plugged'))
Plug 'tpope/vim-sensible'
source ~/.config/vim-shared/bundles-shared.vim

call plug#end()

filetype plugin indent on

" }

" Load shared init {
if filereadable(expand("~/.config/vim-shared/init-shared.vim"))
  source ~/.config/vim-shared/init-shared.vim
endif
" }

" Load shared mappings {
if filereadable(expand("~/.config/vim-shared/mappings.vim"))
  source ~/.config/vim-shared/mappings.vim
endif
" }
