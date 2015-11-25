;;;;
(defmacro part-module-load(name &optional feature)
  "Load module macro"
  `(progn 
	 (add-to-list 'load-path ,(concat "~/.emacs.d/" (symbol-name name)))
	 ,(if (not (not feature))
		 `(require ',feature)
	   `(require ',(intern (concat (symbol-name name) "-config")))
	   ))
  )

(defun part-module-load-f(name feature-name)
  "Load module function"
  (add-to-list 'load-path (concat "~/.emacs.d/" name))
  (require feature-name)
)

(add-to-list 'load-path "~/.emacs.d"  "~/.emacs.d/cl-lib")
(condition-case nil
	(require 'cl-lib)
  (error(load-file "~/.emacs.d/cl-lib/cl-lib.el")))

;;;; Установка констант
(defun is-windows () 
  (boundp 'w32-system-shells))
(defun is-linux () 
  (not (boundp 'w32-system-shells)))

;; шрифт
;; cp hack2.0 /usr/share/fonts/truetype/ -R
;; fc-cache
(condition-case nil
    (set-default-font "Hack 9")
  (error(if (is-linux) 
			(set-default-font "Monospace 9") ;; шрифт для Linux
		  (set-default-font "Courier New 9"))))

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

(defun m-prev-window()
  (interactive)
(other-window -1))
(global-set-key (kbd "C-x p") 'm-prev-window)


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


;; popup
(add-to-list 'load-path "~/.emacs.d/popup")
(load-file "~/.emacs.d/popup/popup.el")
;;(require 'popup)

;; autocomplete
(add-to-list 'load-path "~/.emacs.d/auto_complete")
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto_complete/dict")
(require 'auto-complete-config)
(ac-config-default)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;; Load the snippet files themselves
(setq yas-snippet-dirs
      '("~/.emacs.d/yasnippet/yasmate/snippets" "~/.emacs.d/yasnippet/snippets" 
		"~/.emacs.d/my_snippets"))
(yas-reload-all) ;; this need for use yasnippet as minor mode

;;emacs lisp
(part-module-load-f "elisp" 'elisp-config)
;;javascript
(part-module-load-f "js" 'js-config)
;; visual basic
(part-module-load-f "vb-mode" 'visual-basic-mode)
;; Python
(part-module-load-f "python" 'python-config)
;; lua
(part-module-load-f "lua" 'lua-mode)
;; json
(part-module-load-f "json" 'json-config)
;; web mode
(part-module-load-f "web-mode" 'web-mode-config)
;; макросы
(part-module-load-f "macros" 'my-user-macro)
;; Themes
(part-module-load-f "theme" 'theme-config)

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

(add-to-list 'load-path "~/.emacs.d/ahg")
(require 'ahg)
(defun ahg-status-cur-dir ()
  "Получить статус по текущему каталогу"
  (interactive)
  (let ((curdir default-directory)
		( newcurdir(expand-file-name default-directory)))
	(setq default-directory newcurdir)
	(ahg-status newcurdir)
	(setq default-directory curdir)))
(global-set-key (kbd "C-c h g d") 'ahg-status-cur-dir)

;;; Control version systems
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
;; try load magit
(condition-case nil 
	(progn (require 'magit)
		   (setq magit-last-seen-setup-instructions "1.4.0"))
  (error nil))


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

;; after install 
;; git clone https://github.com/capitaomorte/yasnippet.git
;; git clone https://github.com/AndreaCrotti/yasnippet-snippets.git
;; git clone https://gitlab.com/python-mode-devs/python-mode.git
;; git clone git://github.com/magit/magit.git
;; hg clone https://bitbucket.org/agriggio/ahg
;; cd projectile; wget http://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el
(grep-compute-defaults) ;; установить значения по умолчанию
(grep-apply-setting 'grep-command "grep * -r -n --color -i -e")
(grep-apply-setting 'grep-find-command "find . ! -name \"*~\" ! -name \"#*#\" -type f -print0 | xargs -0 -e grep -nH -e ")

;; remove temp files
(defun clear-folder ()
  (interactive)
  (message "Clear folder, directory: %s" default-directory)
  (shell-command "rm *.pyc *~ *.orig")
  (revert-buffer)
)

(defun dired-mode-complex-hook()
  ((lambda ()
	(define-key dired-mode-map (kbd "C-c C-l") 'clear-folder))))
(add-hook 'dired-mode-hook 'dired-mode-complex-hook 1)

;; Configuration for dictionaries
(add-to-list 'load-path "~/.emacs.d/dictem")
(require 'dictem-config)
