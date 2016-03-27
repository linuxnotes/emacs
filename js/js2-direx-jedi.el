(defun js2-not-nil-listp (var)
;;check that var is lisp and not null
  (if (and (listp var) (not (null var)))
	  t
	nil))

(defun js2-make-cache-node (prop   &optional type)
  (message "prop = %s" prop)
  (if (null type)
	  (setq type "function")
	nil
	)
  (if (null prop) nil 
	(if (js2-not-nil-listp prop)
		(progn
		  (message "car = %s cdr = %s cadr = %s type = %s" (car prop) (cdr prop) (cadr prop) (type-of (cadr prop)))
		  (list :name (car prop) :type type :column 1 :line_nr (/ (cadr prop) 1) :pos (cdr prop) ;:doc "" :description "" :local_name "" :full_name ""
))
	  (list :name prop :type type :column 1 :line_nr 1 :pos 1;:doc "" :description "" :local_name "" :full_name ""
)
	  )))

(defun js2-is-cache-node (prop) 
  (if (and (not (null prop))
		   (or (not (js2-not-nil-listp prop))
			   (and (= (length prop) 2)
					(not (js2-not-nil-listp (car prop))) 
					(not (js2-not-nil-listp (cadr prop))))
			   ))
	  t
	nil)
  )

(defun js2-my-node-type (prop)
  (let ((result (if (not (js2-not-nil-listp prop)) "class" "function")))
	result)
  )

;; основная проблема в том что когда ("some" ( нужно убирать список
;; а когда ("some" number) нужно наоборот добавлять список
(defun js2-my-transform-tree (p-tree)
  (if (null p-tree) 
	  nil 
	(if (js2-is-cache-node (car p-tree))
		(progn 
		  (if (js2-not-nil-listp (cdr p-tree)) 
			  (if (not (js2-not-nil-listp (car p-tree)));; если простое свойство
				  (cons (js2-make-cache-node (car p-tree) (js2-my-node-type (car p-tree)))
						(car (js2-my-transform-tree (cdr p-tree))))
				(cons (cons (js2-make-cache-node (car p-tree) (js2-my-node-type (car p-tree))) nil) 
					  (js2-my-transform-tree (cdr p-tree)))
				)
			(if (not (js2-not-nil-listp (car p-tree)))
				(cons (js2-make-cache-node (car p-tree) (js2-my-node-type (car p-tree))) nil)
			  (cons (cons (js2-make-cache-node (car p-tree) (js2-my-node-type (car p-tree))) nil) nil)))
		  )
	  (cons (js2-my-transform-tree (car p-tree)) (js2-my-transform-tree (cdr p-tree)))
	  )))

;; (defun show-browse-postprocess-chains() 
;;   (interactive)
;;   (let* ((result (js2-browse-postprocess-chains))
;; 		 (my-tree (js2-build-alist-trie result nil))
;; 		 )
;; 	;;(let ((result (js2-parse (current-buffer))))
;; 	;;(message "%s" result)
;;     (message "%s"(js2-my-transform-tree my-tree))
;;     ;;(message "%s" (pp-to-string js2-imenu-recorder))
;;     ;;(message "%s" (car js2-imenu-function-map))
;; 	nil))

(defun js2-get-names-cache() 
  (interactive)
  (let* ((result (js2-browse-postprocess-chains))
		 (my-tree (js2-build-alist-trie result nil))
		 (result (js2-my-transform-tree my-tree)))
    (message "result = %s" result)
	;; (setq result '(((:name "CTreeStore" :type "class" :column 1 :line_nr 1)
	;; 				((:name "CTreeStore2" :type "function" :column 1 :line_nr 3)))
	;; 			   ((:name "CTreeStore1" :type "function" :column 2 :line_nr 2))
	;; 			   )
	;; 	  )
    result
    ))

(defun js2-jedi-direx:make-buffer ()
  (direx:ensure-buffer-for-root
   (make-instance 'jedi-direx:module
                  :name (format "*direx-jedi: %s*" (buffer-name))
                  :buffer (current-buffer)
                  :file-name (buffer-file-name)
                  :cache (cons nil (js2-get-names-cache)))))

(defun js2-jedi-direx:pop-to-buffer ()
  (interactive)
  (pop-to-buffer (js2-jedi-direx:make-buffer)))

(defun js2-direx-jedi:-goto-item()
  (interactive)
  (let* ((item (direx:item-tree (direx:item-at-point!)))
		 (cur-item-prop (car (oref item :cache)))
		 (root (direx:item-root (direx:item-at-point!)))
		 (filename nil)
		 )
    (message "item = %s" item)
    (message "cur-item-prop = %s" cur-item-prop)
    (message "root = %s" root)
    (setq filename (direx:file-full-name (direx:item-tree root)))
    (message "filename = %s" filename)
	(find-file-other-window filename)
	(destructuring-bind (&key line_nr column &allow-other-keys) cur-item-prop
	  (goto-char line_nr)
	  )
	)
  )
