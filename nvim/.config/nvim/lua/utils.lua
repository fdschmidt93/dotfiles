M = {}
utils = {}

a = '全ä'
c = 'ä anda α'
b = '全角全角全角'
d = 'hallääääääääää'

-- function test(pos, wincol)
--     local ne

function utils.get_wincol(pos, start_pos)
    start_pos = start_pos or false
    -- pos {line, col} - {1, 0}-indexed
    -- set cursor
    vim.api.nvim_win_set_cursor(0, pos)

    local wincol = vim.fn.wincol()
    -- maximum retrieves synthetic end-of-char wincol
    -- required if right border character is multi-width
    if start_pos then
        vim.api.nvim_win_set_cursor(0, start_pos)
    end
    return wincol
end


function utils.edge_wincol(pos, wincol, maximum)
    maximum = maximum or false
    -- debug
    -- local test_wincol = utils.get_wincol(pos)
    -- if test_wincol ~= wincol then
    --     print('alarm alarm')
    -- end
    local new_pos = {pos[1], pos[2] + 1}
    local newcol = utils.get_wincol(new_pos)
    if maximum then
        if newcol > wincol then
            return newcol - 1
        else
            return utils.edge_wincol({new_pos[1], new_pos[2] + 1}, wincol, true)
        end
    else
        if newcol < wincol then
            return newcol + 1
        else
            return utils.edge_wincol({new_pos[1], new_pos[2] - 1}, wincol, false)
        end
    end
end

function M.get_visual_position()
    vim.cmd [[normal :esc<CR>]]
    line_v, col_v = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    line_cur, col_cur = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    return line_v, col_v, line_cur, col_cur
end

function M.visual_register()
    mode = vim.api.nvim_get_mode().mode
    local selection = ''    
    if mode == 'v' then
        vim.cmd([[silent exe "normal! `<']] .. mode .. [['>`y"']])
        -- vim.api.nvim_command('silent exe "normal! `[v`]y"')
    elseif mode == 'V' then
        vim.api.nvim_command([[silent exe "normal! '[V']y"]])
    end
    vim.api.nvim_command([[call setreg('"', @", 'V')]])
    selection = vim.api.nvim_call_function('getreg', {'"'})
    return selection
end

function M.print_mode()
    local mode = vim.api.nvim_get_mode().mode
    if mode == '' then
        mode = 'block mode'
    end
    return mode
end

M.set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui
  local link = options.link or false
  local target = options.target

  if not link then
    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
  else
    vim.cmd(string.format('hi! link', group, target))
  end
end

return M


