
local M = {}

function M.shell(side, command)
    side = side or "right" -- default to "right"

    local api = vim.api
    if side == "below" then
        api.nvim_command('botright split new') -- split a new window 
        api.nvim_win_set_height(0, 10) -- set the window height
    elseif side == "right" then
        api.nvim_command('botright vsplit new') -- split a new window 
    end
    win_handle = api.nvim_tabpage_get_win(0) -- get the window handler
    buf_handle = api.nvim_win_get_buf(0) -- get the buffer handler
    -- run your stuff here, could be anything
    if command == nil then
        api.nvim_call_function("termopen", {"$SHELL"})
    else
        command = "$SHELL -C " .. command
        api.nvim_call_function("termopen", {command})
    end 
    -- jobID = api.nvim_command("terminal")
    term_id = vim.b.terminal_job_id
    api.nvim_command('wincmd p') -- go back to previous window
    cfg = {}
    cfg["jobid"] = term_id
    vim.b.slime_config = cfg
end

return M
