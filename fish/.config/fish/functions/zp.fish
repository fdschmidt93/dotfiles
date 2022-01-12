function zp
    set paper_dir "/home/fdschmidt/phd/papers/"
    fd --base-directory=$paper_dir | fzf --bind "enter:execute(zathura $paper_dir{})+abort"
end
