;;;;

;; http://draketo.de/licht/freie-software/emacs/namespaces-elisp

(defmacro namespace (prefix &rest sexps)
  (let* ((naive-dfs-map
          (lambda (fun tree)
            (mapcar (lambda (n) (if (listp n) (funcall naive-dfs-map fun n)
                                  (funcall fun n))) tree)))
         (to-rewrite (loop for sexp in sexps
                           when (member (car sexp)
                                        '(defvar defmacro defun))
                           collect (cadr sexp)))
         (fixed-sexps (funcall naive-dfs-map
                               (lambda (n) (if (member n to-rewrite)
                                               (intern
                                                (format "%s-%s" prefix n)) n))
                               sexps)))
    `(progn ,@fixed-sexps)))

(provide 'namespace)

;; example 
;; (require 'namespace)
;; (namespace foo
;;            (defun bar ()
;;              "bar")
;;            (defun foo (s)
;;                "foo"))

;; (foo-foo (foo-bar))
