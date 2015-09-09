;;;; Настройки для работы с javascript 

(provide 'js-config)
(add-to-list 'load-path "~/.emacs.d/js")
(modify-coding-system-alist 'file "\\.js\\'" 'utf-8) ;; js файлы в utf-8
;;(modify-coding-system-alist 'file "\\.js\\'" 'cp1251) ;; js файлы в cp1251

;;(autoload 'js2-mode "js2-mode" nil t)
(require 'js2-mode)
(require 'js2-imenu-extras)

(defun js2-mode-complex-hook()
    ((lambda ()
	 (yas-minor-mode)
	 (define-key js-mode-map [tab] 'yas/expand)
	 ((lambda () (set (make-local-variable 'yas-indent-line) 'fixed)))
	 ;;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
	 (smart-operator-mode-on)
	 ;;(slime-js-minor-mode 1)
	))
)

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
 '(js2-bounce-indent-p t)
 ;; '(js2-dynamic-idle-timer-adjust 5000)
 '(js2-electric-keys (quote ("{" "}" "(" ")" "[" "]" ":" ";" "," "*")))
 '(js2-highlight-level 3)
)
