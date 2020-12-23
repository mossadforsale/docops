set nocompatible
set nu " Нумерация строк
set laststatus=2
set noshowmode
set list " включить подсветку
set listchars=tab:>-,trail:- " установить символы, которыми будет осуществляться подсветка
set cmdheight=1
set updatetime=50
filetype off
set shellslash
set scrolloff=3 " сколько строк внизу и вверху экрана показывать при скроллинге
colorscheme desert 
" Выключаем звук в Vim
set visualbell t_vb=
" Проблема красного на красном при spellchecking-е решается такой строкой в .vimrc
highlight SpellBad ctermfg=Black ctermbg=Red
au BufWinLeave *.* silent mkview " при закрытии файла сохранить 'вид'
au BufWinEnter *.* silent loadview " при открытии - восстановить сохранённый
set sessionoptions=curdir,buffers,tabpages " опции сессий - перейти в текущую директорию, использовать буферы и табы

"PLUGINS
call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'git://git.wincent.com/command-t.git'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'dracula/vim', {'name':'dracula'}
Plug 'chriskempson/base16-vim'

call plug#end()            " required
filetype plugin indent on    " required

" ОТСТУПЫ
set tabstop=4 
set shiftwidth=4
set smarttab
set expandtab 
set softtabstop=4 
set autoindent
set showtabline=1
let python_highlight_all = 1
set t_Co=256i
" Для указанных типов файлов отключает замену табов пробелами и меняет ширину отступа
au FileType crontab,fstab,make set noexpandtab tabstop=8 shiftwidth=8

autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd! bufwritepre * call BackupDir() " сделаем резервную копию перед записью буфера на диск
autocmd! bufwritepost $MYVIMRC source $MYVIMR " автоматически перечитывать конфигурацию vim после сохранения
" подсвечивает все слова, которые совпадают со словом под курсором.
autocmd CursorMoved * silent! exe printf("match Search /\\<%s\\>/", expand('<cword>'))

syntax on
set termencoding=utf-8
set visualbell
set browsedir=current
set t_vb= 
set backspace=indent,eol,start whichwrap+=<,>,[,]
set title " показывать имя буфера в заголовке терминала
set history=128 " хранить больше истории команд
set undolevels=2048 " хранить историю изменений числом N
set pastetoggle=

set wrap
set linebreak

set mouse=a " включает поддержку мыши при работе в терминале (без GUI)
set mousehide " скрывать мышь в режиме ввода текста
set showcmd " показывать незавершенные команды в статусбаре (автодополнение ввода)
set mps+=<:> " показывать совпадающие скобки для HTML-тегов
set showmatch " показывать первую парную скобку после ввода второй
set autoread " перечитывать изменённые файлы автоматически
set t_Co=256 " использовать больше цветов в терминале
set confirm " использовать диалоги вместо сообщений об ошибках

set backup
set noswapfile
set encoding=utf-8 
set fileencodings=utf8,cp1251

set clipboard=unnamed
set ruler
set hidden

"НАСТРОЙКИ ПОИСКА ТЕКСТА В ОТКРЫТЫХ ФАЙЛАХ
set ignorecase " ics - поиск без учёта регистра символов
set smartcase " - если искомое выражения содержит символы в верхнем регистре - ищет с учётом регистра, иначе - без учёта
set hlsearch " (не)подсветка результатов поиска (после того, как поиск закончен и закрыт)
set incsearch " поиск фрагмента по мере его набора
" поиск выделенного текста (начинать искать фрагмент при его выделении)
vnoremap <silent>* <ESC>:call VisualSearch()<CR>/<C-R>/<CR>
vnoremap <silent># <ESC>:call VisualSearch()<CR>?<C-R>/<CR>

"НАСТРОЙКИ СВОРАЧИВАНИЯ БЛОКОВ ТЕКСТА (фолдинг)
"set foldenable " включить фолдинг
"set foldmethod=syntax " определять блоки на основе синтаксиса файла
"set foldmethod=indent " определять блоки на основе отступов
"set foldcolumn=3 " показать полосу для управления сворачиванием
"set foldlevel=1 " Первый уровень вложенности открыт, остальные закрыты
"set foldopen=all " автоматическое открытие сверток при заходе в них
"set tags=tags\ $VIMRUNTIME/systags " искать теги в текущй директории и в указанной (теги генерируются ctags)

