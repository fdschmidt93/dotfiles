set -gx PATH ~/.fzf/bin/ /home/fdschmidt/.cargo/bin /home/fdschmidt/.local/bin/ $PATH
set -x LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH
set -gx ALPHAVANTAGE_API_KEY "ZT0B722UX6NBPZME"
set -gx EDITOR /usr/bin/nvim
set -x INITIAL_QUERY ""
set -x RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case "
set -x FZF_DEFAULT_COMMAND "$RG_PREFIX '$INITIAL_QUERY'" \
  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --height=50% --layout=reverse
set -gx FZF_CTRL_T_COMMAND "fd --hidden --strip-cwd-prefix"
set -gx FZF_ALT_C_COMMAND "fd --hidden -t d . $HOME"
set -gx MANPAGER 'nvim +Man!'
set -gx MANWIDTH 999
alias vi=nvim
alias vip="nvim '+PythonTerm'"
eval (keychain --eval --agents ssh -Q --quiet id_rsa --nogui --noask)
fish_vi_key_bindings
set PYDEVD_IPYTHON_COMPATIBLE_DEBUGGING 1

abbr ca conda activate
abbr za zathura

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniforge3/bin/conda
    eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
end

if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
    source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
end

# <<< conda initialize <<<
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end
