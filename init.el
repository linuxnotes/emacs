;;;;
(require 'package)

;Add melpa to list of repositories
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/")
         t)

;Initialize package.el
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lib/e-tools")
(require 'e-tools)
(require 'compile)

(e-tools-load-module "lib/use-package" 'use-package)
(customize-set-value 'use-package-verbose t)

(use-package ace-jump-mode
  :defer t
  :load-path "lib/ace-jump-mode"
  :init
  (autoload 'ace-jump-mode "ace-jump-mode" nil t)
  (define-key global-map (kbd "C-c j") 'ace-jump-mode)
  (define-key global-map (kbd "C-c c") 'ace-jump-char-mode)
  :config
  (setq ace-jump-mode-move-keys
           (nconc (loop for i from ?a to ?z collect i))))

(use-package evil
  :load-path "lib/evil"
  :commands evil-mode
  :init (require 'evil)
  :bind (([f9] . evil-mode)))

;; power line pretty status bar
(package-install 'powerline)
(powerline-default-theme)
(setq powerline-default-separator 'arrow-fade)

(package-install 'ssh)
(setq tramp-default-method "ssh")
(require 'ssh)
(setq ssh-directory-tracking-mode t)

(if (>= emacs-major-version 26)
;;; OVERWRITE for comint-file-name-prefix computing
    (defun ssh (input-args &optional buffer)
      "Open a network login connection via `ssh' with args INPUT-ARGS.
INPUT-ARGS should start with a host name; it may also contain
other arguments for `ssh'.

Input is sent line-at-a-time to the remote connection.

Communication with the remote host is recorded in a buffer `*ssh-HOST*'
\(or `*ssh-USER@HOST*' if the remote username differs\).
If a prefix argument is given and the buffer `*ssh-HOST*' already exists,
a new buffer with a different connection will be made.

When called from a program, if the optional second argument BUFFER is
a string or buffer, it specifies the buffer to use.

The variable `ssh-program' contains the name of the actual program to
run.  It can be a relative or absolute path.

The variable `ssh-explicit-args' is a list of arguments to give to
the ssh when starting.  They are prepended to any arguments given in
INPUT-ARGS.

If the default value of `ssh-directory-tracking-mode' is t, then the
default directory in that buffer is set to a remote (FTP) file name to
access your home directory on the remote machine.  Occasionally this causes
an error, if you cannot access the home directory on that machine.  This
error is harmless as long as you don't try to use that default directory.

If `ssh-directory-tracking-mode' is neither t nor nil, then the default
directory is initially set up to your (local) home directory.
This is useful if the remote machine and your local machine
share the same files via NFS.  This is the default.

If you wish to change directory tracking styles during a session, use the
function `ssh-directory-tracking-mode' rather than simply setting the
variable.

The variable `ssh-x-display-follow-current-frame' can be used to specify
how ssh X display tunelling interacts with frames on remote displays."
      (interactive (list
		            (read-from-minibuffer "ssh arguments (hostname first): "
                                          (ssh-hostname-at-point)
                                          nil nil 'ssh-history)
		            current-prefix-arg))

      (let* ((process-connection-type ssh-process-connection-type)
             (args (ssh-parse-words input-args))
             (host-parts (split-string (car args) "@"))
             (host (car (last host-parts)))
             (user (or (cadr (member "-l" args))
                       (if (= 2 (length host-parts)) (car host-parts))
                       (user-login-name)))
             (buffer-name (if (string= user (user-login-name))
                              (format "*ssh %s*" host)
                            (format "*ssh %s@%s*" user host)))
             proc)

        (and ssh-explicit-args
             (setq args (append ssh-explicit-args args)))

        (cond ((null buffer))
	          ((stringp buffer)
	           (setq buffer-name buffer))
              ((bufferp buffer)
               (setq buffer-name (buffer-name buffer)))
              ((numberp buffer)
               (setq buffer-name (format "%s<%d>" buffer-name buffer)))
              (t
               (setq buffer-name (generate-new-buffer-name buffer-name))))

        (setq buffer (get-buffer-create buffer-name))
        (pop-to-buffer buffer-name)

        (cond
         ((comint-check-proc buffer-name))
         (t
          (ssh-with-check-display-override
           #'(lambda ()
               (comint-exec buffer buffer-name ssh-program nil args)))
          (setq proc (get-buffer-process buffer))
          ;; Set process-mark to point-max in case there is text in the
          ;; buffer from a previous exited process.
          (set-marker (process-mark proc) (point-max))

          ;; comint-output-filter-functions is treated like a hook: it is
          ;; processed via run-hooks or run-hooks-with-args in later versions
          ;; of emacs.
          ;; comint-output-filter-functions should already have a
          ;; permanent-local property, at least in emacs 19.27 or later.
          (cond
           ((fboundp 'make-local-hook)
            (make-local-hook 'comint-output-filter-functions)
            (add-hook 'comint-output-filter-functions 'ssh-carriage-filter nil t))
           (t
            (make-local-variable 'comint-output-filter-functions)
            (add-hook 'comint-output-filter-functions 'ssh-carriage-filter)))

          (ssh-mode)

          (make-local-variable 'ssh-host)
          (setq ssh-host host)
          (make-local-variable 'ssh-remote-user)
          (setq ssh-remote-user user)

          (message "ssh-directory-tracking-mode = %s" ssh-directory-tracking-mode)
          (condition-case ex
              (cond ((eq ssh-directory-tracking-mode t)
                     ;; Do this here, rather than calling the tracking mode
                     ;; function, to avoid a gratuitous resync check; the default
                     ;; should be the user's home directory, be it local or remote.
                     (setq comint-file-name-prefix
                           (concat "/ssh:" "" ssh-remote-user "@" ssh-host ":"))
                     (cd-absolute comint-file-name-prefix))
                    ((null ssh-directory-tracking-mode))
                    (t
                     (cd-absolute (concat comint-file-name-prefix "~/"))))
            (error
             (message "error comint-file-name-prefix = %s error = %s" comint-file-name-prefix ex)
             )))))
      buffer)
  nil)
(add-hook 'ssh-mode-hook
          (lambda ()
            (setq ssh-directory-tracking-mode t)
            (shell-dirtrack-mode t)
            ))

;;; Utils
(defmacro part-module-load(name &optional feature)
  "Load module macro"
  `(progn
	 (add-to-list 'load-path ,(concat "~/.emacs.d/" (symbol-name name)))
	 ,(if (not (not feature))
		 `(require ',feature)
	   `(require ',(intern (concat (symbol-name name) "-config")))
	   ))
  )

;; отключение стандартной
;; системы контроля версий
;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html
(setf vc-handled-backends nil)

(e-tools-add-to-list 'load-path "~/.emacs.d/lang" "~/.emacs.d/lib"  "~/.emacs.d/cl-lib")
(condition-case nil
	(require 'cl-lib)
  (error(load-file "~/.emacs.d/cl-lib/cl-lib.el")))

;; шрифт
;; cp hack2.0 /usr/share/fonts/truetype/ -R
;; fc-cache
;; set-default-font font keep-size fonts if font equal t then also for future
(defun initfuncs-set-fonts (&rest args)
  (message "initfuncs-set-fonts")
  (condition-case nil
      (progn (set-default-font "Hack 9" t t)
             (message "font setted"))
    (error
     (if (is-linux)
         (set-default-font "Monospace 10" t t) ;; шрифт для Linux
       (set-default-font "Courier New 10" t t))
     ))
  )
(initfuncs-set-fonts)
;; excecute after create frame
;;(add-to-list 'after-make-frame-functions #'initfuncs-set-fonts)

;; move backups in special directory
;; Write backup files to own directory
;; Backups and temp files
(setq-default backup-directory-alist '(("." . "~/.emacs-backups"))
              auto-save-file-name-transforms '((".*" "~/.emacs-autosaves/" t))
              backup-by-copying t
              create-lockfiles nil)


;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)
;;(setq make-backup-files nil)

;; выключить toolbar
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;не показывть начальный экран
(setq inhibit-startup-message t)

;; табы по 4
(setq default-tab-width 4)

;; краткие ответы на вопрос
(fset 'yes-or-no-p 'y-or-n-p)

;;
(setq scroll-step 1)

;; dont change window
(push (cons "\\*shell\\*" display-buffer--same-window-action) display-buffer-alist)

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
(global-set-key (kbd "\e\er") 'revert-buffer)

;; поиск файла
(global-set-key (kbd "\e\exf") 'find-file-at-point)

;; перемещение с использованием Alt
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)
;; newline-without-break-of-line
(defun newline-without-break-of-line ()
  "https://stackoverflow.com/questions/5898448/how-to-add-a-new-line-without-breaking-the-current-line
  1. move to end of the line.
  2. insert newline with index"

  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))

(global-set-key (kbd "<C-return>") 'newline-without-break-of-line)

;; for windows
(defun m-prev-window()
  (interactive)
  (other-window -1))

(global-set-key (kbd "C-x p") 'm-prev-window) ;; previous-multiframe-window
(global-set-key [f3] 'other-window) ;; default C-x o
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)


;; замена строк
(global-set-key (kbd "C-x C-m") 'replace-string)

;; меню для вставки
(global-set-key (kbd "C-c y") '(lambda ()
    (interactive) (popup-menu 'yank-menu)))

;; remove binding set-fill-prefix
(global-set-key (kbd "C-x .") nil)

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
;;(load-file "~/.emacs.d/popup/popup.el")
(require 'popup)

;; autocomplete
(add-to-list 'load-path "~/.emacs.d/auto-complete")
;;(load "~/.emacs.d/auto_complete/auto-complete.el")
(require 'auto-complete) ;; if load not by require it will be jedi:complete error
(customize-set-value 'ac-auto-start nil)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto_complete/dict")
(require 'auto-complete-config)
(global-auto-complete-mode t)
(global-set-key (kbd "C-c i") 'auto-complete)

;; change key-maps
(define-key ac-completing-map "\M-n" nil)
(define-key ac-completing-map "\M-p" nil)
(define-key ac-completing-map "\C-n" 'ac-next)
(define-key ac-completing-map "\C-p" 'ac-previous)

;;(ac-config-default)
;;(customize-set-value 'ac-auto-show-menu 0.2)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;; Load the snippet files themselves
(setq yas-snippet-dirs
      '("~/.emacs.d/yasnippet/yasmate/snippets" "~/.emacs.d/yasnippet/snippets"
		"~/.emacs.d/my_snippets"))
(yas-reload-all) ;; this need for use yasnippet as minor mode
(setq yas-indent-line 'fixed)

(use-package elisp-config
  :load-path "elisp"
  :commands common-list-mode
  :mode (("\\.cl\\'" . common-list-mode)))

(use-package js-config
  :load-path "js"
  :commands js2-mode
  :mode (("\\.js\\'" . js2-mode)))

(use-package visual-basic-mode
  :load-path "lib/vb-mode"
  :commands visual-basic-mode
  :mode (("\\.vb\\'" . visual-basic-mode)
         ("\\.vbs\\'" . visual-basic-mode)))

;; python and perl also autoloaded,
;; so add config by hook
(use-package python-config
  :commands (ipythonm)
  :hook (python-mode . python-config-one-time-hook)
  :load-path "python")

(use-package perl-config
  :hook (perl-mode . perl-config-one-time-hook)
  :load-path "perl")

(use-package lua-mode
  :load-path "lib/lua-mode"
  :commands lua-mode
  :mode ("\\.lua\\'" . lua-mode))

(use-package json-mode
  :load-path "lib/json-mode" "lib/json-snatcher" "lib/json-reformat"
  :commands json-mode
  :mode ("\\.json\\'" . json-mode)
  :init (modify-coding-system-alist 'file "\\.json\\'" 'utf-8)
  :config (setq json-reformat:pretty-string? 't))

;; cs-mode
(use-package csharp-mode
  :load-path "cs-mode"
  :commands csharp-mode
  :mode ("\\.cs\\'" . csharp-mode))

;; web mode
;; http://web-mode.org/
;; MMM Mode for Emacs и https://bitbucket.org/pjenvey/mmm-mako/downloads/
(use-package web-mode
  :load-path "web-mode"
  :commands (web-mode)
  :mode (("\\.mako\\'" . web-mode)
         ("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.html?\\'" . web-mode)))

;; макросы
;;(e-tools-load-module "macros" 'my-user-macro)

;; Themes
(e-tools-load-module "theme" 'theme-config)

;; projectile
;; projectile-mode ;; если нужно не глобально
(add-to-list 'load-path "~/.emacs.d/projectile")
(add-to-list 'load-path "~/.emacs.d/projectile/dash")
(add-to-list 'load-path "~/.emacs.d/projectile/s")
(add-to-list 'load-path "~/.emacs.d/projectile/f")
(add-to-list 'load-path "~/.emacs.d/projectile/pkg-info")
(add-to-list 'load-path "~/.emacs.d/projectile/epl")
(if (not (is-windows))
	(progn
	  (require 'projectile)
      (custom-set-variables
       '(projectile-mode-line
         '(:eval (format " P[%s]" (projectile-project-name))))
       )
	  (projectile-global-mode))
  nil)

;; autopair
;; for emacs >= 24.4 electric-pair-mode is recomended
;; else autopair
(if (or (>= emacs-major-version 24)
        (and (= emacs-major-version 24)
             (>= emacs-minor-version 4)))
    (electric-pair-mode)
  (progn (add-to-list 'load-path "~/.emacs.d/autopair")
         (require 'autopair)
         (autopair-global-mode)
         ))

;; todo
;; (add-to-list 'load-path "~/.emacs.d/todo/")
;; (require 'todo-config)

;; ;; navigator
;; (defun load-nav()
;;   " Загрузка панели навигатора "
;;   (interactive)
;;   (add-to-list 'load-path "~/.emacs.d/emacs-nav-49/")
;;   (require 'nav)
;;   (nav-disable-overeager-window-splitting)
;;   ;;(nav)
;;   ;; Optional: set up a quick key to toggle nav
;;   (global-set-key [?\C-x ?n ?n]  'nav-toggle))
;; (load-nav)

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
;; (delete-whitespa/ce-rectangle)

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

;;;;;;;; ahg ;;;;;;;;;;;;;;;;;;
;;(add-to-list 'load-path "~/.emacs.d/lib/ahg")
;;(require 'ahg)
;;(global-set-key (kbd "C-c h g d") 'ahg-status-cur-dir)
(use-package ahg
  :load-path "lib/ahg"
  :commands ahg-status ahg-glog ahg-log ahg-status-cur-dir ahg-log-cur-file
  :config
  (progn
    ;; patched for user ahg for directory or for full project
    (defun ahg-status-clbk (clbk &rest extra-switches)
      "Run hg status. When called non-interactively, it is possible
to pass extra switches to hg status."
      (interactive)
      (let ((buf (get-buffer-create "*aHg-status*"))
            (curdir default-directory)
            (show-message (interactive-p))
            (root (ahg-root)))
        (when ahg-status-consider-extra-switches
          (let ((sbuf (ahg-get-status-buffer root)))
            (when sbuf
              (with-current-buffer sbuf
                (setq extra-switches ahg-status-extra-switches)))))
        (with-current-buffer buf
          (let ((inhibit-read-only t))
            (erase-buffer))
          (setq default-directory (file-name-as-directory curdir))
          (set (make-local-variable 'ahg-root) (car extra-switches)) ;; changes
          (set (make-local-variable 'ahg-status-extra-switches) extra-switches)
          (ahg-push-window-configuration))
        (ahg-generic-command
         "status" extra-switches
         (lexical-let ((clbk clbk)
                       (default-dir (car extra-switches))
                       (no-pop ahg-status-no-pop)
                       (point-pos ahg-status-point-pos))
           (lambda (process status)
             (ahg-status-sentinel process status no-pop point-pos)
             (funcall clbk)
             ))
         buf
         nil (not show-message))))

    (defun ahg-status-refresh ()
      (interactive)
      (let ((ahg-status-point-pos (ahg-line-point-pos))
            ;;(ahg-status-consider-extra-switches t)
            )
        (call-interactively 'ahg-status-cur-dir)))

    (defun ahg-status-cur-dir ()
      "Get status of current directory"
      (interactive)
      (let ((curdir default-directory)
            (newcurdir (expand-file-name default-directory))
            )
        (setq default-directory newcurdir)
        (ahg-status-clbk (lexical-let ((_newcurdir newcurdir)) (lambda () (setq default-directory _newcurdir)))
                         newcurdir)
        (setq default-directory newcurdir)))
      (global-set-key (kbd "C-c h g d") 'ahg-status-cur-dir)
    )
  :init
  (bind-key "C-c h g s" 'ahg-status)
  (bind-key "C-c h g g" 'ahg-glog)
  (bind-key "C-c h g l" 'ahg-log)
  (bind-key "C-c h g d" 'ahg-status-cur-dir))

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

;; load special settings
(condition-case nil
	(require 'init-special)
  (error nil))

;; for current magit 2.11.0
;; cd ~/.emaac.d/ext-lib/
;; git clone https://github.com/magit/magit.git
;; git clone https://github.com/magit/with-editor
;; git clone https://github.com/magnars/dash.el.git
;; cd magit;

;; ;; add to config.mk
;; LOAD_PATH  = -L ~/creation/magit/lisp
;; LOAD_PATH += -L ~/creation/dash.el
;; LOAD_PATH += -L ~/creation/with-editor
;; git checkout 2.11.0
;; make

;; If not doesn't make, need try remove compiled files.
;; cd ~/.emacs.d/
;; find . -name '*.elc' | xargs rm
(add-to-list 'load-path "~/.emacs.d/ext-lib/with-editor")
(add-to-list 'load-path "~/.emacs.d/ext-lib/magit/lisp")
(condition-case nil
    (progn
      (require 'magit)
      (setq magit-last-seen-setup-instructions "2.11.0")))
(global-set-key (kbd "C-c h g m") 'magit-status)

;; my functions
(defun change-brackets (from-b to-b)
  "Функция выполняет замену скобок с одного типа на другой"
  (interactive "cfrom:\ncto:")
  (message "from-b %c" from-b)
  (message "to-b %c" to-b)

  (let* (
		 (pairs '( (?\(. ?\)) (?\{.?\}) (?\[.?\]) (?\".?\") (?\'.?\')))
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
;; git clone https://github.com/auto-complete/auto-complete.git
;; git clone https://github.com/capitaomorte/yasnippet.git
;; git clone https://github.com/AndreaCrotti/yasnippet-snippets.git
;; git clone https://gitlab.com/python-mode-devs/python-mode.git
;; cd ~/.emacs.d/python/python-mode/
;; git reset --hard 74072ce9b7924a21636eb2735e35eacc1439bba6
;;
;; ;; switch-window
;; cd ~/.emacs.d/lib/switch-window
;; git clone https://github.com/dimitri/switch-window.git
;;

;; git clone git://github.com/magit/magit.git
;; cd magit; git reset 1.4.2 --hard;
;; git clone https://github.com/magit/git-modes
;; cd git modes; make lisp docs; cd ..
;; cp git-modes/git-commit-mode.elc . ; cp git-modes/git-rebase-mode.elc .
;; make lisp

;; git clone https://github.com/winterTTr/ace-jump-mode.git
;; git clone https://github.com/tkf/emacs-python-environment.git
;; git clone https://github.com/kiwanami/emacs-ctable.git
;; git clone https://github.com/kiwanami/emacs-deferred.git
;; git clone https://github.com/kiwanami/emacs-epc.git
;; git clone https://github.com/tkf/emacs-jedi.git
;; git clone https://github.com/tkf/emacs-jedi-direx.git
;; git clone https://github.com/m2ym/direx-el.git
;; hg clone https://bitbucket.org/agriggio/ahg
;; cd projectile; wget http://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el
;;; grep by extensions
;; grep -r --include \*.<ext> -n --color -e <template> --exclude-dir=designer
(grep-compute-defaults) ;; установить значения по умолчанию
(grep-apply-setting 'grep-command "grep * -r -n --color -i -e")
(grep-apply-setting 'grep-find-command "find . ! -name \"*~\" ! -name \"#*#\" -type f -print0 | xargs -0 -e grep -nH -e ")

(use-package dired
  :defer 1
  :load-path "~/.emacs.d/lib/dired"
  :commands dired
  :init (require 'dired-config))

;; Configuration for dictionaries
(add-to-list 'load-path "~/.emacs.d/dictem/")
(require 'dictem-config)

;; disable beep
(setq visible-bell 1)

(when (is-windows)
  (add-to-list 'process-coding-system-alist '("[cC][mM][dD][pP][rR][oO][xX][yY]" cp1251 . cp1251))
  (remove-hook 'find-file-hooks 'vc-find-file-hook))

;; set bindings for differrent charset
(when (>= emacs-major-version 24)
  (progn (require 'charset-bindings)
		 (reverse-input-method (intern charset-symbol-name))))

(if (file-exists-p (expand-file-name "~/ide-skel/ide-skel-config.el"))
	(e-tools-load-module "ide-skel" 'ide-skel-config)
  nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-auto-indent-p nil)
 '(js2-bounce-indent-p nil)
 '(js2-electric-keys (quote ("{" "}" "(" ")" "[" "]" ":" ";" "," "*")))
 '(js2-highlight-level 3)
 '(logview-additional-level-mappings
   (quote
    (("PYTHON_LOG"
      (error "ERROR" "CRITICAL")
      (warning "WARN" "WARNING")
      (information "INFO" "SESSION")
      (debug "DEBUG")
      (trace "TRACE")
      (aliases "PythonLogLevels")))))
 '(logview-additional-submodes
   (quote
    (("PYTHON-LOGGING"
      (format . "TIMESTAMP LEVEL [IGNORED] [THREAD] ")
      (levels . "PYTHON_LOG")
      (aliases "PythonLogSub")))))
 '(logview-additional-timestamp-formats
   (quote
    (("python-log-err"
      (java-pattern . "yyyy-MM-dd HH:mm:ss,SSS")))))
 '(package-selected-packages (quote (org-pomodoro ssh "ssh" powerline "powerline")))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.mail.ru")
 '(smtpmail-smtp-service 465)
 '(smtpmail-stream-type (quote ssl)))
(global-hl-line-mode 1)

;; Editing
(setq-default tab-width 4
              fill-column 80
              indent-tabs-mode nil
              show-paren-style 'expression)

;; All program modes
(add-hook 'prog-mode-hook (lambda ()
                            (setq show-trailing-whitespace t)
                            ))

(show-paren-mode)
(put 'erase-buffer 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun initfuncs-to-underscore ()
  (interactive)
  (progn (replace-regexp "\\([A-Z]\\)" "_\\1" nil (region-beginning) (region-end))
         (downcase-region (region-beginning) (region-end)))
  )

(add-to-list 'load-path "~/.emacs.d/lib/ibuffer")
(require 'ibuffer-config)

(add-to-list 'load-path "~/.emacs.d/lib/org")
(require 'org-config)

(add-to-list 'load-path "~/.emacs.d/lib/undo-tree")
(require 'undo-tree-config)

;; (add-to-list 'load-path "~/.emacs.d/lib/icicles/")
;; (require 'icicles-config)

;;; php-mode
;;git clone https://github.com/ejmr/php-mode.gi
(use-package php-mode
  :load-path "lib/php-mode" "lib/php-mode/skeleton"
  :commands php-mode
  :mode ("\\.php\\'" . php-mode))
(eval-after-load 'php-mode
  '(require 'php-ext))


;;; logview-mode
;; check for commit: 902c881
;; git clone https://github.com/doublep/logview.git
;; check for commit: d8674ac
;; https://github.com/doublep/datetime.git
;; check for commit: 3860b69
;; git clone https://github.com/doublep/extmap.git
(use-package logview
  :load-path "lib/logview" "lib/logview/logview" "lib/logview/datetime" "lib/logview/extmap"
  :commands logview-mode
  :mode ("\\.log\\(?:\\.[0-9]+\\)?\\'" . logview-mode)
  :init
  (progn (require 'logview)
         (require 'logview-config)))
(put 'narrow-to-region 'disabled nil)

;; https://medium.com/@enzuru/sunrise-commander-an-orthodox-file-manager-for-emacs-2f92fd08ac9e
;; git clone https://github.com/escherdragon/sunrise-commander
;; (add-to-list 'load-path "~/.emacs.d/lib/sunrise-commander")
;; (require 'sunrise-commander)
;; (require 'sunrise-x-buttons)
;; (require 'sunrise-x-modeline)
;; (add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))

;; eshell
(defun eshell-clear ()
  "Clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

;; for performance
(setq auto-window-vscroll nil)
