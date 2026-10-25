hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "colors"
set background=dark

" Reading surface. Lifted off the window surface so the code stays readable,
" and taken from the same material palette as the rest of the desktop.
hi Normal guibg=#1d2024 guifg=#e2e2e9
hi NormalNC guibg=#191c20 guifg=#e2e2e9
hi NormalFloat guibg=#282a2f guifg=#e2e2e9
hi FloatBorder guibg=#282a2f guifg=#8e9099
hi FloatTitle guibg=#282a2f guifg=#aac7ff

hi SignColumn guibg=#1d2024 guifg=#8e9099
hi FoldColumn guibg=#1d2024 guifg=#8e9099
hi LineNr guibg=#1d2024 guifg=#8e9099
hi CursorLine guibg=#282a2f
hi CursorLineNr guibg=#282a2f guifg=#aac7ff
hi ColorColumn guibg=#282a2f
hi NonText guibg=#1d2024 guifg=#44474e
hi EndOfBuffer guibg=#1d2024 guifg=#1d2024
hi WinSeparator guibg=NONE guifg=#44474e
hi VertSplit guibg=NONE guifg=#44474e
hi Folded guibg=#191c20 guifg=#c4c6d0

hi Visual guibg=#3e4759 guifg=#dae2f9
hi Selection guibg=#191c20
hi Search guibg=#274777 guifg=#d6e3ff
hi IncSearch guibg=#563e5c guifg=#f9d8fd
hi CurSearch guibg=#563e5c guifg=#f9d8fd
hi MatchParen guibg=#274777 guifg=#d6e3ff

hi Pmenu guibg=#282a2f guifg=#e2e2e9
hi PmenuSel guibg=#3e4759 guifg=#dae2f9
hi PmenuSbar guibg=#1d2024
hi PmenuThumb guibg=#8e9099

hi StatusLine guibg=#aac7ff guifg=#09305f
hi StatusLineNC guibg=#274777 guifg=#d6e3ff
hi TabLine guibg=#191c20 guifg=#c4c6d0
hi TabLineFill guibg=#111318
hi TabLineSel guibg=#1d2024 guifg=#e2e2e9

hi Directory guifg=#aac7ff
hi Title guifg=#aac7ff

hi Comment guibg=NONE guifg=#8e9099
hi Delimiter guibg=NONE guifg=#e2e2e9
hi Operator guibg=NONE guifg=#e2e2e9
hi Todo guibg=NONE guifg=#e2e2e9
hi Identifier guibg=NONE guifg=#dcbce0
hi Constant guibg=NONE guifg=#dcbce0
hi Type guibg=NONE guifg=#bec7dc
hi String guibg=NONE guifg=#aac7ff
hi Special guibg=NONE guifg=#563e5c
hi PreProc guibg=NONE guifg=#563e5c
hi Function guibg=NONE guifg=#274777
hi Statement guibg=NONE guifg=#3e4759

hi Error guibg=#93000a guifg=#ffdad6
hi ErrorMsg guibg=#93000a guifg=#ffdad6
hi WarningMsg guifg=#ffb4ab
