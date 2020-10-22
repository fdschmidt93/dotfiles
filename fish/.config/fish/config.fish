set -gx EDITOR /usr/bin/nvim
set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'
set -gx PATH ~/.fzf/bin/ /opt/cuda/bin/ ~/.emacs.d/bin $PATH
set -x LD_LIBRARY_PATH /usr/local/lib/ /home/fdschmidt/intel/mkl/lib/intel64/ /opt/cuda/lib64/ $LD_LIBRARY_PATH
alias vi=nvim
source /home/fdschmidt/miniconda3/etc/fish/conf.d/conda.fish
eval (keychain --eval --agents ssh -Q --quiet id_rsa --nogui --noask)
set NVIM_LISTEN_ADDRESS /tmp/nvimsocket
set -gx ALPHAVANTAGE_API_KEY "ZT0B722UX6NBPZME"
