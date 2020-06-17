set -gx EDITOR /usr/bin/nvim
set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'
set -gx PATH ~/.fzf/bin/ /opt/cuda/bin/ $PATH
set -x LD_LIBRARY_PATH /usr/local/lib/ /home/fdschmidt/intel/mkl/lib/intel64/ /opt/cuda/lib64/ $LD_LIBRARY_PATH
alias vi=nvim
 source /home/fdschmidt/miniconda3/etc/fish/conf.d/conda.fish

