;; My functions for simplify emacs configurations
;;
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

(provide 'e-tools)