"НАСТРОЙКИ ПЕРЕКЛЮЧЕНИЯ РАСКЛАДОК КЛАВИАТУРЫ
set keymap=russian-jcukenwin " настраиваем переключение раскладок клавиатуры по <C-^>
set iminsert=0 " раскладка по умолчанию - английская
set imsearch=0 " аналогично для строки поиска и ввода команд
function! MyKeyMapHighlight()
   if &iminsert == 0 " при английской раскладке статусная строка текущего окна будет серого цвета
      hi StatusLine ctermfg=White guifg=White
   else " а при русской - зеленого.
      hi StatusLine ctermfg=DarkRed guifg=DarkRed
   endif
endfunction
call MyKeyMapHighlight() " при старте Vim устанавливать цвет статусной строки
autocmd WinEnter * :call MyKeyMapHighlight() " при смене окна обновлять информацию о раскладках
" использовать Ctrl+F для переключения раскладок
cmap <silent> <C-F> <C-^>
imap <silent> <C-F> <C-^>X<Esc>:call MyKeyMapHighlight()<CR>a<C-H>
nmap <silent> <C-F> a<C-^><Esc>:call MyKeyMapHighlight()<CR>
vmap <silent> <C-F> <Esc>a<C-^><Esc>:call MyKeyMapHighlight()<CR>gv

"НАСТРОЙКИ ГОРЯЧИХ КЛАВИШ
" F2 - сохранить файл
nmap <F2> :w<cr>
vmap <F2> <esc>:w<cr>i
imap <F2> <esc>:w<cr>i
" F3 - рекурсивный поиск по файлам (плагин grep.vim)
nnoremap <silent> <F3> :Rgrep<cr>
" Shift-F<F3> - добавление найденного к прошлым результатам поиска
nnoremap <silent> <S-F<F3>> :RgrepAdd<cr>
" Ctrl-F<F3> - поиск в открытых буферах
nnoremap <silent> <C-F<F3>> :GrepBuffer<cr>
" F5 - просмотр списка буферов
nmap <F5> <Esc>:buffers<cr>
vmap <F5> <esc>:buffers<cr>
imap <F5> <esc><esc>:buffers<cr>a
" при включенном плагине можно использовать его
nmap <S-F5> :BufExplorer<CR>
" F6 - предыдущий буфер
map <F6> :bp<cr>
vmap <F6> <esc>:bp<cr>i
imap <F6> <esc>:bp<cr>i
" F7 - следующий буфер
map <F7> :bn<cr>
vmap <F7> <esc>:bn<cr>i
imap <F7> <esc>:bn<cr>i
" F9 - сохранение файла и запуск компиляции (make)
map <F9> :w<cr>:make<cr>
vmap <F9> <esc>:w<cr>:make<cr>i
imap <F9> <esc>:w<cr>:make<cr>i
" F10 - включить-выключить браузер структуры документа (TagList)
map <F10> :TlistToggle<cr>
vmap <F10> <esc>:TlistToggle<cr>
imap <F10> <esc>:TlistToggle<cr>
" F11 - включить-выключить нумерацию строк
imap <F11> <Esc>:set<Space>nu!<CR>a
nmap <F11> :set<Space>nu!<CR>
" F12 - обозреватель файлов (:Ex для стандартного обозревателя,
" плагин NERDTree - дерево каталогов)
map <F12> :NERDTreeToggle<cr>
vmap <F12> <esc>:NERDTreeToggle<cr>i
imap <F12> <esc>:NERDTreeToggle<cr>i
"" Переключение табов (вкладок) (rxvt-style)
map <S-left> :tabprevious<cr>
nmap <S-left> :tabprevious<cr>
imap <S-left> <ESC>:tabprevious<cr>i
map <S-right> :tabnext<cr>
nmap <S-right> :tabnext<cr>
imap <S-right> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr>
nmap <S-down> :tabnew<cr>
imap <S-down> <ESC>:tabnew<cr>
nmap <C-w> :tabclose<cr>
imap <C-w> <ESC>:tabclose<cr>


