"==== basic ====================================================================
set nocompatible
set nopaste

set autowriteall
set number
set hlsearch
set incsearch
set autoindent

"set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set cursorline
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=black guibg=darkred guifg=black

set autoread

"set foldmethod=indent
set foldmethod=syntax
set nofoldenable

let mapleader=";"
filetype off	" required


let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

"==== ctags ====================================================================
"map <f4> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>  

"第一个命令里的分号是必不可少的。这个命令让vim首先在当前目录里寻找tags文件，如果没有找到  
"tags文件，或者没有找到对应的目标，就到父目录 中查找，一直向上递归。
"因为tags文件中记录的>路径总是相对于tags文件所在的路径，所以要使用第二个设置项来改变vim的当前目录。   
"set tags=tags;  
"set autochdir  
"绝对路径  
"set tags=/path/to/tags 

"==== cscope ===================================================================
"set cscopequickfix=s-,c-,d-,i-,t-,e-    
if has("cscope")
    set csprg=/usr/bin/cscope
    "set csto=1    
    "set cst    
    "set nocsverb    
    " add any database in current directory     
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    "set csverb    
endif

nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>

nnoremap <leader>ctcs :!find -L android/ linux/ \| grep -E '.cpp$\|.c$\|\.h$\|\.java$\|\.ams$' > cscope.files;<CR> :!ctags -R --c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+liaS --extra=+q android/;<CR> cscope -Rkbq;<CR> :cs add cscope.out<CR>  


"==== vundle pugin ====================================================================
" vundle install
"  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" vundle命令
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize                                                                                                                                                             
call vundle#begin() " 安装的所有插件

Plugin 'VundleVim/Vundle.vim' " 必须安装，let Vundle manage Vundle, required

Plugin 'flazz/vim-colorschemes' "主题

Plugin 'Lokaltog/vim-powerline' "底部状态栏

Plugin 'scrooloose/nerdtree' "文件目录

Plugin 'kien/ctrlp.vim' "快速查找

Plugin 'scrooloose/nerdcommenter' "快速注释

"自动补全
Plugin 'Shougo/neocomplcache.vim'
let g:ycm_server_python_interpreter='/usr/bin/python'
"---- ycm error fix ----
" 1. cd .vim/bundle/YouCompleteMe
" 2. ./install.sh --clang-completer
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tag_files = 1 "使用ctags生成的tags文件"

Plugin 'rdnetto/YCM-Generator'

Plugin 'jiangmiao/auto-pairs' "括号补全

Plugin 'Valloric/YouCompleteMe'

Plugin 'Syntastic' "语法分析

Plugin 'taglist.vim'

call vundle#end()            " required

filetype plugin indent on    " required

"colorscheme  codeschool"

"NERDTree 插件配置
map <leader>nt :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden = 1 "NERDTREE显示隐藏文件

autocmd BufWritePost $MYVIMRC source $MYVIMRC

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

filetype on
filetype plugin on

syntax enable
syntax on

" ctrlp setup
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|pyc|o)$'
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 100
let g:ctrlp_use_caching = 1
"let g:ctrlp_user_command = 'find %s -type f'

"==== Taglist ==================================================================
map <leader>tt :TlistToggle<CR> 
"let Tlist_Auto_Open = 1  "在启动VIM后，自动打开taglist窗口  
let Tlist_Ctags_Cmd = '/usr/bin/ctags'  "设定ctags的位置  
let Tlist_Use_Right_Window=0 " 1为让窗口显示在右边，0为显示在左边  
let Tlist_Show_One_File=1 "让taglist可以同时展示多个文件的函数列表，设置为1时不同时显示>多个文件的tag，只显示当前文件的  
"let Tlist_File_Fold_Auto_Close=1 "同时显示多个文件中的tag时，taglist只显示当前文件tag，>其他文件的函数列表折叠隐藏  
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动退出vim  
"let Tlist_Use_SingleClick= 1    " 缺省情况下，在双击一个tag时，才会跳到该tag定义的位置  
"let Tlist_Process_File_Always=0  "是否一直处理tags.1:处理;0:不处理  
let Tlist_WinWidth=60
"vertical resize -20

