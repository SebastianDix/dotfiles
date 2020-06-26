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
set nohlsearch

" navigation via :25t27 and similar commands is faster than 3j 5k
set number

" surrounding lines with #{{{ #}}} and typeng 'zm' in normal mode to fold
set foldmethod=marker

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
call plug#end()

" this serves to highlight cursorline
highlight LineNr ctermfg=DarkGrey
set cursorline
set cursorcolumn
highlight clear CursorLine
highlight cursorline ctermbg=17
highlight cursorcolumn ctermbg=17
highlight CursorLineNR ctermfg=red
set laststatus=2
func! STL()
	let stl = '%#DiffChange# %f %#StatusLine# [%{(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")}%R%H%W] %y [%p%%]'
	let barWidth = &columns - 69 " <-- wild guess
	let barWidth = barWidth < 3 ? 3 : barWidth

	if line('$') > 1
		let progress = (line('.')-1) * (barWidth-1) / (line('$')-1)
	else
		let progress = barWidth/2
	endif

	let pad = strlen(line('$'))-strlen(line('.')) + 3 - strlen(virtcol('.')) + 3 - strlen(line('.')*100/line('$'))
	let bar = repeat(' ',pad).' [%2*%'.barWidth.'.'.barWidth.'('
				\.repeat('-',progress )
				\.'%2*%#Diff#%p%%%1*'
				\.repeat('-',barWidth - progress - 1).'%0*%)%<]'


	" redir => mod
	" silent set modified?
	" redir END
	" if mod =~ "nomodified"
	" 	let stl = stl . "  WRITTEN  "
	" else
	" 	let stl = stl . "           "
	" endif

	let stl = "%#Search#" . $PWD . " %#StatusLine#" . stl
	let resolvedFileName=resolve(expand("%:p"))
	let fileDirectory=fnamemodify(resolvedFileName, ":h")
	let gitcommand = "git -C " . fileDirectory . " status -s " . resolvedFileName
	" let gitcommandresult=system(gitcommand)
	" let stl = stl . gitcommandresult

	return stl.bar

endfun
function! GetDir()
	let resolvedFileName=resolve(expand("%:p"))
	let fileDirectory=fnamemodify(resolvedFileName, ":h")
	echo fileDirectory
endfunction
"I don't know what the heck this is
hi def link User1 DiffAdd
hi def link User2 DiffDelete
set stl=%!STL()


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

" vsplit your vimrc
cnoremap <C-v> vsplit ~/.vimrc<cr>

" remaps
nnoremap ; :
nnoremap <F2> :!clear && %<cr>
inoremap <F2> <C-o>:w<CR>:!clear<CR>:!%<CR>
nnoremap <F12> <ESC>:set paste!<CR>
inoremap <silent> <F12> <ESC>:set paste!<CR>
nnoremap <F9> :so ~/.vimrc<CR>
nnoremap <F8> :!git add %<CR>
inoremap <F9> :so ~/.vimrc<CR>
nnoremap Q gg=G<C-o><C-o>
":let a = getcurpos()[1] \| silent execute "normal! gg=GG" \| execute a <CR>zz
imap <C-l> <C-o>x
" display list of buffers and 
nnoremap <F5> :buffers<CR>:buffer<Space>

" autosave
autocmd! TextChanged,TextChangedI <buffer> silent write

" autoclear before commanad
command! -nargs=1 R :!clear && <args>
" custom commands (invoked by typing ':' and your command
command! Vimrc :vsplit ~/.vimrc

"comment out lines of code
command! -range C <line1>,<line2>normal ^i#<esc>  
command! -range UC <line1>,<line2>normal ^x  

" cool way of displaying shell commands
command! -nargs=* -complete=shellcmd RW new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

"=====[ Highlight matches when jumping to next ]=============

" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>
" OR ELSE just highlight the match in red...
function! HLNext (blinktime)
	let [bufnum, lnum, col, off] = getpos('.')
	let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
	let target_pat = '\c\%#\%('.@/.'\)'
	let ring = matchadd('ColorColumn', target_pat, 101)
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
	call matchdelete(ring)
	redraw
endfunction