"" Переключение кодировок файла
   " Меню Encoding -->
        " Выбор кодировки, в которой читать файл -->
            set wildmenu
            set wcm=<Tab>
            menu Encoding.Read.utf-8<Tab><F7> :e ++enc=utf8 <CR>
            menu Encoding.Read.windows-1251<Tab><F7> :e ++enc=cp1251<CR>
            menu Encoding.Read.koi8-r<Tab><F7> :e ++enc=koi8-r<CR>
            menu Encoding.Read.cp866<Tab><F7> :e ++enc=cp866<CR>
            map <F8> :emenu Encoding.Read.<TAB>
        " Выбор кодировки, в которой читать файл <--

        " Выбор кодировки, в которой сохранять файл -->
            set wildmenu
            set wcm=<Tab>
            menu Encoding.Write.utf-8<Tab><S-F7> :set fenc=utf8 <CR>
            menu Encoding.Write.windows-1251<Tab><S-F7> :set fenc=cp1251<CR>
            menu Encoding.Write.koi8-r<Tab><S-F7> :set fenc=koi8-r<CR>
            menu Encoding.Write.cp866<Tab><S-F7> :set fenc=cp866<CR>
            map <S-F7> :emenu Encoding.Write.<TAB>
        " Выбор кодировки, в которой сохранять файл <--

        " Выбор формата концов строк (dos - <CR><NL>, unix - <NL>, mac - <CR>) -->
            set wildmenu
            set wcm=<Tab>
            menu Encoding.End_line_format.unix<Tab><C-F7> :set fileformat=unix<CR>
            menu Encoding.End_line_format.dos<Tab><C-F7> :set fileformat=dos<CR>
            menu Encoding.End_line_format.mac<Tab><C-F7> :set fileformat=mac<CR>
            map <C-F7> :emenu Encoding.End_line_format.<TAB>
        " Выбор формата концов строк (dos - <CR><NL>, unix - <NL>, mac - <CR>) <--
    " Меню Encoding <--

    " Включение автоматического разбиения строки на несколько
    " строк фиксированной длины
    menu Textwidth.off :set textwidth=0<CR>
    menu Textwidth.on :set textwidth=78<CR>
    " Проверка орфографии -->
        if version >= 700
            " По умолчанию проверка орфографии выключена.
            set spell spelllang=
            set nospell
            menu Spell.off :setlocal spell spelllang=<CR>:setlocal nospell<CR>
            menu Spell.Russian+English :setlocal spell spelllang=ru,en<CR>
            menu Spell.Russian :setlocal spell spelllang=ru<CR>
            menu Spell.English :setlocal spell spelllang=en<CR>
            menu Spell.-SpellControl- :
            menu Spell.Word\ Suggest<Tab>z= z=
            menu Spell.Add\ To\ Dictionary<Tab>zg zg
            menu Spell.Add\ To\ TemporaryDictionary<Tab>zG zG
            menu Spell.Remove\ From\ Dictionary<Tab>zw zw
            menu Spell.Remove\ From\ Temporary\ Dictionary<Tab>zW zW
            menu Spell.Previous\ Wrong\ Word<Tab>[s [s
            menu Spell.Next\ Wrong\ Word<Tab>]s ]s
        endif
    " Проверка орфографии <--

        " Обертка для :make -->
        nmap ,m :call make<CR>
        nmap ,w :cwindow<CR>
        nmap ,n :cnext<CR>
        nmap ,p :cprevious<CR>
        nmap ,l :clist<CR>

        menu Make.Make<Tab>,m ,m
        menu Make.Make\ Window<Tab>,w ,w
        menu Make.Next\ Error<Tab>,n ,n
        menu Make.Previous\ Error<Tab>,p ,p
        menu Make.Errors\ List<Tab>,l ,l
    " Обертка для :make <--

    " Обновление ctags -->
        function! MyUpdateCtags()
            echo "Update ctags function is not setted."
        endfunction
        let MyUpdateCtagsFunction = "MyUpdateCtags"
        nmap <F4> :call {MyUpdateCtagsFunction}()<CR>
        menu ctags.Update<Tab><F4> <F4>
    " Обновление ctags <--

" C(trl)+d - дублирование текущей строки
imap <C-d> <esc>yypi
" Ctrl-пробел для автодополнения
inoremap <C-space> <C-x><C-o>
" C-e - комментировать/раскомментировать (при помощи NERD_Comment)
map <C-e> ,ci
nmap <C-e> ,ci
imap <C-e> <ESC>,cii
"" Вырезать-копировать-вставить через Ctrl
" CTRL-X - вырезать
vnoremap <C-X> "+x
" CTRL-C - копировать
vnoremap <C-C> "+y
" CTRL-V вставить под курсором
map <C-V>      "+gP
"" Отменить-вернуть через Ctrl
" отмена действия
noremap <C-Z> u
inoremap <C-Z> <C-O>u
" вернуть отменённое назад
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

