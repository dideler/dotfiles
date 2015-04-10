" This .vimrc is inspired by others, best practices, coding styleguides, and
" personal preference. For help, in Vim type `:help <topic>`.
" Author: Dennis Ideler

set nocompatible " Don't need to be compatible with Vi at the expense of Vim.
set shell=sh " Vim assumes your shell is sh compatible and fish-shell isn't.
filetype off " Required for Vundle.
filetype plugin indent on " Required for Vundle and Pathogen.

" Download Vundle if you don't have it yet.
if !isdirectory(expand("~/.vim/bundle/vundle"))
  !mkdir -p ~/.vim/bundle
  !git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  let s:bootstrap=1
endif

" Set up Vundle.
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle-compatible plugins go here (typically listed by GitHub repo):
" TODO: Switch to vim-plug since Vundle isn't actively developed?
" Plugin 'croaky/vim-colors-github'
" Plugin 'endel/vim-github-colorscheme'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'chriskempson/base16-vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'gmarik/vundle'
Plugin 'junegunn/vim-emoji'  " CTRL-X CTRL-U to autocomplete.
Plugin 'kchmck/vim-coffee-script'
Plugin 'scrooloose/nerdtree'
Plugin 'spolu/dwm.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/closetag.vim'  " CTRL-_ to close tags.

" Vundle brief help
 " :Plugin
 " :PluginList          - list configured plugins
 " :PluginInstall(!)    - install (or update) plugins
 " :PluginUpdate        - update plugins
 " :PluginSearch(!) foo - search (or refresh cache first) for foo
 " :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
 "
 " see :h vundle for more details or wiki for FAQ
 " NOTE: comments after Plugin command are not allowed.

" Set some global variables for plugins. Can view value with `echo g:varname`.
let g:dwm_master_pane_width = 84 " Set width of master pane in dwm.vim. For percentages, use quotes.
autocmd VimResized * call DWM_ResizeMasterPaneWidth()

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

set completefunc=emoji#complete " Autocomplete emoji

" Run tasks from Vim without losing focus.
" E.g. :Dispatch bundle install
autocmd FileType ruby let b:dispatch = 'bundle exec rspec %'
nnoremap <F9> :Dispatch<CR>


" Install plugins if Vundle was just downloaded.
if exists("s:bootstrap") && s:bootstrap
  unlet s:bootstrap
  PluginInstall
endif


set modelines=0 " Prevent security exploits that use modelines.
set backspace=indent,eol,start " Allow backspacing over everything in INS mode.


" === UI ===
set title " Change terminal title.
set ruler " Show cursor position (line & column) in bottom right of statusline.
set number " Show line numbers.

" Instead of counting, use <line#>dG: deletes from the cursor to the given line.
" A plugin of interest is numbers.vim: http://myusuf3.github.com/numbers.vim/
""set relativenumber " Show line numbers relative to current line.

""set cursorline " Highlight current line.
set showcmd " Display an incomplete command in the lower right corner.
""set showmode " Display current mode in the lower right corner.
set hidden " Manage multiple buffers effectively. Hides buffers in background, not in a window.
set nostartofline " Keep the cursor in the same column (if possible).
""set laststatus=2 " Always show status line (default=1, show if multiple windows open).
""set statusline=%<%f\ %y[%{&ff}]%m%r%w%a\ %=%l/%L,%c%V\ %P " Improved status line.

set history=128 " Keep a history of up to 128 commands & searches.
""set undofile " Keep a history file so you can undo even after reopening Vim. Creates annoying .un~ files.
set undolevels=128 " Keep a history of the last 128 changes.
set nobackup " Don't create backup~ file.
""set nowritebackup "No backup file while editing.
set noswapfile " Don't create swap.swp file.
""set nowb " Prevents automatic write backup before overwriting file.
""set nobk " Prevents keeping of backup after overwriting the file.
""set autowrite " Auto-write if modified, on certain commands.
au FocusLost * :wa " Write all changes when window loses focus, and keep working.

command! W write " :W will write the file instead of complaining.
nnoremap Q <nop> " No more annoying command menu by accident.

" === Mouse ===
set ttymouse=xterm2 " Recognize mouse codes for xterm2 terminal type (default).
set mouse=a " Enable mouse for all modes.
set ttyfast " Send more characters for redraws (helps when using mouse for copy/paste).

" === Bells ===
""set errorbells " (off by default)
set noerrorbells " Shhh...
""set visualbell " Flash the screen instead. (off by default)
""set novisualbell

" === Search ====
set ignorecase " Ignore case when searching. Prefix search with \c to match case.
set smartcase " Become case sensitive when search contains a capital letter.
set showmatch " Show matching parenthesis.
set incsearch " Show search matches as you type.
set hlsearch " Highlight search terms.
set gdefault " Global substitutions (:%s/foo/bar/ replaces :%s/foo/bar/g).
set wildmenu " Lets you see possible commands during auto-completion.
set wildmode=list:longest " Auto-complete to the point of ambiguity.
""set wildmode=longest,full " First longest match, then full match.
set wildignore=.git,*.jpg,*.png,*.o,*.obj " Ignore files matched with these patterns.
""nnoremap / /\v " Use normal regexes search.
""vnoremap / /\v

