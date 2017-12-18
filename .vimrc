" For help, in Vim type `:help <topic>`.

set nocompatible " Don't need to be compatible with Vi at the expense of Vim.
set shell=sh " Vim assumes your shell is sh compatible and fish-shell isn't.

" Download vim-plug if missing.
if !filereadable(expand("~/.vim/autoload/plug.vim"))
  silent !echo 'Installing vim-plug...'
  !curl -fLo ~/.vim/autoload/plug.vim --progress-bar --create-dirs
     \  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrap=1
endif

" vim-plug usage
" :PlugInstall                 - install plugins
" :PlugUpdate                  - install or update plugins
" :PlugDiff                    - see updated changes from last PlugUpdate
" :PlugUpgrade                 - upgrade vim-plug itself
" :PlugStatus                  - check the status of plugins
" :PlugSnapshot [output path]  - generate script to restore current snapshot
" :PlugClean(!)                - (force) remove unused plugins

call plug#begin()

Plug 'Lokaltog/vim-easymotion'
Plug 'chriskempson/base16-vim'
Plug 'davidhalter/jedi-vim'
Plug 'junegunn/vim-emoji'  " CTRL-X CTRL-U to autocomplete.
Plug 'kchmck/vim-coffee-script'
Plug 'scrooloose/nerdtree'
Plug 'spolu/dwm.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'elixir-lang/vim-elixir'
Plug 'vim-scripts/closetag.vim'  " CTRL-_ to close tags.

call plug#end()

" === Configure some plugins. View global values with `echo g:varname`.
let g:dwm_master_pane_width = 84 " Set width of master pane in dwm.vim. For percentages, use quotes.
autocmd VimResized * call DWM_ResizeMasterPaneWidth()

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

set completefunc=emoji#complete " Autocomplete emoji

let NERDTreeWinSize=35
noremap <F4> :NERDTreeToggle<CR>  " Toggle NERDTree (open/close).
autocmd vimenter *  " Show NERDTree on empty open.
 \ if !argc()
 \ | NERDTree |
 \ endif
autocmd bufenter *  " Autoclose NERDTree if it's the only window left.
 \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary")
 \ | q |
 \ endif

" Run tasks from Vim (using Dispatcher) without losing focus.
" E.g. :Dispatch bundle install
autocmd FileType ruby let b:dispatch = 'bundle exec rspec %'
nnoremap <F9> :Dispatch<CR>

" Install plugins if Vundle was just downloaded.
if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PlugInstall
endif


set modelines=0 " Prevent security exploits that use modelines.
set backspace=indent,eol,start " Allow backspacing over everything in INS mode.

set title  " Change terminal title.
set ruler  " Show cursor position (line & column).
set number " Show line numbers.
set nostartofline " Keep the cursor in the same column when possible.
set backspace=2   " Backspace deletes like most programs in insert mode
set laststatus=2  " Always show status line.
set statusline=%<%f\ %y[%{&ff}]%m%r%w%a\ %=%l/%L,%c%V\ %P " Better status line.
set autowrite  " Automatically :write before running commands

" TODO: check out numbers.vim: http://myusuf3.github.com/numbers.vim/
""set relativenumber " Show line numbers relative to current line.

set undolevels=128 " Keep a history of the last 128 changes.
set nobackup " Don't create backup~ file.
set noswapfile " Don't create swap.swp file.
au FocusLost * :wa " Write all changes when window loses focus.

command! W write " :W will write the file instead of complaining.
nnoremap Q <nop> " No more annoying command menu by accident.

if !has('nvim')
  set ttymouse=xterm2 " Recognize mouse codes for xterm2 terminal type (default).
endif

set mouse=a " Enable mouse for all modes.
set ttyfast " Send more characters for redraws.

set ignorecase " Ignore case when searching...
set smartcase " Become case sensitive when search contains a capital letter.
set showmatch " Show matching parenthesis.
set incsearch " Show search matches as you type.
set hlsearch " Highlight search terms.
set gdefault " Global substitutions (:%s/foo/bar/ replaces :%s/foo/bar/g).
set wildmenu " Lets you see possible commands during auto-completion.
set wildmode=list:longest " Auto-complete to the point of ambiguity.
set wildignore=.git,*.jpg,*.png,*.o,*.obj " Ignore files matched with these patterns.

setlocal spelllang=en_ca  " Use Canadian spelling.
set complete+=kspell  " Autocomplete dictionary words with C-x + s when spell check is on. Add words to dictionary with 'zg'.

" Spell check Markdown and wrap at 80 chars.
autocmd BufRead,BufNewFile *.md setlocal spell textwidth=80

" Spell check commit messages and wrap at 72 chars.
" Note: Do not go over 69 chars for the summary line (GitHub will cut it).
autocmd Filetype gitcommit setlocal spell textwidth=72

" === Indentation and formatting ===
set tabstop=2    " Tabs count as 2 spaces.
set shiftwidth=2 " Auto-indent uses 2 spaces.
set shiftround   " Improved indentation when using >> and <<.
set expandtab    " Expand tabs to spaces.


" Remove trailing whitespace for everything but markdown (via @gmurphey).
let whitespace_blacklist = ['markdown']
autocmd BufWritePre * if index(whitespace_blacklist, &ft) < 0 | :%s/\s\+$//e

set textwidth=80   " Wrap after 80 characters.
set colorcolumn=+1 " Show column limit.
set formatoptions=qrn1

