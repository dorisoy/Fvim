let g:clipboard = {
  \ 'name': 'FVimClipboard',
  \ 'copy': {
  \   '+': {lines, regtype -> rpcrequest(g:fvim_channel, 'set-clipboard', lines, regtype)},
  \   '*': {lines, regtype -> rpcrequest(g:fvim_channel, 'set-clipboard', lines, regtype)},
  \ },
  \ 'paste': {
  \   '+': {-> rpcrequest(g:fvim_channel, 'get-clipboard')},
  \ '*': {-> rpcrequest(g:fvim_channel, 'get-clipboard')},
  \ }
\ }

command! -nargs=0 FVimDetach call rpcnotify(g:fvim_channel, 'remote.detach')
command! -nargs=0 FVimToggleFullScreen call rpcnotify(g:fvim_channel, 'ToggleFullScreen')

command! -complete=expression -nargs=1 FVimCursorSmoothMove call rpcnotify(g:fvim_channel, 'cursor.smoothmove', <args>)
command! -complete=expression -nargs=1 FVimCursorSmoothBlink call rpcnotify(g:fvim_channel, 'cursor.smoothblink', <args>)
command! -complete=expression -nargs=1 FVimFontLineHeight call rpcnotify(g:fvim_channel, 'font.lineheight', <args>)
command! -complete=expression -nargs=1 FVimFontAutoSnap call rpcnotify(g:fvim_channel, 'font.autosnap', <args>)
command! -complete=expression -nargs=1 FVimFontAntialias call rpcnotify(g:fvim_channel, 'font.antialias', <args>)
command! -complete=expression -nargs=1 FVimFontLigature call rpcnotify(g:fvim_channel, 'font.ligature', <args>)
command! -complete=expression -nargs=1 FVimFontDrawBounds call rpcnotify(g:fvim_channel, 'font.drawBounds', <args>)
command! -complete=expression -nargs=1 FVimFontAutohint call rpcnotify(g:fvim_channel, 'font.autohint', <args>)
command! -complete=expression -nargs=1 FVimFontSubpixel call rpcnotify(g:fvim_channel, 'font.subpixel', <args>)
command! -complete=expression -nargs=1 FVimFontHintLevel call rpcnotify(g:fvim_channel, 'font.hintLevel', <args>)
command! -complete=expression -nargs=1 FVimFontNormalWeight call rpcnotify(g:fvim_channel, 'font.weight.normal', <args>)
command! -complete=expression -nargs=1 FVimFontBoldWeight call rpcnotify(g:fvim_channel, 'font.weight.bold', <args>)
command! -complete=expression -nargs=1 FVimFontNoBuiltinSymbols call rpcnotify(g:fvim_channel, 'font.nonerd', <args>)
command! -complete=expression -nargs=1 FVimKeyDisableShiftSpace call rpcnotify(g:fvim_channel, 'key.disableShiftSpace', <args>)
command! -complete=expression -nargs=1 FVimKeyAutoIme call rpcnotify(g:fvim_channel, 'key.autoIme', <args>)

" let! _ = nvim.``command!`` -complete=expression FVimUIMultiGrid 1 call rpcnotify(g:fvim_channel, 'ui.multigrid', <args>)
command! -complete=expression -nargs=1 FVimUIPopupMenu call rpcnotify(g:fvim_channel, 'ui.popupmenu', <args>)
" let! _ = nvim.``command!`` -complete=expression FVimUITabLine 1 call rpcnotify(g:fvim_channel, 'ui.tabline', <args>)
" let! _ = nvim.``command!`` -complete=expression FVimUICmdLine 1 call rpcnotify(g:fvim_channel, 'ui.cmdline', <args>)
command! -complete=expression -nargs=1 FVimUIWildMenu call rpcnotify(g:fvim_channel, 'ui.wildmenu', <args>)
" let! _ = nvim.``command!`` -complete=expression FVimUIMessages 1 call rpcnotify(g:fvim_channel, 'ui.messages', <args>)
" let! _ = nvim.``command!`` -complete=expression FVimUITermColors 1 call rpcnotify(g:fvim_channel, 'ui.termcolors', <args>)
" let! _ = nvim.``command!`` -complete=expression FVimUIHlState 1 call rpcnotify(g:fvim_channel, 'ui.hlstate', <args>)

