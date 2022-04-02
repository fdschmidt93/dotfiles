set -gx PATH ~/.fzf/bin/ /home/fdschmidt/.cargo/bin $PATH
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
set -gx NVIM_LISTEN_ADDRESS "/tmp/nvimsocket"
alias vi=nvim
source /home/fdschmidt/miniconda3/etc/fish/conf.d/conda.fish
eval (keychain --eval --agents ssh -Q --quiet id_rsa --nogui --noask)
fish_vi_key_bindings
