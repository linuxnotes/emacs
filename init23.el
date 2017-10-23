;;;;
;;;; This emacs config is compatible with emacs 23.
;;;; alias emacs23v='emacs23 -q --load "~/.emacs.d/init23.el"'

;; git clone https://github.com/magit/magit.git
;; cd magit;
;; git checkout 1.4.0
;; cd -
;; git clone https://github.com/magit/git-modes.git
;; cd git-clones
;; git checkout 1.0.0

(add-to-list 'load-path "~/.emacs.d/projectile/dash")
(add-to-list 'load-path "~/.emacs.d/cl-lib")
(add-to-list 'load-path "~/.emacs.d/lib23/magit")

;; try load magit
(condition-case nil
	(progn
	  (require 'magit)
	  (setq magit-last-seen-setup-instructions "1.4.0"))
  (error nil))
