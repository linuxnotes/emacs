;;;; 
;;;; TODO
(add-to-list 'load-path "~/.emacs.d/todo/")
(require 'todotxt)
(defun todotxt-mode-disable()
  (interactive)
  (text-mode)
  (setq buffer-read-only nil))

(defun todotxt-mode-edit-enable()
  (interactive)
  (setq buffer-read-only nil))

;; todo 
(defun open-todolist ()
  (interactive) 
  (find-file "~/todo.txt"))

(defun print-buffer-main-mode()
  (interactive)
  (message "%s" major-mode))

(provide 'todo-config)
