;;;; Настройки для работы с python 
;;;; http://habrahabr.ru/post/46350/

;; Магия которую пришлось выполнить после установки pymacs для python и для emacs если сам pymacs ставить из
;; 1. видимо в новой версии pymacs который python немного поменялся api, поэтому from Pymacs.pymacs import main не работает, 
;;    а работает просто from Pymacs import main
;;    поэтому находим файлы pymacs.el pymacs.elc и в них делаем замену этим строчек
;; 2. Выдается ошибка не совпадения версий, это чиним аналогично ищем pymacs.el, pymacs.elc и ставим версию как у pymacs из python
;;    после этого получилось загрузить pycomplete
;; 3. Не удается найти модуль, для этого прописываем дополнительные пути для загрузки сразу после requre pymacs, туда нужно 
;;    вписать путь, где лежит pycomplete
;; 4. Чтобы удалить установленный из git pymacs нужно найти все Pymacs модули и удалить их и потом еще в файле
;;    /usr/local/lib/python2.7/dist-packages/easy-install.pth удалить путь до папке куда скопирован git репозиторий

;; Если используется дистрибутив вроде Ubuntu, то он сразу устанавливает Pymacs и lisp и python нужной версии,
;; в текущей конфигурации была версия 0.23

;; python-mode нужно скачивать с github: https://github.com/emacsmirror/python-mode

;; нужно чтобы корректно подгружался cx_Oracle
(setenv "PATH"
  (concat
   "~/bin/utils/" ":"
   "~/bmcmd/config/lib/" ":"
   (getenv "PATH")
  )
)
(setenv "LD_LIBRARY_PATH" "/usr/lib/oracle/11.2/client64/lib")
;;NOTE CHECK THAT PYTHONPATH IS SETTED

