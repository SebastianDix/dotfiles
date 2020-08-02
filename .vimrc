" Debian boilerplate info {{{ 


" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim
" }}}
" {{{VIMRUNTIME/defaults.vim if not vimrc ...
" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1
" }}}
" Explanation of set nocompatible {{{
" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible
" }}}
" {{{ explanation of syntax highlighting
" Vim5 and later versions support syntax highlighting. 
" Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
	syntax on
endif
"}}}
" {{{ If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
"}}}
" Jump to last position on reopen {{{
"Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif " }}} 
" Filetype-based indentation and plugins {{{
" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
	filetype plugin indent on
endif " }}}
" Default options {{{
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
" }}}
" Source /etc/vim/vimrc.local {{{
" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif " }}} 
" basic preferencees (fold,color,highlight,number) {{{
" this is the best colorscheme imo
colorscheme desert
" do not highlight search esults
set nohlsearch
" setting default fold method
set foldmethod=marker
" indentation
" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'chr4/nginx.vim'
Plug 'tpope/vim-surround'
Plug 'gioele/vim-autoswap'
Plug 'ConradIrwin/vim-bracketed-paste'
call plug#end()
" }}}
" Cursorline highlighting {{{
set number
set cursorline
set cursorcolumn

highlight LineNr ctermfg=DarkGrey
highlight clear CursorLine " get rid of underline
highlight cursorline ctermbg=17
highlight cursorcolumn ctermbg=17
highlight CursorLineNR ctermfg=red
" }}} 
" status line {{{
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
	"	let stl = stl . "  WRITTEN  "
	" else
	"	let stl = stl . "           "
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
" end of statusline }}}
" snippets {{{
" nnoremap ,bashif :-1read ${HOME}/.vim/snippets/bashif.sh<CR>2f[a
" nnoremap ,colors :-1read ${HOME}/.vim/snippets/colors.sh<CR>2f[a
" nnoremap ,bashreadfile :-1read ${HOME}/.vim/snippets/bashreadfile.sh<CR>2f[a
" nnoremap ,bashiterate :-1read ${HOME}/.vim/snippets/bashiterate.sh<CR>2f[a
" nnoremap ,bashmultiline :-1read ${HOME}/.vim/snippets/bashmultiline.sh<CR>1f[a
" nnoremap ,bashwhile :-1read ${HOME}/.vim/snippets/bashwhile.sh<CR>2f[a
" }}}
" clevertab {{{
function! CleverTab()
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		return "\<Tab>"
	else
		return "\<C-N>"
	endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
" }}}

" remaps
cnoremap <C-v> vsplit ~/.vimrc<cr> " vsplit your vimrc
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

" attempt at overriding syntax highlighting {{{
" Two ##s will match red
syntax match sebcomment1 /"*\s*##RED##.*/
highlight sebcomment1 ctermbg=magenta

" Three #s will match orange
syntax match sebcomment2 /"*\s*##ORANGE##.*/
highlight sebcomment2 ctermbg=green

" Three #s will match orange
syntax match sebcomment3 /"*\s*##CYAN##.*/
highlight sebcomment3 ctermbg=cyan
" }}} 
" enable this to use vim as a man page viewer according to vim.fandom.com
let $PAGER=''

" enable perisstent undo history:q
set undofile " Maintian undo history between sessions
set undodir=~/.vim/undodir
" set textwidth to zero so that it doesn't automatically insert new lines when
" I don't want it to, like it did just
" now!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set tw=0

" hide all comments starting with #
command! FoldComments set foldmethod=expr | set foldexpr=getline(v:lnum)=~'\s*#' 

" custom folding {{{
set foldmethod=expr
set foldexpr=GetPotionFold(v:lnum)
set foldlevel=0

function! GetPotionFold(lnum)
	if getline(a:lnum) =~? '.*{{{.*'
		let g:isinblock='yes' 
	endif
	if getline(a:lnum) =~? '.*}}}.*' 
		let g:isinblock='nextone'
	endif
	if g:isinblock == 'nextone'
		let g:isinblock='no'
		return 1
	endif
	if getline(a:lnum) =~? '\v^\s*#.*$'
		return 1	
	endif
	if getline(a:lnum) =~? '\v^\s*$'
		return 1
	endif
	if g:isinblock == 'yes'
		return 1
	en
	return 0
