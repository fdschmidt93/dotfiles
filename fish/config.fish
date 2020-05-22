set -gx EDITOR /usr/local/bin/nvim
set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'
set -gx PATH /home/fdschmidt/miniconda3/bin ~/.fzf/bin/ /usr/local/cuda-10.2/bin/ /home/fdschmidt/.dotnet/ $PATH
set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig
set -x CPLUS_INCLUDE_PATH /usr/include/c++/7/ 
set -x LD_LIBRARY_PATH /usr/local/lib/ /home/fdschmidt/intel/mkl/lib/intel64/ /usr/local/cuda-10.2/lib64/ $LD_LIBRARY_PATH
alias vi=nvim
