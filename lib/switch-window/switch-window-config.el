(add-to-list 'load-path "~/.emacs.d/lib/switch-window/avy")        ;; https://github.com/abo-abo/avy.git
(add-to-list 'load-path "~/.emacs.d/lib/switch-window/ace-window") ;; https://github.com/abo-abo/ace-window.git
(require 'ace-window)
(setq aw-keys '(?a ?b ?c ?d ?e ?f ?g ?h ?k))
(global-set-key (kbd "C-x j") 'ace-window)

;; (add-to-list 'load-path "~/.emacs.d/lib/switch-window/switch-window")
;; (require 'switch-window)
;; (global-set-key (kbd "C-x o") 'switch-window)
;; (global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
;; (global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
;; (global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
;; (global-set-key (kbd "C-x 0") 'switch-window-then-delete)

(provide 'switch-window-config)
