hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "colors"
set background=dark

" Reading surface. Lifted off the window surface so the code stays readable,
" and taken from the same material palette as the rest of the desktop.
hi Normal guibg=#1c2023 guifg=#dfe3e7
hi NormalNC guibg=#181c1f guifg=#dfe3e7
hi NormalFloat guibg=#262b2e guifg=#dfe3e7
hi FloatBorder guibg=#262b2e guifg=#8b9297
hi FloatTitle guibg=#262b2e guifg=#8fcef3

hi SignColumn guibg=#1c2023 guifg=#8b9297
hi FoldColumn guibg=#1c2023 guifg=#8b9297
hi LineNr guibg=#1c2023 guifg=#8b9297
hi CursorLine guibg=#262b2e
hi CursorLineNr guibg=#262b2e guifg=#8fcef3
hi ColorColumn guibg=#262b2e
hi NonText guibg=#1c2023 guifg=#41484d
hi EndOfBuffer guibg=#1c2023 guifg=#1c2023
hi WinSeparator guibg=NONE guifg=#41484d
hi VertSplit guibg=NONE guifg=#41484d
hi Folded guibg=#181c1f guifg=#c0c7cd

hi Visual guibg=#364955 guifg=#d1e5f4
hi Selection guibg=#181c1f
hi Search guibg=#004c69 guifg=#c3e7ff
hi IncSearch guibg=#484264 guifg=#e6deff
hi CurSearch guibg=#484264 guifg=#e6deff
hi MatchParen guibg=#004c69 guifg=#c3e7ff

hi Pmenu guibg=#262b2e guifg=#dfe3e7
hi PmenuSel guibg=#364955 guifg=#d1e5f4
hi PmenuSbar guibg=#1c2023
hi PmenuThumb guibg=#8b9297

hi StatusLine guibg=#8fcef3 guifg=#003549
hi StatusLineNC guibg=#004c69 guifg=#c3e7ff
hi TabLine guibg=#181c1f guifg=#c0c7cd
hi TabLineFill guibg=#0f1417
hi TabLineSel guibg=#1c2023 guifg=#dfe3e7

hi Directory guifg=#8fcef3
hi Title guifg=#8fcef3

hi Comment guibg=NONE guifg=#8b9297
hi Delimiter guibg=NONE guifg=#dfe3e7
hi Operator guibg=NONE guifg=#dfe3e7
hi Todo guibg=NONE guifg=#dfe3e7
hi Identifier guibg=NONE guifg=#cac1ea
hi Constant guibg=NONE guifg=#cac1ea
hi Type guibg=NONE guifg=#b5c9d7
hi String guibg=NONE guifg=#8fcef3
hi Special guibg=NONE guifg=#484264
hi PreProc guibg=NONE guifg=#484264
hi Function guibg=NONE guifg=#004c69
hi Statement guibg=NONE guifg=#364955

hi Error guibg=#93000a guifg=#ffdad6
hi ErrorMsg guibg=#93000a guifg=#ffdad6
hi WarningMsg guifg=#ffb4ab