"==========[ English teaching feedback writer"]=========================
" highlighting the sections
highlight vocab ctermfg=red
highlight mistake ctermfg=green
highlight pron ctermfg=magenta
highlight gram ctermfg=blue
highlight homework ctermfg=darkyellow
autocmd BufRead,BufNewFile *.mcm call MoveMCM() 
function! MoveMCM ()
	set nohlsearch
	nnoremap <buffer> <Tab> /*\_s[[:upper:]]<cr>j
	nnoremap <buffer> <S-Tab> /*\_s[[:upper:]]<cr>NNj
	nnoremap <buffer> <C-m> :call SendData()<cr>
endfunction

function! InsertDate()
	" :s/Copyright \zs2007\ze All Rights Reserved/2008/
	execute "normal! :2s/Date: \zs.*\ze/\=strftime('%c')/g <CR>"
endfunction
function! GetStudent()
	execute "normal! 1G9ly$"
	return @"
endfunction

function! SendData()
	" TODO add name to provided data, the date and the time 
	let file = readfile(expand("%:p")) " read current file
	let matched = 0
	let matchedline = ""
	for line in file
		let match = matchstr(line, '^\* VOCAB.*') " regex match
		if(matched == 1)
			"echo line
			let matched = 0
			let matchedline = matchedline."{".line."}"
		endif 
		if(!empty(match))
			let matched = 1
			let matchedline = matchedline . line
			" your command with match
		endif
	endfor
	let date = strftime('%c')
	let matchedline = matchedline . "* Date " . date . GetStudent()
	echo matchedline
	call writefile([matchedline], "event.log", "a")

endfunction
function! s:DiffGitWithSaved()
	let filename = expand('%')
	let diffname = tempname()
	execute 'silent w! '.diffname
	execute '!git diff --color=always --no-index -- '.shellescape(filename).' '.diffname
endfunction
com! DiffGitSaved call s:DiffGitWithSaved()
nmap <leader>d :DiffGitSaved<CR>

" scrolling with ctrl u and ctrl dl
set scroll=3

" tell me if the file I am editing in this buffer (no matter the working
" directory) needs a commit or not  
" upon leaving this buffer, if it is uncommited, then tell me to commit it
" first! 

function! CheckGitStatusOfCurrentFile()
	let resolvedFileName=resolve(expand("%:p"))
	let fileDirectory=fnamemodify(resolvedFileName, ":h")
	let gitcommand = "git -C " . fileDirectory . " status -s " . resolvedFileName
	let gitcommandresult = system(gitcommand)[1]
	if gitcommandresult == "M"  
		echo "IT IS MODIFIED"
		return 1
	else
		echo "IT IS NOT MODIFIED"
		return 2
	endif
endfunction
command! GS call CheckGitStatusOfCurrentFile()
" autocmd! BufWinLeave,BufLeave call CheckGitStatusOfCurrentFile()

"commit file
function! CommitFunction(push)
	let resolvedFileName=resolve(expand("%:p"))
	let fileDirectory=fnamemodify(resolvedFileName, ":h")
	let gitdirchange="git -C " . fileDirectory
	let gitadd = gitdirchange .  " add " . resolvedFileName

	call inputsave()
	let message = input('Enter commit message: ')
	call inputrestore()
	execute '!clear && '.gitadd." && ".gitdirchange." commit -m \"".message."\""
	if a:push == 'push'
		execute '!clear && '.gitdirchange.' push'
	endif
endfunction
command! Commit call CommitFunction('commit')
command! Push call CommitFunction('push')
" yeah
function! Demo()
	let curline = getline('.')
	call inputsave()
	let name = input('Enter name: ')
	call inputrestore()
	call setline('.', curline . ' ' . name)
endfunction  

" attempt at overriding syntax highlighting
" Two ##s will match red
syntax match sebcomment1 /"*\s*##.*/
highlight sebcomment1 ctermbg=magenta

" Three #s will match orange
syntax match sebcomment2 /"*\s*###.*/
highlight sebcomment2 ctermbg=green

" Three #s will match orange
syntax match sebcomment3 /"*\s*####.*/
highlight sebcomment3 ctermbg=cyan

" enable this to use vim as a man page viewer according to vim.fandom.com
let $PAGER=''

" enable perisstent undo history
set undofile " Maintian undo history between sessions
set undodir=~/.vim/undodir

" hide all comments starting with #
command! FoldComments set foldmethod=expr | set foldexpr=getline(v:lnum)=~'^#' 
