hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "colors"
set background={{ mode }}

" Reading surface. Lifted off the window surface so the code stays readable,
" and taken from the same material palette as the rest of the desktop.
hi Normal guibg={{ colors.surface_container.default.hex }} guifg={{ colors.on_surface.default.hex }}
hi NormalNC guibg={{ colors.surface_container_low.default.hex }} guifg={{ colors.on_surface.default.hex }}
hi NormalFloat guibg={{ colors.surface_container_high.default.hex }} guifg={{ colors.on_surface.default.hex }}
hi FloatBorder guibg={{ colors.surface_container_high.default.hex }} guifg={{ colors.outline.default.hex }}
hi FloatTitle guibg={{ colors.surface_container_high.default.hex }} guifg={{ colors.primary.default.hex }}

hi SignColumn guibg={{ colors.surface_container.default.hex }} guifg={{ colors.outline.default.hex }}
hi FoldColumn guibg={{ colors.surface_container.default.hex }} guifg={{ colors.outline.default.hex }}
hi LineNr guibg={{ colors.surface_container.default.hex }} guifg={{ colors.outline.default.hex }}
hi CursorLine guibg={{ colors.surface_container_high.default.hex }}
hi CursorLineNr guibg={{ colors.surface_container_high.default.hex }} guifg={{ colors.primary.default.hex }}
hi ColorColumn guibg={{ colors.surface_container_high.default.hex }}
hi NonText guibg={{ colors.surface_container.default.hex }} guifg={{ colors.outline_variant.default.hex }}
hi EndOfBuffer guibg={{ colors.surface_container.default.hex }} guifg={{ colors.surface_container.default.hex }}
hi WinSeparator guibg=NONE guifg={{ colors.outline_variant.default.hex }}
hi VertSplit guibg=NONE guifg={{ colors.outline_variant.default.hex }}
hi Folded guibg={{ colors.surface_container_low.default.hex }} guifg={{ colors.on_surface_variant.default.hex }}

hi Visual guibg={{ colors.secondary_container.default.hex }} guifg={{ colors.on_secondary_container.default.hex }}
hi Selection guibg={{ colors.surface_container_low.default.hex }}
hi Search guibg={{ colors.primary_container.default.hex }} guifg={{ colors.on_primary_container.default.hex }}
hi IncSearch guibg={{ colors.tertiary_container.default.hex }} guifg={{ colors.on_tertiary_container.default.hex }}
hi CurSearch guibg={{ colors.tertiary_container.default.hex }} guifg={{ colors.on_tertiary_container.default.hex }}
hi MatchParen guibg={{ colors.primary_container.default.hex }} guifg={{ colors.on_primary_container.default.hex }}

hi Pmenu guibg={{ colors.surface_container_high.default.hex }} guifg={{ colors.on_surface.default.hex }}
hi PmenuSel guibg={{ colors.secondary_container.default.hex }} guifg={{ colors.on_secondary_container.default.hex }}
hi PmenuSbar guibg={{ colors.surface_container.default.hex }}
hi PmenuThumb guibg={{ colors.outline.default.hex }}

hi StatusLine guibg={{ colors.primary.default.hex }} guifg={{ colors.on_primary.default.hex }}
hi StatusLineNC guibg={{ colors.primary_container.default.hex }} guifg={{ colors.on_primary_container.default.hex }}
hi TabLine guibg={{ colors.surface_container_low.default.hex }} guifg={{ colors.on_surface_variant.default.hex }}
hi TabLineFill guibg={{ colors.surface.default.hex }}
hi TabLineSel guibg={{ colors.surface_container.default.hex }} guifg={{ colors.on_surface.default.hex }}

hi Directory guifg={{ colors.primary.default.hex }}
hi Title guifg={{ colors.primary.default.hex }}

hi Comment guibg=NONE guifg={{ colors.outline.default.hex }}
hi Delimiter guibg=NONE guifg={{ colors.on_surface.default.hex }}
hi Operator guibg=NONE guifg={{ colors.on_surface.default.hex }}
hi Todo guibg=NONE guifg={{ colors.on_surface.default.hex }}
hi Identifier guibg=NONE guifg={{ colors.tertiary.default.hex }}
hi Constant guibg=NONE guifg={{ colors.tertiary.default.hex }}
hi Type guibg=NONE guifg={{ colors.secondary.default.hex }}
hi String guibg=NONE guifg={{ colors.primary.default.hex }}
hi Special guibg=NONE guifg={{ colors.tertiary_container.default.hex }}
hi PreProc guibg=NONE guifg={{ colors.tertiary_container.default.hex }}
hi Function guibg=NONE guifg={{ colors.primary_container.default.hex }}
hi Statement guibg=NONE guifg={{ colors.secondary_container.default.hex }}

hi Error guibg={{ colors.error_container.default.hex }} guifg={{ colors.on_error_container.default.hex }}
hi ErrorMsg guibg={{ colors.error_container.default.hex }} guifg={{ colors.on_error_container.default.hex }}
hi WarningMsg guifg={{ colors.error.default.hex }}
