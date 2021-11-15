 
" (see https://rwx.gg/vi for help)
let skip_defaults_vim=1
set nocompatible

"####################### Vi Compatible (~/.exrc) #######################

" automatically indent new lines
set autoindent
" automatically write files when changing when multiple files open
set autowrite
" activate line numbers
set number
" turn col and row position on in bottom right
set ruler " see ruf for formatting
" show command and insert mode
set showmode

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" =>General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent
set smarttab

if v:version >= 800
  " stop vim from silently messing with files that it shouldn't
  set nofixendofline
  " better ascii friendly listchars
  set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
  " i hate automatic folding
  set foldmethod=manual
  set nofoldenable
endif

" mark trailing spaces as errors
match ErrorMsg '\s\+$'
" enough for line numbers + gutter within 80 standard
set textwidth=72
" replace tabs with spaces automatically
set expandtab
" disable relative line numbers, remove no to sample it
set norelativenumber
" makes ~ effectively invisible
"highlight NonText guifg=bg
" turn on default spell checking
set spell
" more risky, but cleaner
set nobackup
set noswapfile
set nowritebackup
set icon
" center the cursor always on the screen
"set scrolloff=999
" highlight search hits
set hlsearch
set incsearch
set linebreak
" avoid most of the 'Hit Enter ...' messages
set shortmess=aoOtTI
" prevents truncated yanks, deletes, etc.
set viminfo='20,<1000,s1000
" not a fan of bracket matching or folding
let g:loaded_matchparen=1
set noshowmatch
" wrap around when searching
set wrapscan
" stop complaints about switching buffer with changes
set hidden
" command history
set history=10000
" faster scrolling
set ttyfast

" Just the defaults, these are changed per filetype by plugins.
" Most of the utility of all of this has been superceded by the use of
" modern simplified pandoc for capturing knowledge source instead of
" arbitrary raw text files.

set fo-=t   " don't auto-wrap text using text width
set fo+=c   " autowrap comments using textwidth with leader
set fo-=r   " don't auto-insert comment leader on enter in insert
set fo-=o   " don't auto-insert comment leader on o/O in normal
set fo+=q   " allow formatting of comments with gq
set fo-=w   " don't use trailing whitespace for paragraphs
set fo-=a   " disable auto-formatting of paragraph changes
set fo-=n   " don't recognized numbered lists
set fo+=j   " delete comment prefix when joining
set fo-=2   " don't use the indent of second paragraph line
set fo-=v   " don't use broken 'vi-compatible auto-wrapping'
set fo-=b   " don't use broken 'vi-compatible auto-wrapping'
set fo+=l   " long lines not broken in insert mode
set fo+=m   " multi-byte character line break support
set fo+=M   " don't add space before or after multi-byte char
set fo-=B   " don't add space between two multi-byte chars
set fo+=1   " don't break a line after a one-letter word

" requires PLATFORM env variable set (in ~/.bashrc)
if $PLATFORM == 'mac'
  " required for mac delete to work
  set backspace=indent,eol,start
endif


" allow sensing the filetype
" Can be used with ftplugin folder
filetype plugin on

let mapleader=' '


" Edit/Reload vimr configuration file
nnoremap confe :e $HOME/.vimrc<CR>
au BufWritePost ~/.vimrc so ~/.vimrc

