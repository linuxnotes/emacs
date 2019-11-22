;;;; Python configuration
;;;; http://habrahabr.ru/post/46350/

;;; Pymacs installation magic
;; 1. In new pymacs probaly some api changed,
;;    from Pymacs.pymacs import main # not working
;;    # new version
;;    from Pymacs import main
;;    so in files pymacs.el need do replace
;; 2. Error version mismatch.
;;    fix: open pymacs.el and change version same in python
;;    after we can load pycomplete
;; 3. Error on can't find module:
;;    fix: after (require pymacs)
;;         write path where pycomplete is
;; 4. For remove pymacs installed from git need:
;;    remove from /usr/local/lib/python2.7/dist-packages/easy-install.pth path to folder where git repo is
;;
;; On Ubuntu Pymacs, lisp and python can be install with correct versions.
;; python-mode can be download: https://github.com/emacsmirror/python-mode
;; change interpreter directory: (setq default-directory "desired-directory")

;;NOTE CHECK THAT PYTHONPATH IS SETTED
(require 'e-tools)

(define-coding-system-alias 'ascii 'us-ascii)
;;(setq flymake-gui-warnings-enabled nil)

;;pymacs
(add-to-list 'load-path "~/.emacs.d/python/Pymacs/") ;; pymacs
(require 'pymacs)
(if (not (boundp 'pymacs-load-path))
		 (setq pymacs-load-path '())
	nil)
;;

;; Ipython
(setq python-shell-interpreter "ipython"
	  python-shell-interpreter-args "-i")

(setenv "LD_LIBRARY_PATH" (concat
						   "/usr/lib/oracle/11.2/client64/lib:"
						   (getenv "LD_LIBRARY_PATH"))) ;; for cx_Oracle
(e-tools-add-to-path "~/bin/utils")
(e-tools-add-to-list 'load-path
					 "~/.emacs.d/python/Pymacs/"				;; pymacs
					 "~/.emacs.d/lib/emacs-python-environment"		;; jedi
					 "~/.emacs.d/lib/emacs-ctable"					;; jedi
					 "~/.emacs.d/lib/emacs-deferred"				;; jedi
					 "~/.emacs.d/lib/emacs-epc"						;; jedi
					 "~/.emacs.d/lib/emacs-jedi"					;; jedi
					 "~/.emacs.d/lib/direx-el"						;; jedi
					 "~/.emacs.d/lib/emacs-jedi-direx"				;; jedi
					 )

(defun python-config-execute-buffer-in-shell ()
  (interactive)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (let* (
         (buf-file-name (expand-file-name (buffer-file-name)))
         (proc (python-shell-get-process-or-error "Python process not found"))
         (buf (process-buffer proc))
         (test-dir (file-name-directory buf-file-name))
         (test-file (file-name-nondirectory buf-file-name))
         (cd-cmd (concat "cd " test-dir  "\n"))
         (test-cmd (concat "! python " test-file "\n"))
         )
    (switch-to-buffer-other-window buf)
    (comint-send-string proc cd-cmd)
    (sleep-for 0.1)
    (comint-send-string proc test-cmd)
    (sleep-for 0.1)
    ;; (process-send-string proc cd-cmd)
    ;; (process-send-string proc test-cmd)
    (goto-char (point-max))))

(defun python-config-execute-test-in-shell-inter ()
  (interactive)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (let* ((buf-file-name (expand-file-name (buffer-file-name))))
    (python-config-execute-test-in-shell buf-file-name)
  ))

(defun python-config-execute-test-in-shell (file-name)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (require 'bm-tl)
  (let* ((buf-file-name (expand-file-name file-name))
         (proc (python-shell-get-process-or-error "Python process not found"))
         (buf (process-buffer proc))
         (tst-name (bm-tl-get-test-for-py-or-self buf-file-name)))
    (if (not (null tst-name))
        (progn
          (switch-to-buffer-other-window buf)
          (process-send-string proc (concat "cd " (file-name-directory tst-name) "\n"))
          (sleep-for 0.1)
          (process-send-string proc (concat "! python " (file-name-nondirectory tst-name) "\n"))
          (sleep-for 0.1)
          (goto-char (point-max)))
      nil)))

;; python jedi may be slow
(require 'python-environment)
(customize-set-value 'python-environment-virtualenv (list "virtualenv" "--quiet"))
(require 'concurrent)
(require 'epc)
;;(setq jedi:setup-keys t)                      ; optional
;;(setq jedi:complete-on-dot t)                 ; optional
(require 'jedi)
(require 'jedi-direx)
(customize-set-value 'jedi:setup-keys t)
(autoload 'jedi:setup "jedi" nil t)

;; (add-hook 'python-mode-hook 'auto-complete-mode)
;; (add-hook 'python-mode-hook 'jedi:ac-setup)

;; ;; for correct work of tab key
;; (eval-after-load "python"
;;   '(define-key inferior-python-mode-map "\t" 'python-shell-completion-complete-or-indent))

;; ; switch to the interpreter after executing code
;; ;; if no need switch to buffer
;;(setq py-keep-windows-configuration t)

; switch-to-buffer but not split
;; (setq py-split-windows-on-execute-function (lambda() t ))
;; (setq py-split-windows-on-execute nil)

;; ;; ; don't split windows
;; (setq py-switch-buffers-on-execute-p nil)
;; (setq py-split-windows-on-execute-p nil)

(setq py-use-current-dir-when-execute-p t)

(defun ipythonm()
  "Define ipython correct command"
  ;; todo: fix defualt ipython command
  (interactive)
  (run-python)
  (switch-to-buffer "*Python*"))

;; ;; add remove empty strings for get complition to ipython
;; (setq py-ipython0.11-completion-command-string
;;   "import re; print(';'.join(filter(lambda x: not re.match(x, '\s*'), get_ipython().Completer.all_completions('%s')))) #PYTHON-MODE SILENT\n")

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
;; there will be error with files with symbolic links
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name)))
;;            )
;;       (list "pyflakes" (list local-file))
;;       ))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))
(condition-case nil
    (require 'flymake)
  (error nil))

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


;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace)))
;;       (list "pyflakes" (list temp-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))


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

;; (defun elpy-flymake-error-at-point ()
;;   "Return the flymake error at point, or nil if there is none."
;;   (mapconcat #'flymake-diagnostic-text (flymake-diagnostics (point)) "\n"))

(defun python-mode-complex-hook ()
  ;;http://stfw.ru/page.php?id=12357
  ;; определение и вызов функции
  ((lambda ()
	 (message "Run python complex hook")
     (setq python-eldoc-get-doc nil)
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
     ;;(define-key python-mode-map (kbd "C-c f") 'flymake-display-warning)
     (define-key python-mode-map (kbd "C-c f") 'flymake-show-diagnostic)
     ;;(define-key python-mode-map (kbd "C-c f") 'flymake-display-err-menu-for-current-line)
     (define-key python-mode-map (kbd "C-c C-c") 'python-config-execute-buffer-in-shell)
	 (jedi:setup)
	 (define-key python-mode-map (kbd "C-x i") 'yas-expand) ;; redifine insert-file that not used
     (define-key python-mode-map (kbd "C-c c r") 'python-config-execute-test-in-shell-inter) ;; redifine insert-file that not used
     (hs-minor-mode)
	 ;; this change need for correct indent in python mode when use yasnippet
	 ;; ((lambda () (set (make-local-variable 'yas-indent-line) 'fixed)))
	 ;;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
	 ;;(smart-operator-mode-on)
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
  '(define-key python-mode-map "\C-cxj" 'jedi-direx:pop-to-buffer))
(eval-after-load "python-mode"
  '(define-key python-mode-map "\C-cxj" 'jedi-direx:pop-to-buffer))

(add-hook 'jedi-mode-hook 'jedi-direx:setup)

(add-hook 'python-mode-hook 'jedi:setup)

(defun python-config-one-time-hook ()
  (python-mode-complex-hook)
  (remove-hook 'python-mode-hook 'python-config-one-time-hook))

(defun python-config-dired-execute-test()
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (message "test for file-name = %s" file)
    (python-config-execute-test-in-shell file)
    ))

;; run tests for python files
(defun python-config-dired-complex-hook()
  ((lambda ()
     (define-key dired-mode-map (kbd "C-c C-c") 'python-config-dired-execute-test))))

(add-hook 'dired-mode-hook 'python-config-dired-complex-hook)

(provide 'python-config)

