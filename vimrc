"
" Here begins the original Thoughtbot dotfiles
"

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    set updatetime=1000
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif


"""""""""""""""""""""""""""""""""
" Tandem Magix
" """""""""""""""""""""""""""""""

" Leader
let mapleader = " "

""" Visuals """
colorscheme solarized
set background=dark
set nonumber
set foldcolumn=2
hi FoldColumn ctermbg=None
hi vertsplit ctermbg=bg ctermbg=bg
set t_CO=256

" No scrollbars
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

""" Airline Setup
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_theme = 'solarized'

"-------------Mappings-------------"
" Make it easy to edit local .vimrc file.
nmap <Leader>ev :tabedit ~/.vimrc.local<cr>
nmap <Leader>ep :tabedit ~/.vimrc.bundles.local<cr>
nmap <Leader>es :edit ~/.vim/snippets
" Get rid of search hilight.
nmap <Leader><space> :nohlsearch<cr>

" Browse Tags.
nmap <C-R> :CtrlPBufTag<cr>
nmap <Leader>f :tag<space>

"-------------Laravel Specific--------"
nmap <Leader>lr :e routes/web.php<cr>
nmap <Leader>lm :! php artisan make:


"-------------Auto-Commands--------"
" Autoreload config file on save.
augroup autosourcing
	autocmd!
	autocmd BufWritePost ~/.vimrc.local source %
augroup END

"-----------PHP General settings --"
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

" Ale Linting
let g:ale_php_phpcs_standard="PSR2"
let g:ale_php_phpcbf_standard="PSR2"
let g:ale_javascript_eslint_suppress_eslintignore=1
let g:ale_javascript_eslint_suppress_missing_config=1
let g:ale_fix_on_save=1
let g:ale_fixers = {
      \   'javascript': [
      \       'eslint',
      \   ],
      \   'vue': [
      \       'eslint',
      \   ],
      \}

augroup php
	autocmd BufRead,BufNewFile *.php set tabstop=4
augroup END
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" Drupal *.module and *.install files.
augroup module
	autocmd BufRead,BufNewFile *.module set filetype=php
	autocmd BufRead,BufNewFile *.install set filetype=php
	autocmd BufRead,BufNewFile *.test set filetype=php
	autocmd BufRead,BufNewFile *.inc set filetype=php
	autocmd BufRead,BufNewFile *.profile set filetype=php
	autocmd BufRead,BufNewFile *.view set filetype=php
augroup END

augroup filetypedetect
  " Use :execute in order to use the drupaldetect#php_ext variable.
  execute 'autocmd BufRead,BufNewFile *.{' . drupaldetect#php_ext . '}'
        \ 'if drupaldetect#Check() | let  g:ale_php_phpcs_standard="drupal" | endif'
augroup END
"-------------Javascript-------------"
let g:vue_disable_pre_processors = 1
autocmd FileType vue syntax sync fromstart
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#include_keywords = 1
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'javascript.jsx',
                \ 'vue',
                \ ]

"-------------Emmet------------------"
let g:user_emmet_mode='a'

set exrc
set secure
" Editorconfig "
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Deoplete "
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#ternjs#docs = 1

" Supertab "
let g:SuperTabDefaultCompletionType = "<C-n>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
