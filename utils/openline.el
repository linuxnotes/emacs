;; альтeрнатива move-beginning-of-line
;; set-mark-command
;; search forward
;; copy
(defun vli-extract-file-name ()
  "Получить имя файла в строке"
  (let ((l-start-pos)
		(l-finish-pos)
		(l-file-name))
	(save-excursion
	  (move-beginning-of-line 1)
	  (search-forward "not_view_src")
	  (backward-char (length "not_view_src"))
	  (setq l-start-pos (point))
	  (message "l-start-pos = %d" l-start-pos)
	  (message "cur-point = %d" (point))
	  (search-forward-regexp "\\(\\.asm \\)\\|\\(\\.cs \\)\\|\\(\\.c \\)\\|\\(\\.inc \\)\\|\\(\\.sql \\)")
	  (setq l-finish-pos (point))
	  (message "l-finish-pos = %d" l-finish-pos)
	  (setq l-file-name (buffer-substring l-start-pos l-finish-pos))
	  (message "l-file-name = %s" l-file-name)
	  (setq l-file-name (concat "d:/testing/41_vlijanije/src/" l-file-name)))))

(defun vli-find-number()
  (interactive)
  (let ((l-t-s))
	(message "line-end-position = %d" (line-end-position))
	(setq l-t-s (buffer-substring (point) (line-end-position)))
	(string-match "\\([0-9]+\\)" l-t-s)
	(message "matching = %s" (match-string 1 l-t-s))))

(defun vli-extract-line-number ()
  "Получить имя файла в строке"
  (interactive)
  (let ((l-line-part)
		(l-line-number))
	(save-excursion
	  (move-beginning-of-line 1)
	  (search-forward "на строке")
	  (setq l-line-part (buffer-substring (point) (line-end-position)))
	  (message "l-line-part = %s" l-line-part)
	  (string-match "\\([0-9]+\\)" l-line-part)
	  (setq l-line-number (match-string 1 l-line-part))
	  (message "line-number = %s" l-line-number)
	  (setq l-line-number (string-to-int l-line-number))
	  (message "line-nuber = %d" l-line-number)
	  l-line-number
	  )))

(defun which-active-modes ()
  "Give a message of which minor modes are enabled in the current buffer."
  (interactive)
  (let ((active-modes))
    (mapc (lambda (mode) (condition-case nil
                             (if (and (symbolp mode) (symbol-value mode))
                                 (add-to-list 'active-modes mode))
                           (error nil) ))
          minor-mode-list)
    ))

(defun open-asm-file()
  "Открыть файл"
  (interactive)
  (let (
		(l-file-name)
		(l-line-number)
		(l-buffer)
		)
	(setq l-file-name (vli-extract-file-name))
	(setq l-line-number (vli-extract-line-number))
	(message "l-file-name = %s, line-number = %d" l-file-name l-line-number)
	(setq l-buffer (find-file l-file-name))
	(goto-line l-line-number l-buffer)
	(with-current-buffer l-buffer
	  (funcall 'nlinum-mode))
  )
)

(global-set-key (kbd "C-x C-j") 'open-asm-file)
