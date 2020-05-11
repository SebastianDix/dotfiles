" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
	syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
	filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" this is the best colorscheme imo
colorscheme desert

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

" highlight search results ( I guess )
set hlsearch

" navigation via :25t27 and similar commands is faster than 3j 5k
set number

" surrounding lines with #{{{ #}}} and typeng 'zm' in normal mode to fold
set foldmethod=marker

" this serves to highlight cursorline
highlight LineNr ctermfg=DarkGrey
set cursorline
highlight clear CursorLine
highlight CursorLineNR ctermfg=red
set laststatus=2
func! STL()
	let stl = '%f [%{(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")}%M%R%H%W] %y [%l/%L,%v] [%p%%]'
	let barWidth = &columns - 65 " <-- wild guess
	let barWidth = barWidth < 3 ? 3 : barWidth

	if line('$') > 1
		let progress = (line('.')-1) * (barWidth-1) / (line('$')-1)
	else
		let progress = barWidth/2
	endif

	let pad = strlen(line('$'))-strlen(line('.')) + 3 - strlen(virtcol('.')) + 3 - strlen(line('.')*100/line('$'))
	let bar = repeat(' ',pad).' [%1*%'.barWidth.'.'.barWidth.'('
				\.repeat('-',progress )
				\.'%2*0%1*'
				\.repeat('-',barWidth - progress - 1).'%0*%)%<]'
	return stl.bar
endfun


"I don't know what the heck this is
hi def link User1 DiffAdd
hi def link User2 DiffDelete
set stl=%!STL()

" custom commands (invoked by typing ':' and your command
command! Vimrc :e ~/.vimrc
cnoremap <C-v> vsplit ~/.vimrc<cr>

" snippets
nnoremap ,bashif :-1read ${HOME}/.vim/snippets/bashif.sh<CR>2f[a
nnoremap ,colors :-1read ${HOME}/.vim/snippets/colors.sh<CR>2f[a
nnoremap ,bashreadfile :-1read ${HOME}/.vim/snippets/bashreadfile.sh<CR>2f[a
nnoremap ,bashiterate :-1read ${HOME}/.vim/snippets/bashiterate.sh<CR>2f[a
nnoremap ,bashmultiline :-1read ${HOME}/.vim/snippets/bashmultiline.sh<CR>1f[a
nnoremap ,bashwhile :-1read ${HOME}/.vim/snippets/bashwhile.sh<CR>2f[a

" clevertab
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

" remaps
nnoremap ; :
nnoremap <F2> :!clear && %<cr>
inoremap <F2> <C-o>:w<CR>:!clear<CR>:!%<CR>
nnoremap <F12> <ESC>:set paste!<CR>
nnoremap <F9> :so ~/.vimrc<CR>
nnoremap <F8> :!git add %<CR>
inoremap <F9> :so ~/.vimrc<CR>
nnoremap Q gg=GG<CR>
imap <C-l> <C-o>x
" display list of buffers and 
nnoremap <F5> :buffers<CR>:buffer<Space>

" autosave
autocmd TextChanged,TextChangedI <buffer> silent write

" autoclear before command
command! -nargs=1 R :!clear && <args>
