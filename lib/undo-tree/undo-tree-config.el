(add-to-list 'load-path "~/.emacs.d/lib/undo-tree/undo-tree")
(require 'undo-tree)
(custom-set-variables
       '(undo-tree-mode-lighter " UT "))
(global-undo-tree-mode)
(provide 'undo-tree-config)
