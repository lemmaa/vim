" Install vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'
Plug 'daviesjamie/vim-base16-lightline'
Plug 'zhimsel/vim-stay'
Plug 'Yggdroot/indentLine'
Plug 'machakann/vim-highlightedyank'
Plug 'wincent/vim-clipper'
Plug 'rhysd/vim-clang-format'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'bitc/vim-bad-whitespace'

" Initialize plugin system
call plug#end()

function! PlugLoaded(name)
  return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

"--------------------------------------------------------------------------------

syntax on
filetype plugin indent on

set shiftwidth=2
set tabstop=2
set softtabstop=2

"set fillchars+=vert:⎸
"set fillchars+=diff:\ 
"set fillchars+=fold:-
"set cursorline

set expandtab
set ignorecase
set smartcase
set colorcolumn=100
set clipboard=unnamed
set mouse=a
set hlsearch
set incsearch

"--------------------------------------------------------------------------------
"
" Folding configuration
"

set nofoldenable
set foldmethod=syntax
"set foldlevelstart=99

function! FoldText()
  let winwidth = winwidth(0)
        \ - &fdc
        \ - &number*&numberwidth
        \ - (&l:signcolumn is# 'yes' ? 2 : 0)

  let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
  let foldinfo = "   ( " . string(foldlinecount) . " lines )   "

  let tabreplace = repeat(" ", &tabstop)
  let foldstartline = substitute(getline(v:foldstart), '[\t]', tabreplace, 'g')

  if &foldmethod == "indent"
    let foldsummary = foldstartline . "..."
  else
    let foldendline = substitute(getline(v:foldend), '^\s*\(.\{-}\)\s*$', '\1', '')
    let foldsummary = foldstartline . "..." . foldendline
  endif

  let cuttedsummary = strpart(foldsummary, 0 , winwidth - len(foldinfo))
  let fillcharcount = winwidth - len(cuttedsummary) - len(foldinfo)

  return cuttedsummary . repeat(" ",fillcharcount) . foldinfo
endfunction

set foldtext=FoldText()

"--------------------------------------------------------------------------------
"
" Easy split navigations
" 
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"--------------------------------------------------------------------------------
"
" GUI config
"
"set guifont=D2Coding:h14
set guifont=SFMonoNerdFontC-Regular:h13

"--------------------------------------------------------------------------------
"
" Set termguicolors
"
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set guioptions-=m   " remove Menu bar
set guioptions-=T   " remove Tool bar
set guioptions-=r   " remove Right bar
set guioptions-=L   " remove Left bar

"--------------------------------------------------------------------------------
"
" Load plugin configurations
"

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('vim-easy-align')
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

"--------------------------------------------------------------------------------

"if PlugLoaded('vim-github-dashboard')
"endif

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('nerdtree')
  nmap <C-n> :NERDTreeToggle<CR>
  let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
  let g:NERDTreeNodeDelimiter = "\u00a0"
endif

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('tagbar')
  nmap <F8> :TagbarToggle<CR>
endif

"--------------------------------------------------------------------------------

if PlugLoaded('fzf.nvim')
  set rtp+=~/.fzf

  " " This is the default extra key bindings
  " let g:fzf_action = {
  "   \ 'ctrl-t': 'tab split',
  "   \ 'ctrl-x': 'split',
  "   \ 'ctrl-v': 'vsplit' }

  " An action can be a reference to a function that processes selected lines
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  " " Default fzf layout
  " " - down / up / left / right
  " let g:fzf_layout = { 'down': '~40%' }

  " " You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
  " let g:fzf_layout = { 'window': 'enew' }
  " let g:fzf_layout = { 'window': '-tabnew' }
  " let g:fzf_layout = { 'window': '10split enew' }

  " " Customize fzf colors to match your color scheme
  " let g:fzf_colors =
  " \ { 'fg':      ['fg', 'Normal'],
  "   \ 'bg':      ['bg', 'Normal'],
  "   \ 'hl':      ['fg', 'Comment'],
  "   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  "   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  "   \ 'hl+':     ['fg', 'Statement'],
  "   \ 'info':    ['fg', 'PreProc'],
  "   \ 'border':  ['fg', 'Ignore'],
  "   \ 'prompt':  ['fg', 'Conditional'],
  "   \ 'pointer': ['fg', 'Exception'],
  "   \ 'marker':  ['fg', 'Keyword'],
  "   \ 'spinner': ['fg', 'Label'],
  "   \ 'header':  ['fg', 'Comment'] }

  " " Enable per-command history.
  " " CTRL-N and CTRL-P will be automatically bound to next-history and
  " " previous-history instead of down and up. If you don't like the change,
  " " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
  " let g:fzf_history_dir = '~/.local/share/fzf-history'
endif

"--------------------------------------------------------------------------------

if PlugLoaded('coc.nvim')
  " Set internal encoding of vim, not needed on neovim, since coc.nvim using some
  " unicode characters in the file autoload/float.vim
  set encoding=utf-8

  " TextEdit might fail if hidden is not set.
  set hidden

  " Some servers have issues with backup files, see #649.
  set nobackup
  set nowritebackup

  " Give more space for displaying messages.
  set cmdheight=2

  " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  " delays and poor user experience.
  set updatetime=300

  " Don't pass messages to |ins-completion-menu|.
  set shortmess+=c

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  if has("nvim-0.5.0") || has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
  else
    set signcolumn=yes
  endif

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

endif

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('lightline.vim')
  set laststatus=2
  set noshowmode
  let g:lightline = {
        \   'colorscheme': 'wombat'
        \ }
endif

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('base16-vim')
  colorscheme base16-google-dark
endif

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('vim-base16-lightline')
  let g:lightline = {
        \   'colorscheme': 'base16'
        \ }
endif

"--------------------------------------------------------------------------------

if PlugLoaded('indentLine')
  "let g:indentLine_enabled = 0
  let g:indentLine_char = '┆'
  "let g:indentLine_char = '|'
  "let g:indentLine_char = '│'
  let g:indentLine_setColors = 1
  let g:indentLine_color_term = 239
  "let g:indentLine_bgcolor_term = 202
  let g:indentLine_color_gui = '#A4E57E'
  "let g:indentLine_bgcolor_gui = '#FF5F00'
  let g:indentLine_color_tty_light = 7 " (default: 4)
  "let g:indentLine_color_dark = 1 " (default: 2)
endif

"--------------------------------------------------------------------------------

if PlugLoaded('vim-highlightedyank')
  let g:highlightedyank_highlight_duration = 1000
  "highlight HighlightedyankRegion cterm=reverse gui=reverse
  if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
  endif
endif

"--------------------------------------------------------------------------------

if 1 "PlugLoaded('vim-clipper')
  let g:ClipperAddress = $CLIPPER_SERVER
  call clipper#set_invocation('nc -N $CLIPPER_SERVER 8377')
endif

"--------------------------------------------------------------------------------

if PlugLoaded('vim-clang-format')
  let g:clang_format#detect_style_file = 1
  "let g:clang_format#auto_format = 1
  "let g:clang_format#auto_format_on_insert_leave = 1
  let g:clang_format#auto_formatexpr = 1
  let g:clang_format#enable_fallback_style = 1

  "let g:clang_format#style_options = {
  "      \ "AccessModifierOffset" : -4,
  "      \ "AllowShortIfStatementsOnASingleLine" : "true",
  "      \ "AlwaysBreakTemplateDeclarations" : "true",
  "      \ "Standard" : "C++11"}

  " Map to <Leader>cf in C++ code
  autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

  " If you install vim-operator-user
  "autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

  " Toggle auto formatting:
  nmap <Leader>C :ClangFormatAutoToggle<CR>

  autocmd FileType c,cpp,objc ClangFormatAutoEnable
endif

"--------------------------------------------------------------------------------

if PlugLoaded('vim-gitgutter')
  nmap ]h <Plug>GitGutterNextHunk
  nmap [h <Plug>GitGutterPrevHunk
endif

"--------------------------------------------------------------------------------

if PlugLoaded('vim-fugitive')
endif

"--------------------------------------------------------------------------------

set cmdheight=1
"set background=dark

"--------------------------------------------------------------------------------
"
" Python formatting
"
au BufNewFile,BufRead *.py
      \ set autoindent |
      \ set colorcolumn=80 |
      \ set expandtab |
      \ set fileformat=unix |
      \ set shiftwidth=4 |
      \ set softtabstop=4 |
      \ set tabstop=4 |
      \ set textwidth=79 

"--------------------------------------------------------------------------------
"
" Custom colors
"
"hi  folded            cterm=none    ctermfg=yellow  gui=none        guifg=yellow
"hi  foldcolumn                      ctermfg=yellow                  guifg=yellow
"hi! myCursorWordMatch               ctermfg=015     ctermbg=208     guifg=#000000 guibg=#ff8700
"hi! CursorLine        term=reverse                  ctermbg=000                   guibg=darkgrey
"hi! Search                                          ctermbg=022                   guibg=#005f00
"hi! CocHighlightText  term=reverse                  ctermbg=222                   guibg=#f2e496

"--------------------------------------------------------------------------------
"
" Etc.
"
"nnoremap <F5> :match myCursorWordMatch /<C-R><C-W>/<CR>
"autocmd CursorMoved * match

