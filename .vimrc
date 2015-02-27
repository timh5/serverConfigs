" set tabstops/shift widths
se ts=4
se sw=4
syntax on


" dont indent code on paste
se paste

" not case sensitive in searches
se ignorecase

" When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

"folding settings: za=fold, zM=fold all, zR=unfold all
"set foldmethod=indent   "fold based on indent
"set foldnestmax=10      "deepest fold is 10 levels
"set nofoldenable        "dont fold by default
"set foldlevel=1         "this is just what i use

map ,v :sp ~/.vimrc<CR><C-W>_
map <silent> ,V :source $VIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" set the status line to look like 'ruler', plus buffer number at the end
set statusline=%<%f%h%m%r%w%y%=%l/%L,%c\ %P\ \|\ %n

" show matching parens
set showmatch


" MACROS {{{
"   c - javadoc style comment
"	cc- large comment section header
"   bc- bash comment 1 line
"   v - immediately after c, tab the block out one time
"   e - error_log
"   r - errorlog with print_r, for variable mapping


"	.qq - convert to qfetch, and thats it
"   .qs - convertQuery to qfetch str
"	.qi - to qfetch int
"	.qe - replace to qexec
"	.qei - replace to qexec
"	.r' - replace quoted $var as ?
"   .ri - replace quoted int $var
"	.re - replace quoted int $var at end of line
map .qq  f><RIGHT>vf(<LEFT>diqfetch<ESC>
map .qs  f><RIGHT>vf(<LEFT>diqfetch<ESC><RIGHT>f)i,'str',array($)<ESC>
map .qi  f><RIGHT>vf(<LEFT>diqfetch<ESC><RIGHT>f)i,'int',array($)<ESC>
map .qe  f><RIGHT>vf(<LEFT>diqexec<ESC><RIGHT>f)i,'str',array($)<ESC>
map .qei  f><RIGHT>vf(<LEFT>diqexec<ESC><RIGHT>f)i,'int',array($)<ESC>

map	.q'	f$<LEFT>_W<LEFT>vF$di?<ESC><RIGHT>
map	.qr	f$i?<ESC><RIGHT>vf <LEFT>d
map	.ql	f$i?<ESC><RIGHT>vf;<LEFT><LEFT>d
"						'$asdf' , '$asdf', '$asdf'  


"Comment out a line
map .c I/*<ESC>A*/<ESC>
"Uncomment a line
map .u 0f/<DEL><DEL><ESC>A<BACKSPACE><BACKSPACE><ESC>

"HTML comment out a line
map .hc I<!--<ESC>A--><ESC>
"HTML uncommenout out a line
map .hu 0f!<LEFT><DEL><DEL><DEL><DEL><ESC>A<BACKSPACE><BACKSPACE><BACKSPACE><ESC>

map _c o/**<CR> * <CR> * <CR> * @param <CR> * @param <CR> * @return <CR> */<UP><UP><UP><UP><UP>
map _bc 0i#<DOWN><ESC>
map _cc o/**<CR> * -------------------------------------------------------------------------<CR> *      <CR> * -------------------------------------------------------------------------<CR> */<UP><UP><RIGHT><RIGHT>
map _f o<CR>/**<CR> * <CR> * <CR> * @param <CR> * @param <CR> * @return <CR> */<CR>function ()<CR>{<CR><CR>}<CR><UP><UP><UP><UP><UP><UP><UP><UP><UP><UP><RIGHT><RIGHT><RIGHT>
map _v <ESC><UP>v<DOWN><DOWN><DOWN><DOWN><DOWN><DOWN><S->><DOWN><RIGHT>
map _e oerror_log(" ");<LEFT><LEFT><LEFT><LEFT>
map _r oerror_log(print_r(   ,true));<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>
map _d odbg(" ");<LEFT><LEFT><LEFT><LEFT>
map _dd odbd(  );<LEFT><LEFT><LEFT><LEFT>

"   Javascript macros
map _jd odbg("");<LEFT><LEFT><LEFT>
map _jf odbd("");<LEFT><LEFT><LEFT>

" 	Commenting
"cmap cb  ! sed 's/^/\/\//'o
"cmap uc :'<,'> ! sed 's/^\/\///'
" }}} MACROS


" comments
"map __c mz^i//<ESC>`z
"map __C mz^2x`z
"vmap __c <ESC>`<i/*<ESC>`>a*/<ESC>
"vmap __C <ESC>`<2x`>h2x




let mapleader='_'
" This allows me to quickly wrap any selection with some usual characters
" (quotes, angle quotes, parentheses, etc)
vnoremap <silent> <Leader>" :<C-u>call <SID>RD_wrapper('"')<CR>
vnoremap <silent> <Leader>' :<C-u>call <SID>RD_wrapper("'")<CR>
vnoremap <silent> <Leader>` :<C-u>call <SID>RD_wrapper('`')<CR>
vnoremap <silent> <Leader>{ :<C-u>call <SID>RD_wrapper('{')<CR>
vnoremap <silent> <Leader>( :<C-u>call <SID>RD_wrapper('(')<CR>
vnoremap <silent> <Leader>[ :<C-u>call <SID>RD_wrapper('[')<CR>
vnoremap <silent> <Leader>< :<C-u>call <SID>RD_wrapper('<')<CR>
vnoremap <silent> <Leader>t :<C-u>call <SID>RD_wrapper('t')<CR>
vnoremap <silent> <Leader>c :<C-u>call <SID>RD_wrapper('c')<CR>
nnoremap <silent> <Leader>W :call <SID>RD_unwrapper()<CR>
nnoremap <silent> <Leader>T :call <SID>RD_unwrap_tag()<CR>




" FUNCTIONS ------------------------------------------------------

" This function nicely wraps a selection within quotes, curly braces, square
" brackets, angle brackets, tags and more.
function s:RD_wrapper (str) range
    let l:allowed_strs = {
                \ '"' : ['"', '"'],
                \ "'" : ["'", "'"],
                \ '{' : ['{', '}'],
                \ '(' : ['(', ')'],
                \ '[' : ['[', ']'],
                \ '`' : ['`', '`'],
                \ '<' : ['<', '>'],
                \ 't' : ['', ''],
                \ 'c' : ['/*', '*/']
                \ }

    if has_key(l:allowed_strs, a:str) != 1
        echohl ErrorMsg
        echo 'Unknown wrapper: "' . a:str . '".'
        echohl None

        return 0
    endif

    " Wrap the selection with a tag.
    if a:str == 't'
        let l:tname = inputdialog('Tag name: ')
        if strlen(l:tname) < 1
            return 0
        endif
        let l:allowed_strs[a:str][0] = '<' . l:tname . '>'
        let l:allowed_strs[a:str][1] = '</' . l:tname . '>'
    endif

    let l:prefix = l:allowed_strs[a:str][0]
    let l:suffix = l:allowed_strs[a:str][1]
    let l:lenp = strlen(l:prefix)

    let l:old_x = @x
    let l:old_reg = @"

    let @x = l:prefix
    normal `<"xP
    let l:line1 = line('.')

    normal `>
    let l:line2 = line('.')

    if l:line1 == l:line2
        exe 'normal ' . lenp . 'l'
    endif

    let @x = l:suffix
    normal "xp

    " If we are wrapping the selection with a tag, lets put the cursor exactly
    " where the user can just press 'i' to start writing the attributes.
    if a:str == 't'
        normal h%h%
    endif

    let @x = l:old_x
    let @" = l:old_reg

    return 1
endfunction

" Similar to the RD_wrapper function, this one removes the quotes, curly
" braces, etc.
function s:RD_unwrapper () range
    let l:allowed_strs = ['"', "'", '{', '}', '(', ')', '[', ']', '`', '<', '>']
    let l:xml_types = ['xhtml', 'html', 'xml']
    let l:str = strpart(getline('.'), col('.') - 1, 1)

    if index(l:allowed_strs, l:str) == -1

        " If this is a known XML/SGML file type, then try to strip the current
        " tag
        if index(l:xml_types, &filetype) != -1
            return <SID>RD_unwrap_tag()
        endif

        echohl ErrorMsg
        echo 'The character under the cursor was not recognized: "' . l:str . '"'
        echohl None

        return 0
    endif

    let l:old_x = @x
    let l:old_reg = @"

    exe 'normal vi' . l:str . 'v'

    normal `<X
    let l:line1 = line('.')

    normal `>
    let l:line2 = line('.')
    if(l:line1 != l:line2)
        normal l
    endif
    normal x

    let @x = l:old_x
    let @" = l:old_reg

    return 1
endfunction


set diffexpr=MyDiff()
function MyDiff()
   let opt = ""
   if &diffopt =~ "icase"
	 let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
	 let opt = opt . "-w "
   endif
   silent execute "!diff -a --binary -w " . opt . v:fname_in . " " . v:fname_new .
	\  " > " . v:fname_out
endfunction

se so=6