autocmd BufRead,BufNewFile *.md setlocal spell textwidth=80 " Enable spell check for Markdown files and wrap at 80 chars.
setlocal spell spelllang=en_ca  " There's also en_gb and en_us, but I prefer Canadian spelling.
set complete+=kspell  " Autocomplete dictionary words with C-x + s when spell check is on. Add words to dictionary with 'zg'.

" Add spell checking and automatic wrapping at the recommended 72 columns to commit messages.
" Note that the summary line is recommended to be 50 chars max, though the GH limit is 69.
autocmd Filetype gitcommit setlocal spell textwidth=72

" === Indentation and formatting ===
set tabstop=2 " Tabs count as 2 spaces.
set shiftwidth=2 " Auto-indent uses 2 spaces.
set shiftround " Improved indentation when using >> and <<.
set expandtab " Expand tabs to spaces.

set wrap " Wrap lines on load (on by default) -- turn off with nowrap.
""set fo-=t " Don't automatically wrap when typing.
""set showbreak=--->  " Emphasize when a wrap occurs.
set textwidth=80 " Wrap after 80 characters.
set formatoptions=qrn1
"set colorcolumn=81 " Colour the column after exceeding the wrap by too far.

" Remove trailing whitespace for everything but markdown (via @gmurphey).
let whitespace_blacklist = ['markdown']
autocmd BufWritePre * if index(whitespace_blacklist, &ft) < 0 | :%s/\s\+$//e

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

set fileformat=unix
set encoding=utf-8 " The encoding displayed.
set fileencodings=utf8 " The encoding written to file.

set autoindent " autoindent does not interfere with other indentation settings.
filetype off " Don't try to autodetect file type.
""syntax on " Let Vim overrule my syntax highlighting settings with the defaults.
syntax enable " Keep my current colour settings.

" For all files, set the format options, turn off C indentation, and set the comments option to the default.
"autocmd FileType * set formatoptions=tcql
"      \nocindent comments&
" For all C and C++ files, set the formatoptions, turn on C indentation, and set the comments option.
"autocmd FileType c,cpp set formatoptions=croql
"      \cindent comments=sr:/*,mb:*,ex:*/,://

" Languages with other settings.
" shiftwidth == sw, tabstop == ts, softtabstop == sts
" expandtab changes new tabs to spaces.
" shiftwidth controls how many columns is indented with << and >>.
autocmd filetype html setlocal shiftwidth=2 tabstop=2
autocmd filetype ruby setlocal shiftwidth=2
autocmd filetype haml setlocal shiftwidth=2
autocmd filetype yaml setlocal shiftwidth=2
autocmd filetype javascript setlocal shiftwidth=2
autocmd filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd filetype scala setlocal foldmethod=indent

" === Folds ===
" http://vim.wikia.com/wiki/Use_folds_in_your_program
set foldmethod=indent " Groups of lines with same indent form a fold.
set foldnestmax=3 " Deepest fold is 3 levels.
set nofoldenable " Dont fold by default.
""set foldmethod=syntax " Folds defined by syntax highlighting.
""set foldlevelstart=99 " Start with all (99 levels of) folds open.

let mapleader = "," " Change start symbol of aliases/mappings.

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

" ,/ disables search highlighting.
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Unhighlight search.
nnoremap <leader><space> :noh<cr>

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
" cabbrev == ca
" iabbrev == ia  Insert mode only
" List all abbreviations with :ab

" Abbreviating the escape character, see above link for explanation.
" ab esc 
abbreviate #d #define
abbreviate #i #include
abbreviate #b /********************************************************
abbreviate #e *********************************************************/
abbreviate #l /*------------------------------------------------------*/

" C/C++ style function header. Note: ia[bbrev] is same as ab[breviate] but for Insert mode only.
iabbrev funcom /**<CR>*<CR>*/<Up>
abbreviate forl for (int i = 0; i < ; ++i)<esc>6hi
abbreviate cmain  int main(int argc, char** argv)<CR>{<CR>return 0;<CR>}

" Quick Python function definition.
autocmd FileType python abbreviate def def():<Left><Left><Left>

" Quick Ruby method definition.
autocmd FileType ruby abbreviate def def <CR>end<Up>

" Color scheme
" colorscheme github
" highlight NonText guibg=#060606
" highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Let's try base16 colours.
set background=dark
colorscheme base16-default

" Change color scheme when viewing Ruby files (torte is also pretty good).
autocmd FileType ruby colorscheme slate

" " Change color scheme when viewing HAML files.
" autocmd FileType haml colorscheme pablo

" " Change color scheme when viewing Markdown files.
" autocmd FileType markdown colorscheme torte

" Do a sudo write with w!!
" (note that `cabbrev` can be abbreviated to `ca`).
" abbreviate
cabbrev w!! w !sudo tee >/dev/null "%"

" An easier way to show the value of a setting (using `set` for a get is bad).
cabbrev get set?<Left>

" === NERDTree ===

let NERDTreeWinSize=35

" Toggle NERDTree (open/close).
noremap <F4> :NERDTreeToggle<CR>

" Open NERDTree if vim was opened with no arguments.
autocmd vimenter * if !argc() | NERDTree | endif

" Autoclose NERDTree if it's the only window left open.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Local config to override values in ~/.vimrc (useful if vimrc is shared).
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
