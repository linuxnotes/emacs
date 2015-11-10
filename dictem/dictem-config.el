;;;; Configuration for using dictem
;; * apt-get install dcit dictd dictzip dictfmt
;; * download dictionaries from dict.mova.org/dicts
;; *  add for every database into /etc/dictd/dictd.conf
;;      database sdict { data "/usr/share/dictd/sdict_ru-en.dict.dz"
;;                       index "/usr/share/dictd/sdict_ru-en.index" }
;; * chmod +r /usr/share/dictd
;; * service dictd restart

(provide 'dictem-config)

(when (executable-find "dictd")            ; check dictd is available
   (require 'dictem))

(setq dictem-server "localhost")
(setq dictem-user-databases-alist
      `(("_en-en"  . ("foldoc" "gcide" "wn"))))
 
(setq dictem-use-user-databases-only t)
(setq dictem-default-database "korolew")

(setq dictem-port   "2628")
(dictem-initialize)

;; http://superuser.com/questions/355037/how-to-use-dictem-in-emacs
(setq dictem-default-strategy "word")
(setq dictem-use-user-databases-only t)

;; For creating hyperlinks on database names
;; and found matches.
(add-hook 'dictem-postprocess-match-hook
          'dictem-postprocess-match)

;; For highlighting the separator between the definitions found.
;; This also creates hyperlink on database names.
(add-hook 'dictem-postprocess-definition-hook
          'dictem-postprocess-definition-separator)

;; For creating hyperlinks in dictem buffer
;; that contains definitions.
(add-hook 'dictem-postprocess-definition-hook
          'dictem-postprocess-definition-hyperlinks)

;; For creating hyperlinks in dictem buffer
;; that contains information about a database.
(add-hook 'dictem-postprocess-show-info-hook
          'dictem-postprocess-definition-hyperlinks)

(define-key dictem-mode-map [tab] 'dictem-next-link)
(define-key dictem-mode-map [(backtab)] 'dictem-previous-link)

(setq dictem-user-databases-alist
      '(("_en-en"  . ("foldoc" "gcide" "wn"))))

;;; http://paste.lisp.org/display/89086
(defun dictem-run-define-at-point-with-query ()
  "Query the default dict server with the word read in within this function."
  (interactive)
  (let* ((default-word (thing-at-point 'symbol))
         (default-prompt (concat "Lookup Word "
                                 (if default-word
                                     (concat "(" default-word ")") nil)
                                 ": "))
         (dictem-query
          (funcall #'(lambda (str)
                       "Remove Whitespace from beginning and end of a string."
                       (replace-regexp-in-string "^[ \n\t]*\\(.*?\\)[ \n\t]*$"
                                                 "\\1"
                                                 str))
                   (read-string default-prompt nil nil default-word))))
    (if (= (length dictem-query) 0) nil
      (dictem-run 'dictem-base-search (dictem-get-default-database) dictem-query "."))))

(defun dictem-run-define-at-point ()
  "dictem look up for thing at point"
  (interactive)
  (let* ((default-word (thing-at-point 'symbol))
         (dictem-query
          (funcall #'(lambda (str)
                       "Remove Whitespace from beginning and end of a string."
                       (replace-regexp-in-string "^[ \n\t]*\\(.*?\\)[ \n\t]*$"
                                                 "\\1"
                                                 str))
                   default-word)))
    (if (= (length dictem-query) 0) nil
      (dictem-run 'dictem-base-search (dictem-get-default-database) dictem-query "."))))

(global-set-key "\C-cd" 'dictem-run-define-at-point)
(global-set-key "\C-cD" 'dictem-run-define-at-point-with-query)

(global-set-key "\C-cs" 'dictem-run-search)
(global-set-key "\C-cm" 'dictem-run-match)
;; (global-set-key "\C-cd" 'dictem-run-define)
