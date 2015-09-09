;;;

(when (is-windows)
  ;; отключить beep в emacs windows
  (setq visible-bell 1)
  ;; change encoding system
  (add-to-list 'process-coding-system-alist '("[cC][mM][dD][pP][rR][oO][xX][yY]" cp1251 . cp1251))
  
  (load  "C:/\\quicklisp\\slime-helper.el")
  ;; Replace "sbcl" with the path to yout implementation
  (setq inferior-lisp-program "H:\\soft\\win\\lisp\\clisp-2.48\\clisp.exe")
  ;; удаление vc-git, который сильно замедляет работу
  (remove-hook 'find-file-hooks 'vc-find-file-hook)
)
