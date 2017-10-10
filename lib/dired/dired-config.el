;;http://stackoverflow.com/questions/4115465/emacs-dired-too-much-information
;; (dired-hide-details-mode) ;; or key ( will hide unhide details

(defun initfunc-open-perlhandler()
  (interactive)
  (dired "~/creation/ia/Externals/Perl/PerlHandler"))

(defun open-eshell-in-current-directory ()
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

(defun eshell-cd-to-perl-parser ()
  (interactive)
  ;; in *Python* goto to folder of current buffer
  ;; execute !python buffer_name
  (let* ((folder-name (expand-file-name default-directory)))
    (with-current-buffer "*eshell*"
      (eshell-return-to-prompt)
      (insert (concat "cd " "~/creation/ia/Externals/Perl/PerlHandler"))
      (eshell-send-input))
    ))

(defun dired-mode-complex-hook()
  ((lambda ()
     (define-key dired-mode-map (kbd "C-c C-e") 'open-eshell-in-current-directory)
     (define-key dired-mode-map (kbd "C-c C-l") 'clear-folder))))
(add-hook 'dired-mode-hook 'dired-mode-complex-hook 1)

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
