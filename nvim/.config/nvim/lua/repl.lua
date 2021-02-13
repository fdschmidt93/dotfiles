local M = {}

local function launch_conda_env()
    conda_env = os.getenv('CONDA_PROMPT_MODIFIER')
    if conda_env ~= nil then
        conda_env = 'conda activate ' .. string.sub(conda_env, 2, -3) .. ' && '
        return conda_env
    end
    return ''
end

function M.restart_ipython()
    -- find open shell
    -- enter shell
    -- exit ipython
    -- reopen ipython
    --
    --
end

function M.shell(side, command)
    side = side or "right" -- default to "right"
    
    if command ~= nil and string.find(command, "python") then
        command = launch_conda_env() .. command
    end

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
        command = "$SHELL -C '" .. command .. "'"
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
