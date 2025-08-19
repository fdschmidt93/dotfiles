set -gx PATH ~/.fzf/bin/ $HOME/.cargo/bin $HOME/.local/bin/ $PATH
set -x LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH
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
fzf --fish | source
set PYDEVD_IPYTHON_COMPATIBLE_DEBUGGING 1

abbr ca conda activate
abbr za zathura
abbr winx xfreerdp3 /cert:tofu /sound /microphone +home-drive /sec:nla /d: /u:fdschmidt /p:RsvkMnnef29vogq /scale:100 +auto-reconnect /wm-class:"Windows" /v:127.0.0.1 /dynamic-resolution -grab-keyboard
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end
