;;;;
(add-to-list 'load-path "~/.emacs.d"  "~/.emacs.d/cl-lib")

;;;; Установка констант
(defun is-windows () 
  (boundp 'w32-system-shells))
(defun is-linux () 
  (not (boundp 'w32-system-shells)))

;; шрифт
(if (is-linux) 
	(set-default-font "Monospace 9") ;; шрифт для Linux
  (set-default-font "Courier New 9")) ;; шрифт для Windows

(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq auto-safe-default nil)

;; выключить toolbar
(tool-bar-mode -1) 
;;не показывть начальный экран
(setq inhibit-startup-message t)

;; табы по 4
(setq default-tab-width 4)

;; краткие ответы на вопрос
(fset 'yes-or-no-p 'y-or-n-p)

;; 
(setq scroll-step 1)

;;показывать парные скобки
(show-paren-mode t)   

;;;; работа с конфигом
(defun load-config()
  "Функция открывает в буфере каталог с конфигом"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun reload-config() 
  "Перезагрузить файл конфигурации"
  (interactive) 
  (load-file "~/.emacs.d/init.el"))

(defun setcp1251() 
    (interactive)
    (set-language-environment "Cyrillic-CP1251"))

(defun setutf8() 
    (interactive)
    (set-language-environment "UTF-8"))

;;раскладки
(global-set-key [f3] 'setcp1251)
(global-set-key [f4] 'setutf8)

;;макросы 
(global-set-key [f5] 'kmacro-start-macro)
(global-set-key [f6] 'kmacro-end-macro)
(global-set-key [f7] 'call-last-kbd-macro)

;; нумерация строк
;; можно использовать linum-mode, но он вроде как медленнее
(load-file "~/.emacs.d/nlinam/nlinum.el")
(global-set-key [f8] 'nlinum-mode)

;; выбор буффера 
;; переопеределим стандартный list-buffer на ibuffer
;;(global-set-key [f11] 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; работы с закладками
;; выбор закладки C-x r l bookmark-bmenu-list

;; Убираем уход в background
(global-set-key (kbd "C-z") 'undo)

;;Закомментировать раскомментировать область
(global-set-key (kbd "\e\ec") 'comment-region)
(global-set-key (kbd "\e\eu") 'uncomment-region)

;; перемещение с использованием Alt
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "C-x j") 'previous-multiframe-window)

;; замена строк
(global-set-key (kbd "C-x C-m") 'replace-string)

;; меню для вставки
(global-set-key (kbd "C-c y") '(lambda () 
    (interactive) (popup-menu 'yank-menu)))

;; включение возможности делать upcase/downcase region
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Create Cyrillic-CP1251 Language Environment menu item
(set-language-info-alist
 "Cyrillic-CP1251" `((charset cyrillic-iso8859-5)
					 (coding-system cp1251)
					 (coding-priority cp1251)
					 (input-method . "cyrillic-jcuken")
					 (features cyril-util)
					 (unibyte-display . cp1251)
					 (sample-text . "Russian (Русский) Здравствуйте!")
					 (documentation . "Support for Cyrillic CP1251."))
 '("Cyrillic"))


;; autocomplete
(add-to-list 'load-path "~/.emacs.d/auto_complete")
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto_complete/dict")
(require 'auto-complete-config)
(ac-config-default)

;;emacs lisp
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'elisp-config)
;;javascript
(add-to-list 'load-path "~/.emacs.d/js")
(require 'js-config)
;; visual basic
(add-to-list 'load-path "~/.emacs.d/vb-mode")
(require 'visual-basic-mode)
;; Python
(add-to-list 'load-path "~/.emacs.d/python/")
(require 'python-config)
;; lua
(add-to-list 'load-path "~/.emacs.d/lua")
(require 'lua-mode)
;; json
(add-to-list 'load-path "~/.emacs.d/json")
(require 'json-config)
;; web mode
(add-to-list 'load-path "~/.emacs.d/web-mode")
(require 'web-mode-config)
;; макросы
(add-to-list 'load-path "~/.emacs.d/macros")
(require 'my-user-macro)
;; Themes
(add-to-list 'load-path "~/.emacs.d/theme")
(require 'theme-config)

;; projectile
;; projectile-mode ;; если нужно не глобально
(add-to-list 'load-path "~/.emacs.d/projectile")
(add-to-list 'load-path "~/.emacs.d/projectile/dash")
(add-to-list 'load-path "~/.emacs.d/projectile/s")
(add-to-list 'load-path "~/.emacs.d/projectile/f")
(add-to-list 'load-path "~/.emacs.d/projectile/pkg-info")
(add-to-list 'load-path "~/.emacs.d/projectile/epl")
(require 'projectile)
(projectile-global-mode)

;; popup
(add-to-list 'load-path "~/.emacs.d/popup")
(require 'popup)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;; Load the snippet files themselves
(setq yas-snippet-dirs
      '("~/.emacs.d/yasnippet/yasmate/snippets" "~/.emacs.d/my_snippets"))
(yas-reload-all) ;; this need for use yasnippet as minor mode

;; autopair
(add-to-list 'load-path "~/.emacs.d/autopair")
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

;; todo
(add-to-list 'load-path "~/.emacs.d/todo/")
(require 'todo-config)

;; navigator
(defun load-nav()
  " Загрузка панели навигатора "
  (interactive)
  (add-to-list 'load-path "~/.emacs.d/emacs-nav-49/")
  (require 'nav)
  (nav-disable-overeager-window-splitting)
  ;;(nav)
  ;; Optional: set up a quick key to toggle nav
  (global-set-key [?\C-x ?n ?n]  'nav-toggle))
(load-nav)

(setq x-select-enable-clipboard t)
;; (setq selection-coding-system 'compound-text-with-extensions)

;; работает для javascript
(global-set-key (kbd "\e\eh") 'hs-hide-block)
(global-set-key (kbd "\e\el") 'hs-hide-level)
(global-set-key (kbd "\e\es") 'hs-show-block)
(global-set-key (kbd "\e\ea") 'hs-show-all)

;; выравнивание вправо
(defun right-justify-rectangle (start end)
  (interactive "r")
  (let ((indent-tabs-mode nil))
    (apply-on-rectangle (lambda (c0 c1)
                          (move-to-column c1 t)
                          (let ((start (- (point) (- c1 c0)))
                                (end (point)))
                            (when (re-search-backward "\\S-" start t)
                              (transpose-regions start (match-end 0)
                                                 (match-end 0) end))))
                        start end))
  (when indent-tabs-mode (tabify start end)))

;; ;; другая версия 
;; (defun right-justify-rectangle (start end)
;;   (interactive "r")
;;   (apply-on-rectangle (lambda (c0 c1)
;;                         (move-to-column c1 t)
;;                         (let ((start (- (point) (- c1 c0)))
;;                               (end (point)))
;;                           (when (re-search-backward "\\S-" start t)
;;                             (transpose-regions start (match-end 0)
;;                                                (match-end 0) end))))
;;                       start end))
;; выравниваение в влево
;; (delete-whitespace-rectangle)

;; выровнять по полю 
;; align-regexp

(defun transpose-buffers (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

;;hg clone https://bitbucket.org/agriggio/ahg
(add-to-list 'load-path "~/.emacs.d/ahg")
(require 'ahg)

;;; Control version systems
;;git clone git://github.com/magit/magit.git
(when (not (fboundp 'string-suffix-p))
  (defun string-suffix-p (str1 str2 &optional ignore-case)
  (let ((begin2 (- (length str2) (length str1)))
        (end2 (length str2)))
    (when (< begin2 0) (setq begin2 0))
    (eq t (compare-strings str1 nil nil
                           str2 begin2 end2
                           ignore-case))))
)

(when (not (fboundp 'define-error))
  (defun define-error (name message &optional parent)
    "Define NAME as a new error signal.
MESSAGE is a string that will be output to the echo area if such an error
is signaled without being caught by a `condition-case'.
PARENT is either a signal or a list of signals from which it inherits.
Defaults to `error'."
    (unless parent (setq parent 'error))
    (let ((conditions
           (if (consp parent)
               (apply #'nconc
                      (mapcar (lambda (parent)
                                (cons parent
                                      (or (get parent 'error-conditions)
                                          (error "Unknown signal `%s'" parent))))
                              parent))
             (cons parent (get parent 'error-conditions)))))
      (put name 'error-conditions
           (delete-dups (copy-sequence (cons name conditions))))
      (when message (put name 'error-message message)))))

(add-to-list 'load-path "~/.emacs.d/magit" )
(add-to-list 'load-path "~/.emacs.d/git-modes")
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

;; my functions 
(defun change-brackets (from-b to-b)
  "Функция выполняет замену скобок с одного типа на другой"
  (interactive "cfrom:\ncto:")
  (message "from-b %c" from-b)
  (message "to-b %c" to-b)

  (let* (
		 (pairs '( (?\(. ?\)) (?\{.?\}) (?\[.?\])))
		 (close-from-b (cdr(assoc from-b pairs)))
		 (close-to-b (cdr(assoc to-b pairs)))
		 ) 
	
	(save-excursion 
	  (search-backward (char-to-string from-b))
	  (delete-char 1)
	  (insert-char to-b)
	  (search-forward (char-to-string close-from-b))
	  (delete-char -1)
	  (insert-char close-to-b))))
(global-set-key (kbd "C-x C-,") 'change-brackets)

;; сохранить/загрузить кофигурацию окон
;; (defvar some "")
;; (setq some (current-window-configuration))
;; (set-window-configuration some)
;; save-current-configuration сохранить, resume загрузить
(load-file "~/.emacs.d/sessions/revive.elc")
(defun m-desktop-read ()
  "Выполнить считывание данных предыдущего сеанса с 
   обновлением конфигурации yasnippets
  "
  (interactive) 
  (desktop-read)
  (yas-reload-all))

;; add spelling, must be placed after mode configs
(add-to-list 'load-path "~/.emacs.d/spelling")
(require 'spell-config)

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

;; after install 
;; git clone https://github.com/capitaomorte/yasnippet.git
;; git clone https://gitlab.com/python-mode-devs/python-mode.git

