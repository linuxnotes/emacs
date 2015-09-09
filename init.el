;;;;

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/cl-lib")

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

;; табы по 4
(setq default-tab-width 4)

;; подсветка строки с курсором
;; (global-hl-line-mode 4)  ;; из-за этой опции возможны тормоза

;; нумерация строк для всех файлов 
;; (global-linum-mode 1) 

;; краткие ответы на вопрос
(fset 'yes-or-no-p 'y-or-n-p)

;; 
(setq scroll-step 1)

;;не показывть начальный экран
(setq inhibit-startup-message t)

;;показывать парные скобки
(show-paren-mode t)   

;;;; работа с конфигом
(defun load-config()
  "Функция открывает в буфере каталог с конфигом"
  (interactive)
  (find-file "~/.emacs.d/init.el"))
;; (global-set-key "\C-x/" 'load-config)

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
(load-file "~/.emacs.d/nlinam/nlinum.el")
;; можно использовать linum-mode, но он вроде как медленнее
(global-set-key [f8] 'nlinum-mode)

;; выбор буффера 
;; переопеределим стандартный list-buffer на ibuffer
;;(global-set-key [f11] 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; выбор закладки
;; по умолчанию стоит на C-x r l
;;(global-set-key [f10] 'bookmark-bmenu-list) 

;; Убираем уход в background
(global-set-key (kbd "C-z") 'undo)

;;Закомметировать разскомментировать область
(global-set-key (kbd "\e\ec") 'comment-region)
(global-set-key (kbd "\e\eu") 'uncomment-region)

;; перемещение с использованием Alt
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "C-x j") 'previous-multiframe-window)

;; перемещение между буферами
(global-set-key [(control tab)] 'previous-buffer)
(global-set-key [(C-S-iso-lefttab)] 'next-buffer)

;; замена строк
(global-set-key (kbd "C-x C-m") 'replace-string)

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

;;emacs lisp
(defun elisp-mode-complex-hook()
  (yas-minor-mode)
  (define-key js-mode-map [tab] 'yas/expand)
  (setq yas/after-exit-snippet-hook 'indent-according-to-mode)
)
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-complex-hook)

;; javascript
(add-to-list 'load-path "~/.emacs.d/js")
(require 'js-config)

(add-to-list 'load-path "~/.emacs.d/vb-mode")
(require 'visual-basic-mode)

(global-set-key (kbd "C-c y") '(lambda ()
    (interactive) (popup-menu 'yank-menu)))

(fset 'search_word
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([67108896 134217830 134217847 24 106 134217747 92 98 25 92 98 13] 0 "%d")) arg)))
(global-set-key (kbd "C-c f") 'search_word)


;; json
(add-to-list 'load-path "~/.emacs.d/json")
(require 'json-config)

(add-to-list 'load-path "~/.emacs.d/web-mode")
(require 'web-mode-config)

;;;; Макросы
;; для создания макроса нужно сделать 
;; макрос, потом name-last-kbd-macro
;; потом insert-kbd-macro

;; макрос для преобразования new в Ext.create
(fset 'newToExtCreate
   [?\S-\C-f ?\S-\C-f ?\S-\C-f ?\S-\C-f ?\C-x ?\C-m ?n ?e ?w ?  return ?E ?x ?y backspace ?t ?/ backspace ?. ?c ?r ?e ?a ?t ?e ?\( ?\" return ?\C-s ?\( ?\C-b ?\S-\C-f ?\C-x ?\C-m ?\( return ?\" ?, return])

(fset 'var_to_property
   [?\S-\C-f ?\S-\C-f ?\S-\C-f ?\S-\C-f ?\C-w ?\C-s ?= ?\C-b ?\S-\C-f ?\C-w ?\C-_ ?\C-b ?\S-\C-f ?\C-x ?\C-m ?= return ?: return ?\C-e ?\C-b ?\C-\M-n ?\S-\C-f ?\C-x ?\C-m ?\; return ?, return])

(fset 'shifttab
   [?\C-u ?- ?4 ?\C-x tab])

(fset 'arrtofuncall
   [?\C-  ?\C-f ?\C-x ?\C-m ?\[ return ?\( return ?\C-s ?\] ?\C-  ?\C-b ?\C-  ?\C-f ?\C-x ?\C-m ?\] return ?\) return ?\C-x ?\C-s])

;;забиндим это на esc-esc-n
(global-set-key (kbd "\e\en") 'newToExtCreate)
(global-set-key [backtab] 'shifttab)

;; Themes
(add-to-list 'load-path "~/.emacs.d/theme")
(require 'theme-config)

;; projectile
(add-to-list 'load-path "~/.emacs.d/projectile")
(add-to-list 'load-path "~/.emacs.d/projectile/dash")
(add-to-list 'load-path "~/.emacs.d/projectile/s")
(add-to-list 'load-path "~/.emacs.d/projectile/f")
(add-to-list 'load-path "~/.emacs.d/projectile/pkg-info")
(add-to-list 'load-path "~/.emacs.d/projectile/epl")
(require 'projectile)
(projectile-global-mode)
;;projectile-mode ;; если нужно для каких-то режимов

;; popup
(add-to-list 'load-path "~/.emacs.d/popup")
(require 'popup)


;; ;; add some shotcuts in popup menu mode
;; (define-key popup-menu-keymap (kbd "C-n") 'popup-next)
;; (define-key popup-menu-keymap (kbd "TAB") 'popup-next)
;; (define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
;; (define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
;; (define-key popup-menu-keymap (kbd "C-p") 'popup-previous)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;; Load the snippet files themselves
(setq yas-snippet-dirs
      '(
		"~/.emacs.d/yasnippet/snippets"                 ;; personal snippets
		"~/.emacs.d/yasnippet/yasmate/snippets"                 ;; personal snippets
		"~/.emacs.d/my_snippets"
        ))
(yas-reload-all) ;; this need for use yasnippet as minor mode


;; autopair
(add-to-list 'load-path "~/.emacs.d/autopair")
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

;; (yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.
;; (yas/load-directory "~/.emacs.d/snippets/javascript-mode")
;; Let's have snippets in the auto-complete dropdown
;; (add-to-list 'ac-sources 'ac-source-yasnippet)

;; (defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
;;   (when (featurep 'popup)
;;     (popup-menu*
;;      (mapcar
;;       (lambda (choice)
;;         (popup-make-item
;;          (or (and display-fn (funcall display-fn choice))
;;              choice)
;;          :value choice))
;;       choices)
;;      :prompt prompt
;;      ;; start isearch mode immediately
;;      :isearch t
;;      )))

;; (setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))

(add-to-list 'load-path "~/.emacs.d/auto_complete")
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto_complete/dict")
(require 'auto-complete-config)
(ac-config-default)

;; Python
(add-to-list 'load-path "~/.emacs.d/python/")
(require 'python-config)

;;;; TODO
(add-to-list 'load-path "~/.emacs.d/todo/")
(require 'todotxt)
(defun todotxt-mode-disable()
  (interactive)
  (text-mode)
  (setq buffer-read-only nil))

(defun todotxt-mode-edit-enable()
  (interactive)
  (setq buffer-read-only nil))

;; todo 
(defun open-todolist ()
  (interactive) 
  (find-file "~/todo.txt"))

(defun print-buffer-main-mode()
  (interactive)
  (message "%s" major-mode))


;; cedet + ecb 
;; load only if it need, not every time
(defun load-cedet-ecb () 
  " Загрузка ecb и cedet "
  (interactive)

  ;; load cedet 
  (add-to-list 'load-path "~/.emacs.d/cedet")
  (load-file "~/.emacs.d/cedet/common/cedet.elc")
  (global-ede-mode 1)
  
  ;; load ecb
  (add-to-list 'load-path "~/.emacs.d/ecb")
  (load-file "~/.emacs.d/ecb/ecb.elc")

  (setq ecb-mode-value 1)

  (defun ecb-toogle-visibility() 
	" Переключатель для ecb "
	(interactive)
	(setq ecb-mode-value (- 1 ecb-mode-value));; табы по 4
	(if (> ecb-mode-value 0)
		(ecb-deactivate)
	  (ecb-activate)))

  ;; ecb-togle-ecb-window ;; скрыть показать
  
  ;; left9 left10
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(ecb-layout-name "left10")
   '(ecb-layout-window-sizes (quote (("left10" (0.2297872340425532 . 0.7391304347826086) (0.10212765957446808 . 0.2463768115942029) (0.1276595744680851 . 0.2463768115942029)))))
   '(ecb-options-version "2.40")
   '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
   '(ecb-tree-indent 2)
   '(tool-bar-mode nil))
  (ecb-activate)) 

(setq ecb-tip-of-the-day nil)
;; finish of load cedet-ecb

(defun load-nav()
" Загрузка панели навигатора "
  (interactive)
  (add-to-list 'load-path "~/.emacs.d/emacs-nav-49/")
  (require 'nav)
  (nav-disable-overeager-window-splitting)
  (nav)
  ;; Optional: set up a quick key to toggle nav
  (global-set-key [?\C-x ?n ?n]  'nav-toggle))
;; (load-nav)

(defun load-projectile()
  (interactive)
  (add-to-list 'load-path "~/emacs.d/projectile/")
  (require 'projectile.el))

;; дабавим подсветку для lua
(add-to-list 'load-path "~/.emacs.d/lua")
(require 'lua-mode)




;; переключение расскадки
;; http://ru-emacs.livejournal.com/82428.html
;; (defun reverse-input-method (input-method)
;;   "Build the reverse mapping of single letters from INPUT-METHOD."
;;   (interactive
;;    (list (read-input-method-name "Use input method (default current): ")))
;;   (if (and input-method (symbolp input-method))
;;       (setq input-method (symbol-name input-method)))
;;   (let ((current current-input-method)
;;         (modifiers '(nil (control) (meta) (control meta))))
;;     (when input-method
;;       (activate-input-method input-method))
;;     (when (and current-input-method quail-keyboard-layout)
;;       (dolist (map (cdr (quail-map)))
;;         (let* ((to (car map))
;;                (from (quail-get-translation
;;                       (cadr map) (char-to-string to) 1)))
;;           (when (and (characterp from) (characterp to))
;;             (dolist (mod modifiers)
;;               (define-key local-function-key-map
;;                 (vector (append mod (list from)))
;;                 (vector (append mod (list to)))))))))
;;     (when input-method
;;       (activate-input-method current))))

;; (defadvice read-passwd (around my-read-passwd act)
;;   (let ((local-function-key-map nil))
;;     ad-do-it))

;; либо переключаиться по С-\ и input-method russian-computer

(setq x-select-enable-clipboard t)
;; (setq selection-coding-system 'compound-text-with-extensions)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-key-map (quote ("C-c ." (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (t "gl" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (t "gd" ecb-goto-window-directories) (t "gs" ecb-goto-window-sources) (t "gm" ecb-goto-window-methods) (t "gh" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
 '(ecb-layout-name "left10")
 '(ecb-layout-window-sizes (quote (("left9" (0.2126865671641791 . 0.9864864864864865)) ("left10" (0.2297872340425532 . 0.7391304347826086) (0.10212765957446808 . 0.2463768115942029) (0.1276595744680851 . 0.2463768115942029)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-tree-indent 2)
 '(tool-bar-mode nil)
)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;; HELP and TODO

;; C-q C-j перевод на другую строку можно использовать при 
;; выполнении замены


;; TODO: Посмотреть что это
;;(global-set-key (kbd "C-c e") 'else-expand-placeholder)

;; Данную команду нужно использовать для того чтобы скомпилировать javascript file
;; emacs --batch -eval '(byte-compile-file "js2.el")')


;;{{{ удобный выбор файла и буфера
;; TDOO: сделать чтобы было активно, если открыт
;; только один буффер
;; (require 'lusty-explorer)
;; ;; вместо find-file
;; (global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
;; ;; вместо switch-to-buffer
;; (global-set-key (kbd "C-x b") 'lusty-buffer-explorer)
;; ;;}}}


;;;; TODO: folding  
;; забиндим folding 
;; работает для javascript
(global-set-key (kbd "\e\eh") 'hs-hide-block)
(global-set-key (kbd "\e\el") 'hs-hide-level)
(global-set-key (kbd "\e\es") 'hs-show-block)
(global-set-key (kbd "\e\ea") 'hs-show-all)



(defun my-custom-to-sql-ide() 
  (interactive)
  ";; Превращаем emacs в аналог sqldeveloper
  ;; ide-skel, sqlplus, tabbar, plsql
  ;; Инструкция по установке 
  ;; 1. устанвливается instant-client 
  ;; 2. устанавливается instant-client-sqlplus
  ;; 3. устанваливаются расширения для emacs
  ;; 4. конфигурируется tnsnames.ora
  ;; TST1 =
  ;; (DESCRIPTION =
  ;;   (ADDRESS = (PROTOCOL = TCP)(HOST = hostname)(PORT = portnumber))
  ;;   (CONNECT_DATA =
  ;;     (SERVER = DEDICATED)
  ;;     (SERVICE_NAME = XE)
  ;;   )
  ;; )
  ;; для создания подключения sqlplus user/password@TNSNAME "

  (add-to-list 'load-path "~/.emacs.d/ide-skel")
  (require 'tabbar)
  (require 'ide-skel)

  (partial-completion-mode)
  (icomplete-mode)

  ;; for convenience
  (global-set-key [C-f4] 'ide-skel-proj-find-files-by-regexp)
  (global-set-key [C-f5] 'ide-skel-proj-grep-files-by-regexp)
  (global-set-key [C-f10] 'ide-skel-toggle-left-view-window)
  (global-set-key [C-f11] 'ide-skel-toggle-bottom-view-window)
  (global-set-key [C-f12] 'ide-skel-toggle-right-view-window)
  (global-set-key [C-prior] 'tabbar-backward)
  (global-set-key [C-next]  'tabbar-forward)

  (require 'sqlplus)
  (setenv "LD_LIBRARY_PATH" "$ORACLE_HOME/lib:$JAVA_HOME/jre/lib/amd64:/usr/local/lib:/usr/lib/oracle/11.2/client/lib")
  (setenv "NLS_LANG" "AMERICAN_AMERICA.UTF8")
  (setenv "PATH" "$PATH:~/bin/utils/")
;;;; (require 'folding)

  ;; подсветка скобок
  ;; (require 'highlight-sexp)
  ;; (add-hook 'lisp-mode-hook 'highlight-sexp-mode)
  ;; (add-hook 'emacs-lisp-mode-hook 'highlight-sexp-mode)

;;;; plsql
  ;; C-c C-c compile current psql buffer
  (defun load-pl-sql-mode() 
	(interactive)
	(require 'plsql)
	(setq plsql-indent 2) 
	)
  (load-pl-sql-mode) ;; будем грузить по умолчанию
  (add-to-list 'auto-mode-alist '("\\.sql$" . plsql-mode))
)

(defun my-include-sqlplus2() 
  (interactive)
  ;; (add-to-list 'load-path "~/.emacs.d/ide-skel")
  (setenv "LD_LIBRARY_PATH" "$ORACLE_HOME/lib:$JAVA_HOME/jre/lib/amd64:/usr/local/lib:/usr/lib/oracle/12.1/client/lib")
  (setenv "NLS_LANG" "AMERICAN_AMERICA.UTF8")
  (load-file "~/.emacs.d/ide-skel/sqlplus2.el")
  ;; (require 'sqlplus2)
)

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


;;
;(setq show-paren-style 'expression) ; подсвечивает блоки, но раздражает


;; (defun load-helm()
;;   (interactive)
;;   (add-to-list 'load-path "~/.emacs.d/helm/")
;;   (require 'helm-config.el))


;;(require 'advice)
;; (require 'layout-restore)

;; сменить кодировку файла 
;;(set-buffer-file-coding-system)
;;(encode-coding-region) ;; перекодировать выделенный регион
;;}}}


;; (defun local-hl-line-mode-off ()
;;   (interactive)
;;   (make-local-variable 'global-hl-line-mode)
;;   (setq global-hl-line-mode nil))
;;(add-hook 'ruby-mode-hook 'local-hl-line-mode-off)

;; ;; когда windows установить путь до common lisp
;; (when (is-windows)
;;   (set-variable 'inferior-lisp-program "C:/Users/user/AppData/Roaming/.emacs.d/gcl/gcl.exe")
;;   (autoload 'fi:common-lisp "fi-site-init" "" t))

;;; плавная прокрутка 
;; http://gaydov.blogspot.ru/2013/02/emacs.html
;; ;; При прокрутке применять font-lock не сразу, а после небольшой задежки.
;; (setq jit-lock-defer-time 0.01)

;; ;; Эту опцию часто советуют выставлять в t, но я не заметил разницы с nil.
;; ;(setq  redisplay-dont-pause t)

;; ;; Опционально: медленная плавная прокрутка колесиком.
;; (setq mouse-wheel-scroll-amount '(2 ((shift) . 2)))   ; Прокручивать по 2 строки.
;; (setq mouse-wheel-progressive-speed nil)
;; (setq mouse-wheel-follow-mouse 't)

;; ;; Опционально: никогда не прокручивать более, чем на 1 строку при перемещении курсора за
;; ;; нижнюю или верхнюю границу экрана.
;; (setq scroll-conservatively 10000)

;; ;; Опционально: отступ от верха и низа экрана в 1 строку, при попадании курсора за отступ
;; ;; происходит прокрутка.
;; (setq scroll-margin 1)


(when (is-windows)
  ;; отключить beep в emacs windows
  (setq visible-bell 1)
  ;; change encoding system
  (add-to-list 'process-coding-system-alist '("[cC][mM][dD][pP][rR][oO][xX][yY]" cp1251 . cp1251))
  
  (load  "C:/\\quicklisp\\slime-helper.el")
  ;; Replace "sbcl" with the path to yout implementation
  (setq inferior-lisp-program "H:\\soft\\win\\lisp\\clisp-2.48\\clisp.exe")
  ;; удаление vc-git, который сильно замедляет работу
  (remove-hook 'find-file-hooks 'vc-find-file-hook)
)

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
;;(add-to-list 'load-path "~/.emacs.d/magit/lisp")
;; (require 'magit)
;; (with-eval-after-load 'info
;;   (info-initialize)
;;   (add-to-list 'Info-directory-list
;; 	       "~/.emacs.d/magit/Documentation/"))


;;hg clone https://bitbucket.org/agriggio/ahg
(add-to-list 'load-path "~/.emacs.d/ahg")
(require 'ahg)

;; чтобы перекодироваь регион нужно выполнить 
;; recode-region
  
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
	  (insert-char close-to-b)
	  )
   )
)

;; сохранить/загрузить кофигурацию окон
;; (defvar some "")
;; (setq some (current-window-configuration))
;; (set-window-configuration some)
(load-file "~/.emacs.d/sessions/revive.elc")
(defun m-desktop-read ()
  "Выполнить считывание данных предыдущего сеанса с 
   обновлением конфигурации yasnippets
  "
  (interactive) 
  (desktop-read)
  (yas-reload-all))

(global-set-key (kbd "C-x C-,") 'change-brackets)

;; add spelling, must be placed after mode configs
(add-to-list 'load-path "~/.emacs.d/spelling")
(require 'spell-config)

;;чтобы в xterm Alt корректно работало в 
;; echo 'xterm*metaSendsEscape: true' >> /etc/X11/app-defaults/Xterm

;; Pymacs
(require 'cl-lib)
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

