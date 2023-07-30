" Install vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
"Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

Plug 'itchyny/lightline.vim'
Plug 'zhimsel/vim-stay'
Plug 'Yggdroot/indentLine'
Plug 'machakann/vim-highlightedyank'
Plug 'wincent/vim-clipper'
Plug 'rhysd/vim-clang-format'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'bitc/vim-bad-whitespace'

"Plug 'tribela/vim-transparent'
"Plug 'chriskempson/base16-vim'
"Plug 'mike-hearn/base16-vim-lightline'
"Plug 'tomasiser/vim-code-dark'
Plug 'NLKNguyen/papercolor-theme'

Plug 'chrisbra/vim-diff-enhanced'
Plug 'Uarun/vim-protobuf'
Plug 'cespare/vim-toml'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'wellle/context.vim'

Plug 'github/copilot.vim'

" Initialize plugin system
call plug#end()

function! PlugLoaded(name)
  return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, strpart(g:plugs[a:name].dir, 0, strlen(g:plugs[a:name].dir) - 1)) >= 0)
endfunction

"--------------------------------------------------------------------------------
" Basic configuration
"
syntax on
filetype plugin indent on

set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab

set cursorline
set ignorecase
set smartcase
set colorcolumn=100
set clipboard=unnamed
set mouse=a
set hlsearch
set incsearch

set fillchars+=vert:│
set fillchars+=fold:-
set fillchars+=diff:\ 

set number
set cmdheight=1

set t_Co=256
set background=dark
colorscheme PaperColor

"--------------------------------------------------------------------------------
" Folding configuration
"
set foldenable
set foldcolumn=1
set foldmethod=syntax
set foldlevelstart=99

hi Folded     ctermbg=NONE guibg=NONE
hi FoldColumn ctermbg=NONE guibg=NONE

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
" Easy split navigations
"
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"--------------------------------------------------------------------------------
" GUI config
"
set guifont=SFMonoNerdFontC-Regular:h13
"set guifont=D2Coding:h14

set guioptions-=m " remove Menu bar
set guioptions-=T " remove Tool bar
set guioptions-=r " remove Right bar
set guioptions-=L " remove Left bar

"--------------------------------------------------------------------------------
if PlugLoaded('vim-easy-align')
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

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
  " Some servers have issues with backup files, see #649.
  set nobackup
  set nowritebackup

  " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  " delays and poor user experience.
  set updatetime=300

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1):
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

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
  nnoremap <silent> K :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
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

  " Run the Code Lens action on the current line.
  nmap <leader>cl  <Plug>(coc-codelens-action)

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
  command! -nargs=0 Format :call CocActionAsync('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

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
if PlugLoaded('lightline.vim')
  set laststatus=2
  set noshowmode
  "  let g:lightline = {
  "    \ 'colorscheme': 'base16-google-dark'
  "    \ }
endif

"--------------------------------------------------------------------------------
if PlugLoaded('indentLine')
  "let g:indentLine_enabled = 0
  "let g:indentLine_char = '┆'
  "let g:indentLine_char = '|'
  let g:indentLine_char = '│'
  let g:indentLine_setColors = 0
  "let g:indentLine_color_term = 239
  "let g:indentLine_bgcolor_term = 202
  "let g:indentLine_color_gui = '#A4E57E'
  "let g:indentLine_bgcolor_gui = '#FF5F00'
  "let g:indentLine_color_tty_light = 7 " (default: 4)
  "let g:indentLine_color_dark = 1 " (default: 2)
endif

"--------------------------------------------------------------------------------
if PlugLoaded('vim-highlightedyank')
  let g:highlightedyank_highlight_duration = 1000
  "hi HighlightedyankRegion cterm=reverse gui=reverse
  if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
  endif
endif

"--------------------------------------------------------------------------------
if PlugLoaded('vim-clipper')
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
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)
endif

"--------------------------------------------------------------------------------
if PlugLoaded('vim-fugitive')
endif