;; (setq py-install-directory "~/.emacs.d/python/python-mode/")
;; (add-to-list 'load-path "~/.emacs.d/python/python-mode/completion")
;; (add-to-list 'load-path py-install-directory)
;; (require 'python-mode)

;; python jedi may be slow
(add-to-list 'load-path "~/.emacs.d/emacs-python-environment")
(add-to-list 'load-path "~/.emacs.d/emacs-ctable")
(add-to-list 'load-path "~/.emacs.d/emacs-deferred")
(add-to-list 'load-path "~/.emacs.d/emacs-epc")
(add-to-list 'load-path "~/.emacs.d/emacs-jedi")
(add-to-list 'load-path "~/.emacs.d/direx-el")
(add-to-list 'load-path "~/.emacs.d/emacs-jedi-direx")
(require 'concurrent)
(require 'epc)
;;(setq jedi:setup-keys t)                      ; optional
;;(setq jedi:complete-on-dot t)                 ; optional
(require 'jedi)
(require 'jedi-direx)
(customize-set-value 'jedi:setup-keys t)

;;(autoload 'jedi:setup "jedi" nil t)

;; (add-hook 'python-mode-hook 'auto-complete-mode)
;;(add-hook 'python-mode-hook 'jedi:ac-setup)

;;(require 'pycomplete)
;;(ac-config-default)
;;(setq py-load-pymacs-p t) ;;еслиpymacs поставляется вместе с pymacs 
; use IPython
(setq py-shell-name "ipython")
(setq-default py-which-bufname "IPython")

;; ; switch to the interpreter after executing code
;; ;; if no need switch to buffer
(setq py-keep-windows-configuration t)

; switch-to-buffer but not split
(setq py-split-windows-on-execute-function (lambda() t ))
(setq py-split-windows-on-execute nil)

;; ; don't split windows
(setq py-switch-buffers-on-execute-p nil)
(setq py-split-windows-on-execute-p nil)

(defun ipythonm()
"Define ipython correct command"
;; todo: fix defualt ipython command
  (interactive)
   (ipython)
   (switch-to-buffer "*IPython*")
  )

;; add remove empty strings for get complition to ipython
(setq py-ipython0.11-completion-command-string
  "import re; print(';'.join(filter(lambda x: not re.match(x, '\s*'), get_ipython().Completer.all_completions('%s')))) #PYTHON-MODE SILENT\n")

;; настройка режим проверки 
;; need pylint

;; (when (load "flymake" t)
;;   (defun flymake-pylint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "epylint" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pylint-init)))

;; ;; epylint must be put to the ~/bin/epylint
;; #!/usr/bin/env python

;; import re
;; import sys
;; from subprocess import *
;; p = Popen("pylint -f parseable -r n --disable-msg-cat=C,R %s" %
;;           sys.argv[1], shell = True, stdout = PIPE).stdout
;; for line in p.readlines():
;;     match = re.search("\\[([WE])(, (.+?))?\\]", line)
;;     if match:
;;         kind = match.group(1)
;;         func = match.group(3)

;;         if kind == "W":
;;             msg = "Warning"
;;         else:
;;             msg = "Error"

;;         if func:
;;             line = re.sub("\\[([WE])(, (.+?))?\\]",
;;                           "%s (%s):" % (msg, func), line)
;;         else:
;;             line = re.sub("\\[([WE])?\\]", "%s:" % msg, line)
;;         print line,
;;     p.close()

;; need pyflakes
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))


(require 'cl-lib)
(cl-defun m-jedi:complete (&key (expand ac-expand-on-auto-complete))
  (interactive)
  (let ((cur-pos (point)) 
		(col (current-column)) 
		(prevstring (string (char-before (point))))
		(result nil)
		)
	;;(message "before save excursion %s" prevstring)
	(save-excursion 
	  (if (or (eql col 1) (eql col 0) (string-match "\s" prevstring))
		  (setq result t)
		nil
		))
	(if (null result)
		(jedi:complete)
	  (indent-for-tab-command)
	  )))

(defun python-mode-complex-hook () 
  ;;http://stfw.ru/page.php?id=12357
  ;; определение и вызов функции 
  ((lambda ()
	 (message "Run python complex hook")
	 (set-variable 'py-indent-offset 4)
	 (set-variable 'py-smart-indentation nil)
	 (set-variable 'indent-tabs-mode nil)
	 (yas-minor-mode)
	 ;; NOTE:  ??? call yas-minor-mode after 
	 ;; define-key disable yas-minor-mode ???
	 (define-key python-mode-map (kbd "RET") 'newline-and-indent)
     (define-key python-mode-map (kbd "\e\ef") 'flymake-mode)
	 (define-key python-mode-map [(tab)] 'm-jedi:complete)
     (define-key python-mode-map jedi:key-complete 'jedi:complete)
     (define-key python-mode-map (kbd "C-c f") 'flymake-display-err-menu-for-current-line)
	 (jedi:setup)

	 ;;(define-key py-mode-map [tab] 'yas/expand)
	 ;; this change need for correct indent in python mode when use yasnippet
	 ;; ((lambda () (set (make-local-variable 'yas-indent-line) 'fixed)))
	 ;;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
	 (smart-operator-mode-on)
   ))
)

(add-hook 'python-mode-hook 'flymake-mode)
(add-hook 'python-mode-hook 'python-mode-complex-hook)

(defun direx:override-find-item-other-window (&optional item)
  (interactive)
  (setq item (or item (direx:item-at-point!)))
  (direx:override-generic-find-item item t))

(defmethod direx:override-generic-find-item ((item jedi-direx:item)
											 not-this-window)
  "Overriting of method find item, such that tree will be close after select"
  (let* ((root (direx:item-root item))
         (filename (direx:file-full-name (direx:item-tree root)))
         (curwin (get-buffer-window (current-buffer))))
    (if not-this-window
        (progn 
          (find-file-other-window filename)
          (quit-window nil curwin))
      (find-file filename))
    (direx-jedi:-goto-item item)))

;; set key for method
(define-key direx:direx-mode-map (kbd "O") 'direx:override-find-item-other-window)

(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
(add-hook 'jedi-mode-hook 'jedi-direx:setup)

;;(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'auto-mode-alist '("\.py\'" . python-mode))

(provide 'python-config)
