;;;; Настройки для работы с javascript 

(provide 'js-config)
(add-to-list 'load-path "~/.emacs.d/js")
(modify-coding-system-alist 'file "\\.js\\'" 'utf-8) ;; js файлы в utf-8
;;(modify-coding-system-alist 'file "\\.js\\'" 'cp1251) ;; js файлы в cp1251

;;(autoload 'js2-mode "js2-mode" nil t)
(if (or (not (boundp 'js2-global-externs)) 
		(null js2-global-externs))
	(setq-default js2-global-externs '("Ext"))
  (add-to-list 'js2-global-externs "Ext"))

(require 'js2-mode)
(require 'js2-imenu-extras)
(require 'js2-jedi-direx)

(defun js2-mode-complex-hook()
  (yas-minor-mode)
  (yas-activate-extra-mode 'js-mode)
  ;;(define-key js-mode-map [tab] 'yas/expand)
  (define-key yas-minor-mode-map [tab] 'yas/expand)
  (define-key js-mode-map "\C-cx" 'js2-jedi-direx:pop-to-buffer)
  (define-key js2-mode-map "\C-cx" 'js2-jedi-direx:pop-to-buffer)
  (hs-minor-mode)
  ;;(define-key direx:direx-mode-map (kbd "O") 'js2-jedi-direx:find-item-other-window-and-close)
  ;;((lambda () (set (make-local-variable 'yas-indent-line) 'fixed)))
  ;;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
  ;;(smart-operator-mode-on) ;;NOTE if there is error yas-minor-mode is not full
  ;;(slime-js-minor-mode 1)
  )

;; (defun js2-mode-init-hook()
;;   (message "call js2-mode-init-hook")
;;   (yas-activate-extra-mode 'js-mode)
;; )
;;(add-hook 'js2-init-hook 'js2-mode-init-hook)

(define-key direx:direx-mode-map (kbd "O") 'js2-jedi-direx:find-item-other-window-and-close)
(add-hook 'js2-mode-hook 'js2-mode-complex-hook)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; альтернативный вариант 
;; настройка javascript ide
;; (defun set-javascript-mode() 
;;   (interactive)
;;   (javascript-mode)
;;   (js2-mode)
;;   ;;(nlinum-mode)
;;   (imenu-add-menubar-index) ;; folding
;;   (hs-minor-mode)           ;; folding
;;   ;; (setq buffer-file-coding-system 'cp1251)
;;   ;;( revert-buffer-with-coding-system 'cp1251) ;; кодировка для файлов .js
;;   ;; (set-language-environment "Cyrillic-CP1251")
;;   ;; (defun js2-indent-line() 
;;   ;;   (interactive)
;;   ;;   (js-indent-line))
;;   ;; (add-hook 'js2-mode 'js2-indent-line 1)
;; )
;; (modify-coding-system-alist 'file "\\.js\\'" 'cp1251) ;; js файлы в cp1251
;; (add-to-list 'auto-mode-alist '("\\.js$" . set-javascript-mode)) 

(custom-set-variables 
 '(js2-bounce-indent-p nil)
 '(js2-auto-indent-p nil)
 ;; '(js2-dynamic-idle-timer-adjust 5000)
 '(js2-electric-keys (quote ("{" "}" "(" ")" "[" "]" ":" ";" "," "*")))
 '(js2-highlight-level 3)
)

;;;; настройка slime для javascript
;; Pymacs
;;(require 'cl-lib)
;;(require 'pymacs)

;;(require 'package)
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)      

;; (add-to-list 'pymacs-load-path "~/.emacs.d/python/python-mode/completion")
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-autoload "pymacs")
;;(pymacs-load "rope" "ropemacs")

;; Swank installation 
;; 1. install swank such described in https://github.com/swank-js/swank-js
;; 2. download git slime for 2012-02-12
;; 3. put into slime/contrib link to slime-js.el that is in the swank-js
;; 4. config slime such as bottom
;; 5. run swank-js
;; 6. use slime-connect to connect to swank-js
;; 7. need create link node to nodejs
;;
;; links:
;;   * https://github.com/swank-js/swank-js
;;   * https://github.com/slime/slime
;;   * http://www.idryman.org/blog/2013/03/23/installing-swank-dot-js/
;;   * http://xiaohanyu.me/oh-my-emacs/modules/ome-javascript.html
;;   * https://common-lisp.net/project/slime/doc/html/index.html#SEC_Contents
;;
;; how get slime by sha: 
;;   * git clone
;;   * git checkout <sha1 rev> of the rev you want ;; 385d9c20803de8dda1d2a6fd13fbec96f0e008b1
;;   * git reset --hard
;;
;; howto delete package:
;; The command package-menu-mark-delete (key 'd') followed by package-menu-execute (key 'x') worked for me.
;; 

;; (if (is-linux)
;; 	(progn 
;; 	  (setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
;; 	  (add-to-list 'load-path "~/slime/")  ; your SLIME directory
;; 	  (require 'slime-autoloads)
;; 	  (eval-after-load "slime"
;; 		'(progn
;; 		   (add-to-list 'load-path "~/slime/contrib/")  ; your SLIME contrib directory
;; 		   (require 'slime-js)
;; 		   ;; вместо slime-fancy нужно использовать slime-repl
;; 		   ;; (slime-setup '(slime-fancy slime-asdf slime-banner))
;; 		   (slime-setup '(slime-repl slime-asdf slime-banner)) 
;; 		   (setq slime-complete-symbol*-fancy t)
;; 		   ;;(setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
;; 		   ))
;; 	  ;;(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
;; 	  ;;(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;;  ))
