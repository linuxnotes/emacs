;;;; Настройки для работы с python 
;;;; http://habrahabr.ru/post/46350/
(provide 'python-config)

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
(setenv "PYTHONPATH" "/usr/lib/python2.7/site-packages:/home/anton/bm/config/lib:/home/anton/.emacs.d/python/python-mode/completion")

(setq py-install-directory "~/.emacs.d/python/python-mode/")
(add-to-list 'load-path "~/.emacs.d/python/python-mode/completion")
(add-to-list 'load-path py-install-directory)

(require 'python-mode)
;;(require 'pycomplete)
(ac-config-default)
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
	 (define-key py-mode-map (kbd "RET") 'newline-and-indent)
	 ;;(define-key py-mode-map [tab] 'yas/expand)
	 ;; this change need for correct indent in python mode when use yasnippet
	 ((lambda () (set (make-local-variable 'yas-indent-line) 'fixed)))
	 ;;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
	 (smart-operator-mode-on)
   ))
)

(add-hook 'python-mode-hook 'python-mode-complex-hook 1)
(global-set-key (kbd "\e\ef") 'flymake-mode)

(add-to-list 'auto-mode-alist '("\.py\'" . python-mode))

