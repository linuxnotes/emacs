;;https://www.emacswiki.org/emacs/AlignCommands
(defun align-repeat (start end regexp)
  "Repeat alignment with respect to 
     the given regular expression."
  (interactive "r\nsAlign regexp: ")
  (align-regexp start end 
				(concat "\\(\\s-*\\)" regexp) 1 1 t))

;;https://www.emacswiki.org/emacs/DuplicateLines
(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
	(let ((end (copy-marker end)))
	  (while
		  (progn
			(goto-char start)
			(re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
		(replace-match "\\1\n\\2")))))

(defun someutil-replace-to-json (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (someutils-load-region-functions)
  (save-excursion
    (let* ((string (buffer-substring start end))
           (new-string (py-sf-reg-table2json string)))
      (delete-region start end)
      (insert new-string)
      )))

(defun someutils-swap-assignment-line (point)
  (interactive "d")
  (someutils-swap-assignment-region (line-beginning-position) (line-end-position)))

(defun someutils-swap-assignment-region (start end)
  (interactive "*r")
  (someutils-load-region-functions 'py-sf-reg-swap-assignment-line)
  (save-excursion
    (let* ((string (buffer-substring start end))
           (new-string (py-sf-reg-swap-assignment-line string)))
      (delete-region start end)
      (insert new-string))))

(defun someutils-load-region-functions(&optional f force)
  (if (null f)
      (setq f 'py-sf-reg-table2json)
    nil)
  (if (or (not (fboundp f)) (not (null force)))
      (progn
        (pymacs-exec (concat
                      "if not \""
                      (format (bm-tl-join (expand-file-name "~/.emacs.d/") "python" "python_helpers") t)
                      "\" in sys.path: sys.path.append(\""
                      (format (bm-tl-join (expand-file-name "~/.emacs.d/")
                                          "python" "python_helpers") t) "\")"))

        (pymacs-load "string_functions.region" "py-sf-reg-"))
    nil))

(defun uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

(defun pdb-restart ()
  (interactive)
  (comint-insert-send "restart")
  (sleep-for .5)
  (when
      (or
       (last-lines-match "raise Restart.*
Restart")
       (last-lines-match "restart")
       (not (get-buffer-process (current-buffer)))
       )

    (let (
      (kill-buffer-query-functions nil );disable confirming for process kill
      (pdbcmd (car-safe (symbol-value (gud-symbol 'history nil 'pdb))))
      (default-directory default-directory)
      )
      (kill-this-buffer)
      (cd default-directory)
      (pdb pdbcmd))
    )
  (comint-insert-send "n")
)
(defun comint-insert-send (input)
  (insert input)
  (comint-send-input)
)
(defun last-lines-match (regexp &optional n)
  (setq n (or n 3))
  (re-search-backward regexp (line-beginning-position (- 0 n)) t))

(defun shell-cd-to ()
"Insert cd string to shell buffer for to go to directory of current file"
(interactive)
  (let ((default-directory (file-name-directory buffer-file-name))
        (l-dir-name (file-name-directory buffer-file-name)))
    (shell "*shell*")
    (insert-string (concatenate 'string "cd " l-dir-name))))

(global-set-key (kbd "C-x g") 'shell-cd-to)

(defun shell-dir (name dir)
  (interactive "sShell name: \nDDirectory: ")
  (let ((default-directory dir))
    (shell name)))
