
M = {}

a = '全角'
b = '全角全角全角'
c = 'ä and α'
d = 'hallääääääääää'

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

-- function M.get_visual_region()
--     local line_start, column_start, line_end, column_end = M.visual_selection_range()
--     line_start = line_start - 1
--     line_end = line_end - 1
--     column_start = column_start - 1
--     column_end = column_end - 1
--     mode = vim.api.nvim_get_mode().mode
--     local region = vim.region(0, {line_start, column_start}, {line_end, column_end}, true)



return M



