(require 'hexrgb)

(defun ol-hex-to-rgb(color)
  "Open file with description of file name"
  (interactive (list
                (read-string
				 (format "color%s:" (bm-tl-remove-quote (thing-at-point 'sexp)))
                 nil nil (bm-tl-remove-quote (thing-at-point 'sexp)))))
  (message "color %s" color)
  (let* ((colorlist (hexrgb-hex-to-rgb color))
         (rbs-s (format "rgb(%s, %s, %s)"
                        (round (* (nth 0 colorlist) 255))
                        (round (* (nth 1 colorlist) 255))
                        (round (* (nth 2 colorlist) 255))))
         (pstart nil)
         (pend nil)
         )
    (save-excursion
      (forward-sexp -1)
      (setq pstart (point))
      (forward-sexp 1)
      (setq pend (point))
      (delete-region pstart pend)
      (insert rbs-s))
	  rbs-s))
