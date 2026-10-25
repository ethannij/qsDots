hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "colors"
set background=dark

" Reading surface. Lifted off the window surface so the code stays readable,
" and taken from the same material palette as the rest of the desktop.
hi Normal guibg=#271e1a guifg=#f1dfd9
hi NormalNC guibg=#231a16 guifg=#f1dfd9
hi NormalFloat guibg=#322824 guifg=#f1dfd9
hi FloatBorder guibg=#322824 guifg=#a08d86
hi FloatTitle guibg=#322824 guifg=#ffb598

hi SignColumn guibg=#271e1a guifg=#a08d86
hi FoldColumn guibg=#271e1a guifg=#a08d86
hi LineNr guibg=#271e1a guifg=#a08d86
hi CursorLine guibg=#322824
hi CursorLineNr guibg=#322824 guifg=#ffb598
hi ColorColumn guibg=#322824
hi NonText guibg=#271e1a guifg=#53433e
hi EndOfBuffer guibg=#271e1a guifg=#271e1a
hi WinSeparator guibg=NONE guifg=#53433e
hi VertSplit guibg=NONE guifg=#53433e
hi Folded guibg=#231a16 guifg=#d8c2ba

hi Visual guibg=#5d4035 guifg=#ffdbce
hi Selection guibg=#231a16
hi Search guibg=#71361c guifg=#ffdbce
hi IncSearch guibg=#4f471b guifg=#f0e3a8
hi CurSearch guibg=#4f471b guifg=#f0e3a8
hi MatchParen guibg=#71361c guifg=#ffdbce

hi Pmenu guibg=#322824 guifg=#f1dfd9
hi PmenuSel guibg=#5d4035 guifg=#ffdbce
hi PmenuSbar guibg=#271e1a
hi PmenuThumb guibg=#a08d86

hi StatusLine guibg=#ffb598 guifg=#552008
hi StatusLineNC guibg=#71361c guifg=#ffdbce
hi TabLine guibg=#231a16 guifg=#d8c2ba
hi TabLineFill guibg=#1a110e
hi TabLineSel guibg=#271e1a guifg=#f1dfd9

hi Directory guifg=#ffb598
hi Title guifg=#ffb598

hi Comment guibg=NONE guifg=#a08d86
hi Delimiter guibg=NONE guifg=#f1dfd9
hi Operator guibg=NONE guifg=#f1dfd9
hi Todo guibg=NONE guifg=#f1dfd9
hi Identifier guibg=NONE guifg=#d4c78e
hi Constant guibg=NONE guifg=#d4c78e
hi Type guibg=NONE guifg=#e7beae
hi String guibg=NONE guifg=#ffb598
hi Special guibg=NONE guifg=#4f471b
hi PreProc guibg=NONE guifg=#4f471b
hi Function guibg=NONE guifg=#71361c
hi Statement guibg=NONE guifg=#5d4035

hi Error guibg=#93000a guifg=#ffdad6
hi ErrorMsg guibg=#93000a guifg=#ffdad6
hi WarningMsg guifg=#ffb4ab
