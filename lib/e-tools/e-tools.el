;; Emacs tools.
;; Module contains some functions functions
;;
;;

(defun e-tools-s-join (separator strings)
  "Join all the strings in STRINGS with SEPARATOR in between.
   COPY FROM s.el "
  (mapconcat 'identity strings separator))

(defun e-tools-add-to-list (lst &rest vars)
  (dolist (i vars)
	(add-to-list lst i)))

(defun e-tools-add-to-path (&rest vars)
  (let ((path (getenv "PATH")))
	(if (or (null path)
		  (string-equal path ""))
		nil   ;; do nothing if
	  (progn  ;; else
		(let ((path-list
			   (split-string path ":")))
		  (dolist (i vars)
			(add-to-list 'path-list i))
          (setenv "PATH" (e-tools-s-join ":" path-list)))))))

(defun e-tools-load-module(path-name feature-name)
  "Load module FEATURE-NAME that is in the PATH-NAME folder."
  (add-to-list 'load-path (concat "~/.emacs.d/" path-name))
  (require feature-name))

(defun is-windows ()
  (boundp 'w32-system-shells))

(defun is-linux ()
  (not (boundp 'w32-system-shells)))

;; (defun append-to-list (list-var elements)
;;   "Append ELEMENTS to the end of LIST-VAR.
;;    The return value is the new value of LIST-VAR.
;;    Example: (append-to-list 'some '(\"some1\", \"some2\", \"some3\"))
;;   "
;;   (set list-var (append (symbol-value list-var) elements)))

(provide 'e-tools)
