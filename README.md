Installation
-------------

In any new machine/account I need to work on, I clone from the repository:

    cd
    git clone XXXX .vim
    cd .vim
    git submodule init
    git submodule update
    cd ..
    ln -s .vim/.vimrc
