" This .vimrc is inspired by best practices, coding styleguides, and personal preference.
" Dennis Ideler (2012)

set nocompatible " Don't need to be compatible with Vi at the expense of Vim.

call pathogen#infect() " Entry point for adding plugins in ~/.vim/bundle to 'runtimepath'.
call pathogen#helptags() " Generate documentation for every plugin in 'runtimepath'.
filetype plugin indent on

filetype on " Try to autodetect file type.
syntax on " Let Vim overrule my syntax highlighting settings with the defaults.
"syntax enable " Keep my current colour settings.

" For all files, set the format options, turn off C indentation, and set the comments option to the default.
"autocmd FileType * set formatoptions=tcql
"      \nocindent comments&
" For all C and C++ files, set the formatoptions, turn on C indentation, and set the comments option.
"autocmd FileType c,cpp set formatoptions=croql
"      \cindent comments=sr:/*,mb:*,ex:*/,://

set modelines=0 " Prevent security exploits that use modelines.
set backspace=indent,eol,start " Allow backspacing over everything in INS mode.


" === UI ===
set title " Change terminal title.
set ruler " Show cursor position all the time.
set number " Show line numbers.
set relativenumber " Show line numbers relative to current line.
"set cursorline " Highlight current line.
set showcmd " Display an incomplete command in the lower right corner.
"set showmode " Display current mode in the lower right corner.
set hidden " Manage multiple buffers effectively. Hides buffers in background, not in a window.
set nostartofline " Keep the cursor in the same column (if possible).
"set laststatus=2 " Always show status line (default=1, show if multiple windows open).
"set statusline=%<%f\ %y[%{&ff}]%m%r%w%a\ %=%l/%L,%c%V\ %P " Improved status line.

set encoding=utf-8 " Encoding displayed.
set fileencodings=utf8 " Encoding written to file.
set history=256 " Keep a history of up to 256 commands & searches.

set nobackup " Don't create backup~ file.
set noswapfile " Don't create swap.swp file.
"set nowb " Prevents automatic write backup before overwriting file.
"set nobk " Prevents keeping of backup after overwriting the file.
"set autowrite " Auto-write if modified, on certain commands.
"set undofile " Keep a history file so you can undo even after reopening Vim.
au FocusLost * :wa " Write all changes when window loses focus, and keep working.

set ttymouse=xterm2 " (Should be by default.)
set mouse=a " Use 'n' for normal mode, 'a' is all modes.

" === Bells ===
"set errorbells " (off by default)
set noerrorbells " Shhh...
"set visualbell " Flash the screen instead. (off by default)
"set novisualbell

" === Search ====
set ignorecase " Ignore case when searching. Prefix search with \c to match case.
set smartcase " Become case sensitive when search contains a capital letter.
set showmatch " Show matching parenthesis.
set incsearch " Show search matches as you type.
set hlsearch " Highlight search terms.
set gdefault " Global substitutions (:%s/foo/bar/ replaces :%s/foo/bar/g).
set wildmenu " Lets you see possible commands during auto-completion.
set wildmode=list:longest " Auto-complete to the point of ambiguity.
"set wildmode=longest,full " First longest match, then full match.
set wildignore=.git,*.jpg,*.png,*.o,*.obj " Ignore files matched with these patterns.
"nnoremap / /\v " Use normal regexes search.
"vnoremap / /\v

" === Indentation and formatting ===
set tabstop=2 " Tabs count as 2 spaces.
set shiftwidth=2 " Auto-indent uses 2 spaces.
set expandtab " Expand tabs to spaces.

set wrap " Wrap lines (on by default).
"set showbreak=--->  " Emphasize when a wrap occurs.
set textwidth=80 " Wrap after 80 characters.
set formatoptions=qrn1
set colorcolumn=81 " Colour the column after exceeding the wrap by too far.

set autoindent " Turn on automatic indentation.
set smartindent " Autotab at start of the line. (cindent may be better)

" Languages with other settings.
autocmd filetype ruby setlocal sw=2
autocmd filetype haml setlocal sw=2
autocmd filetype yaml setlocal sw=2
autocmd filetype javascript setlocal sw=2
autocmd filetype python setlocal ts=4 sw=4 sts=4
autocmd filetype scala setlocal foldmethod=indent

" === Folds ===
" http://vim.wikia.com/wiki/Use_folds_in_your_program
set foldmethod=indent " Groups of lines with same indent form a fold.
set foldnestmax=3 " Deepest fold is 3 levels.
set nofoldenable " Dont fold by default.
"set foldmethod=syntax " Folds defined by syntax highlighting.
"set foldlevelstart=99 " Start with all (99 levels of) folds open.

let mapleader = "," " Change start symbol of aliases/mappings.

" === Mappings ===
" TODO test all mappings

" ,/ disables search highlighting.
nmap <silent> <leader>/ :nohlsearch<CR>

" F11 fixes tabs and kills trailing whitespace.
map <F11> m`:retab<CR>:%s/\s\+$//eg<CR>``

" ,W strips all trailing whitespace in current file.
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" ,w opens a new vertical split window and switches to it.
nnoremap <leader>w <C-w>v<C-w>l

" ,c closes current window.
nnoremap <leader>c :close

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

" Pres jj in insert mode to go to command/normal mode.
inoremap jj <ESC>

" Unhighlight search.
nnoremap <leader><space> :noh<cr>

" Tab navigation like a browser (courtesy of davvid from HN).
nmap <c-s-tab> :tabprevious<cr>
nmap <c-tab> :tabnext<cr>
map <c-s-tab> :tabprevious<cr>
map <c-tab> :tabnext<cr>
imap <c-s-tab> <esc>:tabprevious<cr>i
imap <c-tab> <esc>:tabnext<cr>i
nmap <c-t> :tabnew<cr>:e<space>
imap <c-t> <esc>:tabnew<cr>:e<space>

" Define abbreviations (see http://vimdoc.sourceforge.net/htmldoc/map.html#abbreviations).
" Abbreviating the escape character, see above link for explanation.
" ab esc 
ab #d #define
ab #i #include
ab #b /********************************************************
ab #e *********************************************************/
ab #l /*------------------------------------------------------*/

" C/C++ style function header. Note: ia[bbrev] is same as ab[breviate] but for Insert mode only.
ia funcom /**<CR>*<CR>*/<Up>
ab forl for (int i = 0; i < ; ++i)<esc>6hi
ab cmain  int main(int argc, char** argv)<CR>{<CR>return 0;<CR>}

" Do a sudo write with w!! (note that `cabbrev` can be abbreviated to `ca`).
ca w!! w !sudo tee >/dev/null "%"

" An easier way to show the value of a setting (using `set` for a get is bad).
cabbrev get set?<Left>

" Enter paste mode and give visual feedback.
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
