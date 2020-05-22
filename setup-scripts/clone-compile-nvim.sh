DIR=$PWD
NVIM_PATH=$HOME/neovim
# clear out existing install
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
git clone https://github.com/neovim/neovim $NVIM_PATH
cd $NVIM_PATH
# build dependencies
mkdir .deps
cd .deps
cmake ../third-party
make
# build nvim
cd $NVIM_PATH
mkdir build
cd build
cmake ..
make
sudo make install
# clear out
cd $DIR
rm -rf $NVIM_PATH
