;; Configuration for spelling checking

(let ((langs '("english" "russian")))
      (setq lang-ring (make-ring (length langs)))
      (dolist (elem langs) (ring-insert lang-ring elem)))

(defun cycle-ispell-languages ()
      (interactive)
      (let ((lang (ring-ref lang-ring -1)))
        (ring-insert lang-ring lang)
        (ispell-change-dictionary lang)))

;; aspell-ru must be installed if aspell else irussian
(setq-default ispell-program-name "ispell")
(setq ispell-local-dictionary "russian")

;; add for text mode
(dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))

;; (dolist (hook '(js2-mode-hook python-mode-hook sql-mode-hook emacs-lisp-mode-hook 
;; 							  lisp-mode-hook lua-mode-hook web-mode-hook))
;;       (add-hook hook (lambda () (progn 
;; 								  (flyspell-prog-mode)))))

(add-hook 'prog-mode-hook (lambda() (flyspell-prog-mode)))

(provide 'spell-config)


