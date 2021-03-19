local M = {}

local function launch_conda_env()
    local conda_env = os.getenv('CONDA_PROMPT_MODIFIER')
    conda_env = conda_env and conda_env:sub(2, -3) or 'base'
    return 'conda activate ' .. conda_env .. ' && '
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
    side = side or 'right' -- default to 'right'

    if command ~= nil and string.find(command, 'python') then
        command = launch_conda_env() .. command
    end

    local api = vim.api
    if side == 'below' then
        api.nvim_command('botright split new') -- split a new window
        api.nvim_win_set_height(0, 10) -- set the window height
    elseif side == 'right' then
        api.nvim_command('botright vsplit new') -- split a new window
    end
    -- run your stuff here, could be anything
    if command == nil then
        api.nvim_call_function('termopen', {'$SHELL'})
    else
        command = "$SHELL -C '" .. command .. "'"
        api.nvim_call_function('termopen', {command})
    end
    local term_id = vim.b.terminal_job_id
    api.nvim_command('wincmd p') -- go back to previous window
    local cfg = {}
    cfg['jobid'] = term_id
    vim.b.slime_config = cfg
end

return M
