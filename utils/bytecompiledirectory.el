(defun string/ends-with (s ending)
      "Return non-nil if string S ends with ENDING."
      (cond ((>= (length s) (length ending))
             (let ((elength (length ending)))
               (string= (substring s (- 0 elength)) ending)))
            (t nil)))


;; (load-file "C:Users\\user\\AppData\\Roaming\\.emacs.d\\utils\\bytecompiledirectory.el")
;; (special-byte-compile-directory "C:Users\\user\\AppData\\Roaming\\.emacs.d\\utils\\")

(defun is-ignored (elt ignores)
  (let ((result nil))
	(catch 'aaa 
	  (dolist (ign ignores nil)
		(if (string-equal (expand-file-name elt) (expand-file-name ign))
			(progn 
			  (setq result t)
			  (throw 'aaa 1))
		  )))
  result
  ))

(defun special-byte-compile-directory(directory &optional ignores)
  (message "special-byte-compile-directory %s " directory)
  (message "directory files =  %s " (directory-files directory))
  (let ((files (directory-files directory)))
	;;(format t "files = %s" files)
	(message "files = %s" files)
	(message "files1 = %s" files)
	(dolist (elt files nil)
	  (message "file = %s" elt)
	  (setq elt (concat (file-name-as-directory directory) elt))
	  (if (and (file-regular-p elt) (string/ends-with elt "el")) 
		  (progn
			(message " compile file %s" elt)
			(byte-compile-file elt))
		(if (and (file-directory-p elt) (not (string/ends-with elt ".")) (not (string/ends-with elt "..")) 
(listp ignores) (not (is-ignored elt ignores)))
			(special-byte-compile-directory elt ignores))
		  )
	  )
	)
  )