set ruf=%30(%=%#LineNr#%.50F\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %p%%%)

let g:pymode_python = 'python3'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function Plugsetup()
  !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
endfunction


" only load plugins if Plug detected
if filereadable(expand("~/.vim/autoload/plug.vim"))

  call plug#begin('~/.vimplugins')

  Plug 'sheerun/vim-polyglot'
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'rwxrob/vim-pandoc-syntax-simple'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

  Plug 'tpope/vim-fugitive'
  "Plug 'frazrepo/vim-rainbow'

  Plug 'mhinz/vim-startify'

  Plug 'mbbill/undotree'

  Plug 'morhetz/gruvbox'
  Plug 'joshdick/onedark.vim'
  Plug 'KeitaNakamura/neodark.vim'
  Plug 'romgrk/doom-one.vim'

  Plug 'mileszs/ack.vim'
  Plug 'dense-analysis/ale'

  Plug 'itchyny/lightline.vim'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  "Deoplete with tabnine
  "if has('nvim')
  "  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  "else
  "  Plug 'Shougo/deoplete.nvim'
  "  Plug 'roxma/nvim-yarp'
  "  Plug 'roxma/vim-hug-neovim-rpc'
  "  Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
  "endif
  "let g:deoplete#enable_at_startup = 1

  call plug#end()

  """"""""""""""""""""""""""""""""""""""
  "" Configure coc
  """"""""""""""""""""""""""""""""""""""
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  " use <tab> for trigger completion and navigate to the next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

  """""""""""""""""""""""""""""""""""""
  "lightline
  """""""""""""""""""""""""""""""""""""
  let g:lightline = {
  \ 'colorscheme': 'onedark',
  \}
  """"""""""""""""""""""""""""""""""""
  " rainbox
  """"""""""""""""""""""""""""""""""""
  " au FileType c,cpp,objc,objcpp call rainbow#load() " by type or ...
  let g:rainbow_active = 1                            " globally

  " pandoc
  let g:pandoc#formatting#mode = 'h' " A'
  let g:pandoc#formatting#textwidth = 72

  " golang
  let g:go_fmt_fail_silently = 0
  let g:go_fmt_command = 'goimports'
  let g:go_fmt_autosave = 1
  let g:go_gopls_enabled = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_variable_declarations = 1
  let g:go_highlight_variable_assignments = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_diagnostic_errors = 1
  let g:go_highlight_diagnostic_warnings = 1
  "let g:go_auto_type_info = 1 " forces 'Press ENTER' too much
  let g:go_auto_sameids = 0
  "let g:go_metalinter_command='golangci-lint'
  "let g:go_metalinter_command='golint'
  "let g:go_metalinter_autosave=1
  set updatetime=100
  "let g:go_gopls_analyses = { 'composites' : v:false }
  augroup go
    autocmd!
    au FileType go nmap <leader>t :GoTest!<CR>
    au FileType go nmap <leader>v :GoVet!<CR>
    au FileType go nmap <leader>b :GoBuild!<CR>
    au FileType go nmap <leader>c :GoCoverageToggle<CR>
    au FileType go nmap <leader>i :GoInfo<CR>
    au FileType go nmap <leader>l :GoMetaLinter!<CR>
  augroup END

  "Python highlighting
  let g:python_highlight_all = 1
else
  autocmd vimleavepre *.go !gofmt -w % " backup if fatih fails
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'alacritty'
    set t_Co=256
endif

set background=dark
colorscheme elflord

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac



highlight Normal guibg=black guifg=white
hi Normal ctermbg=None


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Undo Tree 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"UndoTree mapping to F5 for multi tree undo and redo
"nnoremap <F5> :UndotreeToggle<CR>
"
"



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual search and replace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Need visualselection tool
"vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Random
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fill in empty markdown links with duck.com search
" [some thing]() -> [some thing](https://duck.com/lite?kae=t&q=some thing)
" s,/foo,/bar,g
autocmd vimleavepre *.md !perl -p -i -e 's,\[([^\]]+)\]\(\),[\1](https://duck.com/lite?kd=-1&kp=-1&q=\1),g' %

"au FileType python !bash echo -e "#!/usr/bin/python\n# *-* coding: utf-8 *-*\n\nif __name__ == "__main__":\n\t"
"turn emoji :pomo: etc into actual emojis
autocmd BufWritePost *.md !toemoji % 

" make Y consitent with D and C (yank til end)
map Y y$

" better command-line completion
set wildmenu

" disable search highlighting with <C-L> when refreshing screen
nnoremap <C-L> :nohl<CR><C-L>

" enable omni-completion
set omnifunc=syntaxcomplete#Complete

" format perl on save
fun! s:Perltidy()
  let l:pos = getcurpos()
  silent execute '%!perltidy -i=2'
  call setpos('.', l:pos)
endfun
"autocmd FileType perl autocmd BufWritePre <buffer> call s:Perltidy()

" force some file names to be specific file type
au bufnewfile,bufRead *.bash* set ft=sh
au bufnewfile,bufRead *.{peg,pegn} set ft=config
au bufnewfile,bufRead *.profile set filetype=sh
au bufnewfile,bufRead *.crontab set filetype=crontab
au bufnewfile,bufRead *ssh/config set filetype=sshconfig
au bufnewfile,bufRead .dockerignore set filetype=gitignore
au bufnewfile,bufRead *gitconfig set filetype=gitconfig
au bufnewfile,bufRead /tmp/psql.edit.* set syntax=sql
au bufnewfile,bufRead doc.go set spell


" displays all the syntax rules for current position, useful
" when writing vimscript syntax plugins
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c






" functions keys
map <F1> :set number!<CR> :set relativenumber!<CR>
nmap <F2> :call <SID>SynStack()<CR>
set pastetoggle=<F3>
map <F4> :set list!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>



"=================================================================================
"
"   Following command and mappings are mapped to run the currently open code.
"   The default mapping is set to F5 like most code editors.
"   Change it as you feel comfortable with, keeping in mind that it does not
"   clash with any other keymapping.
"
"   NOTE: Compilers for different systems may differ. For example, in the case
"   of C and C++, we have assumed it to be gcc and g++ respectively, but it may
"   not be the same. It is suggested to check first if the compilers are installed
"   before running the code, or maybe even switch to a different compiler.
"
"   NOTE: Adding support for more programming languages
"
"   Just add another elseif block before the 'endif' statement in the same
"   way it is done in each case. Take care to add tabbed spaces after each
"   elseif block (similar to python). For example:
"
"   elseif &filetype == '<your_file_extension>'
"       exec '!<your_compiler> %'
"
"   NOTE: The '%' sign indicates the name of the currently open file with extension.
"         The time command displays the time taken for execution. Remove the
"         time command if you dont want the system to display the time
"
"=================================================================================
map <F5> :call CompileRun()<CR>
imap <F5> <Esc>:call CompileRun()<CR>
vmap <F5> <Esc>:call CompileRun()<CR>

func! CompileRun()
exec "w"
if &filetype == 'c'
    exec "!gcc % -o %<"
    exec "!time ./%<"
elseif &filetype == 'cpp'
    exec "!g++ % -o %<"
    exec "!time ./%<"
elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %"
elseif &filetype == 'sh'
    exec "!time bash %"
elseif &filetype == 'python'
    exec "!time python3 %"
elseif &filetype == 'html'
    exec "!google-chrome % &"
elseif &filetype == 'go'
    exec "!go build %<"
    exec "!time go run %"
elseif &filetype == 'matlab'
    exec "!time octave %"
endif
endfunc


map <F6> :set cursorline!<CR>
map <F7> :set spell!<CR>
map <F12> :set fdm=indent<CR>


" disable arrow keys (vi muscle memory)
noremap <up> :echoerr "Umm, use k instead"<CR>
noremap <down> :echoerr "Umm, use j instead"<CR>
noremap <left> :echoerr "Umm, use h instead"<CR>
noremap <right> :echoerr "Umm, use l instead"<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>
"
" better use of arrow keys, number increment/decrement
nnoremap <up> <C-a>
nnoremap <down> <C-x>

" Better page down and page up
noremap <C-n> <C-d>
noremap <C-p> <C-b>


" --------------------------- qwertimer's Configurations ---------------------------

"ab is used for autocorrect and autofill
ab myemail qwertimer@gmail.com
ab teh the



nmap <leader>n : <C-6>
"yank to xclip
vnoremap <silent><Leader>y "yy <Bar> :call system('xclip', @y)<CR>
" map ppp paste command to leader p
nmap <leader>p !!ppp<CR>
" map paste from last tempfile to leader l
nmap <leader>l :r `lasty`<CR>



" Set TMUX window name to name of file
"au fileopened * !tmux rename-window TESTING



""""""""""""""""""""""""""""""
" => Python mappings
""""""""""""""""""""""""""""""

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 



""""""""""""""""""""""""""""
" Set secondary leader
""""""""""""""""""""""""""""


let mapleader='\'



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale (syntax checker and linter)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8'],
\   'go': ['go', 'golint', 'errcheck']
\}

nmap <silent> <leader>a <Plug>(ale_next_wrap)

" Disabling highlighting
let g:ale_set_highlights = 0

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1

set omnifunc=ale#completion#OmniFunc


" read personal/private vim configuration (keep last to override)
set rtp^=~/.vimpersonal
set rtp^=~/.vimprivate
set rtp^=~/.vimwork

