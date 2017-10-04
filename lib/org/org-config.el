;;; configuration for org-mode
(unwind-protect
    (progn (add-to-list 'package-archives
                        '("melpa" . "https://melpa.org/packages/") t)
           (package-install 'org-pomodoro)
           (setf org-pomodoro-length 60))
  nil
)

(defun my-org-mode-hook()
  (define-key org-mode-map (kbd "ESC <S-return>") 'org-insert-todo-heading)
  (define-key org-mode-map (kbd "ESC S-RET") 'org-insert-todo-heading)
  (define-key org-mode-map [?\e (shift return)] 'org-insert-todo-heading))

(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE")
        (sequence "CRITICAL" "|" "COMPLETE")
        (sequence "REPORT" "BUG" "KNOWNCAUSE" "|" "FIXED")
        (sequence "TOFIX" "CONSIDER" "|" "FIXED")
        (sequence "|" "CANCELED")))

;; to insert closed time info
(setq org-log-done 'time)

(add-hook 'org-mode-hook 'my-org-mode-hook)

(provide 'org-config)
