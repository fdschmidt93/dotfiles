function zp
    set paper_dir "/home/fdschmidt/phd/papers/"
    nohup zathura --fork $paper_dir(fd --strip-cwd-prefix --base-directory=$paper_dir | fzf) >/dev/null 2>&1
    kill $fish_pid
end