command! -complete=expression -nargs=1 FVimDrawFPS call rpcnotify(g:fvim_channel, 'DrawFPS', <args>)
command! -complete=expression -nargs=1 FVimCustomTitleBar call rpcnotify(g:fvim_channel, 'CustomTitleBar', <args>)

command! -complete=expression -nargs=1 FVimBackgroundOpacity call rpcnotify(g:fvim_channel, 'background.opacity', <args>)
command! -complete=expression -nargs=1 FVimBackgroundComposition call rpcnotify(g:fvim_channel, 'background.composition', <args>)
command! -complete=expression -nargs=1 FVimBackgroundAltOpacity call rpcnotify(g:fvim_channel, 'background.altopacity', <args>)
command! -complete=expression -nargs=1 FVimBackgroundImage call rpcnotify(g:fvim_channel, 'background.image.file', <args>)
command! -complete=expression -nargs=1 FVimBackgroundImageOpacity call rpcnotify(g:fvim_channel, 'background.image.opacity', <args>)
command! -complete=expression -nargs=1 FVimBackgroundImageStretch call rpcnotify(g:fvim_channel, 'background.image.stretch', <args>)
command! -complete=expression -nargs=1 FVimBackgroundImageHAlign call rpcnotify(g:fvim_channel, 'background.image.halign', <args>)
command! -complete=expression -nargs=1 FVimBackgroundImageVAlign call rpcnotify(g:fvim_channel, 'background.image.valign', <args>)

function! s:fvim_on_bufwinenter()
  let l:bufnr=expand("<abuf>")
  let l:wins=win_findbuf(l:bufnr)
  call rpcnotify(g:fvim_channel, 'OnBufWinEnter', l:bufnr, l:wins)
endfunction

function! s:fvim_on_winenter()
  let l:win=nvim_get_current_win()
  let l:bufnr=nvim_win_get_buf(l:win)
  call rpcnotify(g:fvim_channel, 'OnBufWinEnter', l:bufnr, [l:win])
endfunction

function! s:fvim_on_cursorhold()
  let l:bufnr=nvim_get_current_buf()
  let l:signs=sign_getplaced(l:bufnr, {'group': '*'})
  call rpcnotify(g:fvim_channel, 'OnSignUpdate', l:bufnr, l:signs)
endfunction

function! s:fvim_on_vim_enter()
  runtime! ginit.vim
  if exists("g:gui_widgets")
    call GuiWidgetClientAttach(g:fvim_channel)
  endif
  delcommand FVimOnVimEnter
endfunction

function FVimTestGuiWidget()
  " :put =string(nvim_get_namespaces())
  "  {'lsp_cxx_hl_symbols_11_1': 11, 'coc-color': 13, 'vim_lsp_references': 3,
  "    'coc-codelens': 12, 'vim_lsp_diagnostics': 4, 'GuiWidget': 1,
  "    'lsp_cxx_hl_symbols_11_0': 10, 'lsp_cxx_hl_skipped_11_0': 8,
  "    'lsp_cxx_hl_skipped_11_1': 9, 'vim_lsp_signs': 5, 'hlyank': 2,
  "    'treesitter/highlighter': 6, 'coc-diagnosticlua': 7}
  "
  " :put =string(nvim_buf_get_extmarks(11,12,0,-1,{})
  "  [[258, 62, 0], [261, 64, 0], [254, 67, 0], [256, 72, 0], [262, 74, 0], 
  "   [257, 75, 0], [253, 76, 0], [264, 77, 0], [260, 78, 0], [263, 79, 0], 
  "   [255, 80, 0], [259, 84, 0]]

  let w1 = GuiWidgetPut("F:/test/1.png","image/png")
  let w2 = GuiWidgetPut("F:/test/2.png","image/png")
  call GuiWidgetPlace(w1, 0, 1, 0, 20, 5)
  call GuiWidgetPlace(w2, 0, 6, 0, 20, 5)
  call GuiWidgetUpdateView(0)
endfunction

command! -nargs=0 FVimOnVimEnter call <SID>fvim_on_vim_enter()

augroup FVim
  autocmd BufWinEnter * call <SID>fvim_on_bufwinenter()
  autocmd WinEnter * call <SID>fvim_on_winenter()
  autocmd CursorHold * call <SID>fvim_on_cursorhold()
  autocmd CursorHoldI * call <SID>fvim_on_cursorhold()
augroup END
