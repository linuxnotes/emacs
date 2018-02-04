;;http://stackoverflow.com/questions/4115465/emacs-dired-too-much-information
;; (dired-hide-details-mode) ;; or key ( will hide unhide details

(require 'dired+)
(require 'dired-tar)

(defcustom e:dired-project-path nil
  "Current active project"
  :group 'e:dired
  :tag "Current active project"
  :type '(string))

(defun e:dired-open-project()
  (interactive)
  (dired e:dired-project-path))

(defun e:dired-open-shell()
  (interactive)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (let* (
         (folder-name (expand-file-name default-directory))
         (proc (get-process "shell"))
         (buf (get-buffer "*shell*"))
         )
    (switch-to-buffer-other-window buf)
    (process-send-string proc (concat "cd " (file-name-directory folder-name) "\n")) ; "\n" ;; in the end
    (comint-send-input)
    (setq default-directory (file-name-directory folder-name))
    (goto-char (point-max))
    ))

(defun e:dired-open-eshell()
  (interactive)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (let* ((folder-name (expand-file-name default-directory)))
    (with-current-buffer "*eshell*"
      (eshell-return-to-prompt)
      (insert (concat "cd " folder-name))
      (eshell-send-input))
    (switch-to-buffer-other-window "*eshell*")
    ))

(defun e:dired-eshell-project()
  (interactive)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (let* ((folder-name (expand-file-name default-directory)))
    (with-current-buffer "*eshell*"
      (eshell-return-to-prompt)
      (insert (concat "cd " e:dired-project-path))
      (eshell-send-input))
    ))

;; remove temp files
(defun e:dired-clear-folder ()
  (interactive)
  (message "Clear folder, directory: %s" default-directory)
  (shell-command "rm *.pyc *~ *.orig")
  (revert-buffer)
)

(defun e:dired-complex-hook()
  ((lambda ()
     (define-key dired-mode-map (kbd "C-c C-e") 'e:dired-open-eshell)
     (define-key dired-mode-map (kbd "C-c C-s") 'e:dired-open-shell)
     (define-key dired-mode-map (kbd "C-c C-l") 'e:dired-clear-folder)
     )))
(add-hook 'dired-mode-hook 'e:dired-complex-hook 1)

(autoload 'du "~/.emacs.d/lib/dired/disk-usage" "List disk usage in DIR.

With prefix arg EDIT-ARGS, let user to edit arguments given to du." t)

(provide 'dired-config)

;; (require 'ls-lisp)
;; (setq ls-lisp-use-insert-directory-program nil)
;;
;; (custom-set-variables
;;  '(ls-lisp-verbosity nil))
;;
;; (defadvice ls-lisp-format (around my-ls-lisp-format
;;   (file-name file-attr file-size switches time-index now))
;;   "Advice definition which removes unnecessary information
;; during file listing in dired. For such purposes
;; `ls-lisp-verbosity' customized variable can be used, but
;; even if it is equal to nil dired will display file
;; permissions field like \"drwxrwxrwx\".\. So here we just
;; get full control to what dired shows and leave only those
;; fields which we need."
;;   (progn
;;     ad-do-it
;;     (setq ad-return-value (concat
;;       (substring ad-return-value 0 1)
;;       (substring ad-return-value 13)))))
;; (Ad-activate 'ls-lisp-format t)
