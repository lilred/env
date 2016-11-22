set nocompatible                        " put the Improved in Vi Improved

if(!empty(glob("~/.vim/bundle/Vundle.vim")))
	set runtimepath+=~/.vim/bundle/Vundle.vim " 
	call vundle#begin()                     " 
	Plugin 'tpope/vim-sensible'             " 'a universal set of defaults that (hopefully) everyone can agree on'
	Plugin 'bling/vim-bufferline'           " show open buffers in command bar
	Plugin 'flazz/vim-colorschemes'         " syntax highlighting color pack
	Plugin 'fsharp/vim-fsharp'              " F# support
	Plugin 'racer-rust/vim-racer'           " Rust autocomplete support
	Plugin 'rust-lang/rust.vim'             " Rust support
	Plugin 'scrooloose/nerdtree'            " file system explorer
	Plugin 'sjl/gundo.vim'                  " 'super undo'
	Plugin 'tpope/vim-fugitive'             " git integration
	Plugin 'valloric/YouCompleteMe'         " autocomplete; slows down startup
	Plugin 'vim-airline/vim-airline'        " status line
	Plugin 'vim-airline/vim-airline-themes' " status line themes
	Plugin 'vim-syntastic/syntastic'        " error highlighting
	Plugin 'VundleVim/Vundle.vim'           " to prevent PluginClean from wiping out Vundle
	call vundle#end()                       " 
	filetype off                            " toggle filetype support to refresh supported file types
	filetype on                             " 
else
endif

" Degrade gracefully
if(empty(glob("~/.vim/bundle/vim-sensible")))
	! git clone https://github.com/tpope/vim-sensible.git $HOME/.vim/bundle/vim-sensible
endif
set runtimepath+=~/.vim/bundle/vim-sensible

let mapleader=","

set ttyfast                             " fast redraw
set lazyredraw                          " don't redraw in the middle of macros

set hidden                              " don't close automatically close buffers

set mouse=a                             " enable mouse in all modes

set background=dark                     " 
silent! colorscheme badwolf             " 

set number                              " show line numbers
set colorcolumn=81                      " ruler
set list                                " show whitespace
set showmatch                           " highlight matching parentheses

set showcmd                             " show command in bottom bar
set laststatus=2                        " always show status bar

let tabwidth = 4                        " 
let &tabstop     = tabwidth             " 
let &shiftwidth  = tabwidth             " 
let &softtabstop = tabwidth             " 

set hlsearch                            " highlight matches
" stop highlighting matches
nnoremap <leader><space> :nohlsearch<CR>

set foldenable                          " enable code folding
set foldlevelstart=10                   " only fold highly nested code by default
set foldnestmax=10                      " not sure this is actually necessary
" toggle folding
nnoremap <space> za
set foldmethod=indent                   " sometimes something else might be better

" move by visual line
nnoremap j gj
nnoremap k gk

" highlight last inserted text
" nnoremap gV `[v`]


if(exists(":GundoToggle"))
	" 'super undo' using gundo
	nnoremap <leader>u :GundoToggle<CR>
	if has('python3')
		let g:gundo_prefer_python3 = 1      " anything else breaks on Ubuntu 16.04+ 
	endif
end

" 'super save' (save current state)
nnoremap <leader>s :mksession<CR>

" nnoremap <leader>a :Ag

let g:ctrlp_match_window = 'bottom,order:ttb'  " 
let g:ctrlp_switch_buffer = 0           " 
let g:ctrlp_working_path_mode = 0       " 
" let g:ctrlp_user_command = 'ag %s -l --nocolor --hiden -g ""'

" allows cursor change in tmux mode
" 'These lines change the cursor from block cursor mode to vertical bar cursor mode when using tmux. Without these lines, tmux always uses block cursor mode.'
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

augroup configgroup
	autocmd!
	" languages with off-side rule
	autocmd FileType fsharp     setlocal expandtab
	autocmd FileType haskell    setlocal expandtab
	autocmd FileType haskell    setlocal tabstop=8
	autocmd FileType make       setlocal noexpandtab
	autocmd FileType python     setlocal expandtab      " PEP8
	autocmd FileType python     setlocal tabstop=4      " PEP8
	autocmd FileType python     setlocal softtabstop=4  " PEP8
	autocmd FileType python     setlocal shiftwidth=4   " PEP8
augroup END