" Toggle 80 column marker
nnoremap <F5> :call ToggleColorColumn()<CR>
func! ToggleColorColumn()
    if exists("b:colorcolumnon") && b:colorcolumnon
        let b:colorcolumnon = 0
        exec ':set colorcolumn=0'
        echo 'length limit marker off'
    else
        let b:colorcolumnon = 1
        exec ':set colorcolumn=81'
        echo 'length limit marker on'
    endif
endfunc

" Use UNIX fileformat when possible.
au BufRead,BufNewFile * if &l:modifiable | setlocal fileformat=unix | endif

set encoding=utf-8 " The encoding displayed.
set fileencodings=utf8 " The encoding written to file.

set autoindent " autoindent does not interfere with other indentation settings.
filetype off " Don't try to autodetect file type.
""syntax on " Let Vim overrule my syntax highlighting settings with the defaults.
syntax enable " Keep my current colour settings.

" Languages with other settings.
" shiftwidth = sw, tabstop = ts, softtabstop = sts
" expandtab changes new tabs to spaces.
" shiftwidth controls how many columns is indented with << and >>.
autocmd filetype html setlocal shiftwidth=2 tabstop=2
autocmd filetype ruby setlocal shiftwidth=2
autocmd filetype haml setlocal shiftwidth=2
autocmd filetype yaml setlocal shiftwidth=2
autocmd filetype javascript setlocal shiftwidth=2
autocmd filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd filetype scala setlocal foldmethod=indent

set foldnestmax=3 " Deepest fold is 3 levels.
set nofoldenable  " Don't fold by default.

let mapleader = ","  " Change start symbol of aliases/mappings.

" === Mappings ===
" Recursive/Non-recursive
" (recursive means another mapping can use the mapping)
" map/noremap = all modes
" nmap/nnoremap = normal mode
" xmap/xnoremap = visual mode
" vmap/vnoremap = visual and select mode
" imap/inoremap = insert mode

" Q formats the current paragraph by automatically wrapping to text limit.
vnoremap Q gq
nnoremap Q gqap

" Unhighlight search.
nnoremap <leader><space> :nohlsearch<CR>

" F3 fixes whitespace: turns tabs to spaces and kills trailing whitespace.
noremap <F3> m`:retab<CR>:%s/\s\+$//eg<CR>``

" ,W strips all trailing whitespace in current file.
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" ,w opens a new vertical split window and switches to it.
nnoremap <leader>w <C-w>v<C-w>l

" ,c closes current window.
nnoremap <leader>c :close<CR>

" ,h switches to hex mode (stream vim's buffer through xxd).
nnoremap <leader>h :%!xxd<CR>

" ,n switch back from hex mode to normal mode.
nnoremap <leader>n :%!xxd -r<CR>

" ,ev opens ~/.vimrc in a vertical split window, ready to edit.
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" Edit my .vimrc file in a split.
"map <leader>v :sp ~/.vimrc<cr>

" Press space to clear search highlighting and any message already displayed.
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" Press jj (in insert mode) to go to command/normal mode.
inoremap jj <ESC>

" Press kk (in insert or visual mode) to save the file and go to normal mode.
inoremap kk <ESC> :write<CR>
vnoremap kk <ESC> :write<CR>

" Press qq to quickly quit while in normal mode.
noremap qq :quit<CR>

" Pretty print a JSON file using Python.
nnoremap json :%!python -m json.tool<CR>

" Tab navigation like a browser (courtesy of davvid from HN).
nmap <c-s-tab> :tabprevious<cr>
nmap <c-tab> :tabnext<cr>
map <c-s-tab> :tabprevious<cr>
map <c-tab> :tabnext<cr>
imap <c-s-tab> <esc>:tabprevious<cr>i
imap <c-tab> <esc>:tabnext<cr>i
nmap <c-t> :tabnew<cr>:e<space>
imap <c-t> <esc>:tabnew<cr>:e<space>

" Enter paste mode and give visual feedback.
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Autocompletion with ctrl+space.
inoremap <c-space> <c-n>
inoremap <Nul> <c-n>

" Resize the width of main pane to n/4 of the full window.
nmap ,.. :call DWM_mod_align(3)<CR>
nmap .,, :call DWM_mod_align(1)<CR>
function! DWM_mod_align(n)
  execute "1wincmd w"
  execute "vertical resize ".(&columns * a:n) / 4
endfunction

" Shift + Arrow selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

" Map copy, cut, and paste to what they should be.
vnoremap <C-c> "+y
vnoremap <C-x> "+x
map <C-v> "+gP

" === Abbreviations ===
" abbreviate == ab
" cabbrev == ca  Command mode only
" iabbrev == ia  Insert mode only
" List all abbreviations with :ab

" C/C++ style function header.
iabbrev funcom /**<CR>*<CR>*/<Up>
abbreviate forl for (int i = 0; i < ; ++i)<esc>6hi
abbreviate cmain  int main(int argc, char** argv)<CR>{<CR>return 0;<CR>}

" Quick Python function definition.
autocmd FileType python abbreviate def def():<Left><Left><Left>

" Quick Ruby method definition.
autocmd FileType ruby abbreviate def def <CR>end<Up>

" Change color scheme when viewing Ruby files (torte is also pretty good).
autocmd FileType ruby colorscheme slate

" Change color scheme when viewing Markdown files.
autocmd FileType markdown colorscheme torte

" Do a sudo write with w!!
cabbrev w!! w !sudo tee >/dev/null "%"

" Turn the more intuitive `get` into `set?`.
cabbrev get set?<Left>

" Source config for fish shell after modifying it.
autocmd BufWritePost config.fish silent !fish -ic "source %"

" Change syntax highlighting for unrecognised words.
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red

" Local config to override values in ~/.vimrc (useful if vimrc is shared).
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
