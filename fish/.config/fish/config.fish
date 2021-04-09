set -gx PATH ~/.fzf/bin/ /home/fdschmidt/.cargo/bin $PATH
set -x LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH
set -gx ALPHAVANTAGE_API_KEY "ZT0B722UX6NBPZME"
set -gx EDITOR /usr/bin/nvim
set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'
alias vi=nvim
source /home/fdschmidt/miniconda3/etc/fish/conf.d/conda.fish
eval (keychain --eval --agents ssh -Q --quiet id_rsa --nogui --noask)