"--------------------------------------------------------------------------------
if PlugLoaded('context.vim')
  autocmd VimEnter     * ContextActivate
  autocmd BufAdd       * call context#update('BufAdd')
  autocmd BufEnter     * call context#update('BufEnter')
  autocmd CursorMoved  * call context#update('CursorMoved')
  autocmd VimResized   * call context#update('VimResized')
  autocmd CursorHold   * call context#update('CursorHold')
  autocmd User GitGutter call context#update('GitGutter')
  autocmd OptionSet number,relativenumber,numberwidth,signcolumn,tabstop,list
        \                call context#update('OptionSet')

  if exists('##WinScrolled')
    autocmd WinScrolled * call context#update('WinScrolled')
  endif
endif

"--------------------------------------------------------------------------------
if PlugLoaded('vim-transparent')
  " default
  let g:transparent_groups = ['Normal', 'Comment', 'Constant', 'Special', 'Identifier',
        \ 'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String',
        \ 'Function', 'Conditional', 'Repeat', 'Operator', 'Structure',
        \ 'LineNr', 'NonText', 'SignColumn', 'CursorLineNr', 'EndOfBuffer']

  " Pmenu
  let g:transparent_groups += ['Pmenu']

  " coc.nvim
  let g:transparent_groups += ['NormalFloating', 'CocFloating']

  augroup transparent
    autocmd VimEnter,ColorScheme * call MyTransparent()
  augroup END

  function! MyTransparent()
    " Customize the highlight groups for transparency in here.

    " CursorLine
    hi CursorLine ctermfg=NONE ctermbg=239 guibg=NONE guibg=#4e4e4e

    " coc.nvim
    hi CocMenuSel ctermbg=239 guibg=#4e4e4e
  endfunction
endif

"--------------------------------------------------------------------------------
if PlugLoaded('base16-vim')
  if exists('$BASE16_THEME')
        \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
  endif
endif

"--------------------------------------------------------------------------------
if PlugLoaded('vim-github-dashboard')
	let g:github_dashboard = {}

	" Dashboard window position
	" - Options: tab, top, bottom, above, below, left, right
	" - Default: tab
	let g:github_dashboard['position'] = 'top'

	" Disable Emoji output
	" - Default: only enable on terminal Vim on Mac
	let g:github_dashboard['emoji'] = 0

	" Customize emoji (see http://www.emoji-cheat-sheet.com/)
	let g:github_dashboard['emoji_map'] = {
				\   'user_dashboard': 'blush',
				\   'user_activity':  'smile',
				\   'repo_activity':  'laughing',
				\   'ForkEvent':      'fork_and_knife'
				\ }

	" Command to open link URLs
	" - Default: auto-detect
	let g:github_dashboard['open_command'] = 'open'

	" API timeout in seconds
	" - Default: 10, 20
	let g:github_dashboard['api_open_timeout'] = 10
	let g:github_dashboard['api_read_timeout'] = 20

	" Do not set statusline
	" - Then you can customize your own statusline with github_dashboard#status()
	let g:github_dashboard['statusline'] = 0

	" GitHub Enterprise
	"let g:github_dashboard['api_endpoint'] = 'http://github.sec.samsung.net/api/v3'
	"let g:github_dashboard['web_endpoint'] = 'http://github.sec.samsung.net'
endif

"--------------------------------------------------------------------------------
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
" Custom colors
"
hi myCursorWordMatch ctermfg=015    ctermbg=208    guifg=#000000 guibg=#ff8700
"hi folded            cterm=none     ctermfg=yellow gui=none      guifg=yellow
"hi foldcolumn        ctermfg=yellow guifg=yellow
"hi CursorLine        term=reverse   ctermbg=000    guibg=darkgrey
"hi Search            ctermbg=022    guibg=#005f00
"hi CocHighlightText  term=reverse   ctermbg=222    guibg=#f2e496

"--------------------------------------------------------------------------------
" Etc.
"
nnoremap <F5> :match myCursorWordMatch /<C-R><C-W>/<CR>
autocmd CursorMoved * match

