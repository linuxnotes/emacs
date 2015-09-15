;;
;;emacs lisp
(defun elisp-mode-complex-hook()
  (yas-minor-mode)
  (define-key emacs-lisp-mode-map [tab] 'yas/expand)
  (setq yas/after-exit-snippet-hook 'indent-according-to-mode)
)
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-complex-hook)

(add-to-list 'auto-mode-alist '("\\.cl\\'" . common-lisp-mode))

(provide 'elisp-config)
