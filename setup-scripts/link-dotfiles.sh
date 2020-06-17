DIR=$PWD
DOTFILES="$(dirname "$DIR")"
echo "Linking files"
ln -nsf $DOTFILES/nvim $HOME/.config/nvim
ln -nsf $DOTFILES/alacritty $HOME/.config/alacritty
ln -nsf $DOTFILES/fish $HOME/.config/
ln -nsf $DOTFILES/tmux.conf $HOME/.tmux.conf
echo "Success"
