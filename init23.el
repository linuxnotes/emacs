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

(add-to-list 'load-path "~/.emacs.d/lib/e-tools")
(require 'e-tools)

(e-tools-add-to-list 'load-path
                     "~/.emacs.d/projectile/dash"
                     "~/.emacs.d/cl-lib"
                     "~/.emacs.d/lib23/magit")

;;(e-tools-load-module "elisp" 'elisp-config)
;;(e-tools-load-module "js" 'js-config)
;;(e-tools-load-module "vb-mode" 'visual-basic-mode)
;;(e-tools-load-module "per" 'perl-config)
;;(e-tools-load-module "python" 'python-config)


;; try load magit
(condition-case nil
	(progn
	  (require 'magit)
	  (setq magit-last-seen-setup-instructions "1.4.0"))
  (error nil))
