function zp
    set paper_dir "/home/fdschmidt/phd/papers/"
    fd --strip-cwd-prefix --base-directory=$paper_dir | fzf --bind "enter:execute(zathura --fork $paper_dir{})+abort"
end
