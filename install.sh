#!/bin/sh

git clone https://github.com/capitaomorte/yasnippet.git
git clone https://github.com/AndreaCrotti/yasnippet-snippets.git
mv yasnippet-snippets/* yasnippet/snippets/
cd python/
git clone https://gitlab.com/python-mode-devs/python-mode.git
cd ..
git clone git://github.com/magit/magit.git
sudo apt-get install mercurial -y
hg clone https://bitbucket.org/agriggio/ahg
cd projectile; 
wget http://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el
cd ..
emacs -l ~/.emac.d/utils/recompile_emacs_dirs.el