endfunction
" autocmd! BufRead,BufNewFile *nginx* call NginxFold() }}}

" DESC function so that you can make notes about vim diff files before
function! Note()
	
	let prevmessage=system('test -e /tmp/gitdiffnote && cat /tmp/gitdiffnote')
	echo prevmessage
	let resolvedFileName=resolve(expand("%:p"))
	let fileDirectory=fnamemodify(resolvedFileName, ":h")
	call inputsave()
	let message = input("Enter note on current file: ")
	call inputrestore()
	call writefile(split(resolvedFileName." | ".message,"\n",1),glob("/tmp/gitdiffnote"),"a")
	execute "silent!clear && sed -i 's,^\s*,,g' /tmp/gitdiffnote"
endfunction
command! Note call Note()

function! EchoSleepClear(message)
	set cmdheight=2
	echo a:message | silent 1sleep 
	echo ""
	set cmdheight=1
	return
endfunction
command! DelNote call writefile([""],glob("/tmp/gitdiffnote")) | call EchoSleepClear("Deleted /tmp/gitdiffnote")

" wildmenu - how did I not know about his sooner?
set wildmenu
funct! Exec(command)
	redir =>output
	silent exec a:command
	redir END
	return output
endfunct!

" echoing oldfiles variable
function! EchoFunction()
	let oldfiles=join(v:oldfiles)
	silent "!echo ".oldfiles
	quit
endfunction
command! Echo call EchoFunction()

" command to Bubak enter debug variable echo
fun! DebugFunction()
	let linenum=(line(".")-1) 
	" exec line(".")-1."print"
	let line=getline(linenum)
	let varname = substitute(line, "=.*", "", "")	
	let assignment = substitute(line, ".\{-} =", "", "")	
	let toprint="echo -e \"\\n".varname." is \\n\$".varname."\""
	let curline=(line("."))
	execute "normal! i".toprint
endfun
command! Debug call DebugFunction()

" copy last terminal command into current line
command! Fc read !cat ${HOME}/.bash_history | tail -1

" wrapped lines look better{{{
" enable indentation
set breakindent

" ident by an additional 2 characters on wrapped lines, when line >= 40 characters, put 'showbreak' at start of line
set breakindentopt=shift:2,min:40,sbr

" append '>>' to indent
set showbreak=>> 
" }}}

" paste from internet without doing 5 commands
" getClipboard gets the 
command! Paste r !~/bin/getClipboard
command! Copy .w! /tmp/vimtoclip | !clear && cat /tmp/vimtoclip | ${HOME}/bin/setClipboard
" paste vim line into windows clipboard


" open Vimrc in a new tab
command! Tabvimrc tabedit ~/.vimrc

" F3 to repeat previous command
nnoremap <F3> :!!<CR>

" When leaving insert mode, indent
function! SebIndent() 
	let view=winsaveview() | execute "normal! ==" | call winrestview(view)
endfunction
autocmd! InsertLeave <buffer> call SebIndent()

inoremap <F5> <C-R>=ListMonths()<CR>
let snippets=system('ls ${HOME}/.vim/snippets | xargs')
let snippets=split(snippets)
let constant="snip__"
for snip in snippets
	execute "iabbrev ".constant.snip "<C-R>=system('cat ${HOME}/.vim/snippets/".snip."')<CR>"
endfor
call map(snippets,"g:constant.v:val")

func! ListSnippets(snippets)
	call complete(col('.'),a:snippets)
	return ''
endfunc
inoremap <F5> <C-R>=ListSnippets(snippets)<CR>
set path=.,/usr/include,~/scripts,~/bin

" be able to set paste during insert mode
nnoremap <F10> :set invpaste paste?<CR>
set pastetoggle=<F10>
set showmode

" fixing vimdiff
set diffexpr="diff -e"
