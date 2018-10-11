
;;;; Configuration for using dictem
;; * apt-get install dcit dictd dictzip dictfmt
;; * download dictionaries from dict.mova.org/dicts
;; * add for every database into /etc/dictd/dictd.conf
;;   database sdict { data "/usr/share/dictd/sdict_ru-en.dict.dz"
;;                    index "/usr/share/dictd/sdict_ru-en.index" }
;; * chmod +r /usr/share/dictd
;; * service dictd restart

;;  remove dictd server process
;;  ps aux | grep dictd | grep -v grep  | awk ' { print $2; }' | sudo xargs kill -2
;;  sudo dictd -L <path> -v
;;  sudo apt-get install dict-freedict-eng-rus
;;  sudo /usr/lib/stardict-tools/stardict2txt enru.ifo enru.txt
;;  sudo dictfmt  --utf8 -f enru < enru.txt
;;  http://stardict-4.sourceforge.net/HowToCreateDictionary -- generate from tabfile idx and ifo for startdict
;;  https://gist.github.com/rongyi/ff2f8a1a82cddb2efc9239bb0d7ca78b  -- startdict2txt
;;  https://github.com/huzheng001/stardict-3/tree/master/tools -- startdict-3/tools
;;  need write util that create index file from tabfile
;;  https://manpages.debian.org/testing/dictd/dictd.8.en.html -- about index file
;;  https://en.wikipedia.org/wiki/DICT -- description of dict server
;;  http://tech.memoryimprintstudio.com/the-ultimate-offline-dictionary-with-dictd-in-linux/ --install dictd for arch linux
;;  https://github.com/substack/parse-dictd -- parse dict files
;;  http://download.huzheng.org/ -- dictionaries archives
;;  http://stardict-4.sourceforge.net/StarDictFileFormat
;;
;;  create virtualenv:
;;  git clone https://github.com/ilius/pyglossary.git
;;  change in setup.py import VERSION
;;  python setup.py install
;;  in the same folder (It may require to add pyglossary to PYTHONPATH)
;;  pyglossary
;;  convert from ifo to index
;;  cp dictname.dict.dz /usr/share/dictd/
;;  cp dictname.index   /usr/share/dictd/

;; add to dictd.conf:
;;
;; # Database section here:
;; database dictname { data  "/usr/share/dictd/dictname.dict.dz"
;;                     index "/usr/share/dictd/dictname.index" }
;;
;;

(provide 'dictem-config)

(when (executable-find "dict")            ; check dictd is available
  (require 'dictem)

  (setq dictem-server "localhost")
  (setq dictem-user-databases-alist
        `(("en-ru"  . ("enru")) ("ru-en"  . ("ruen")))
		;;`(("_en-en"  . ("foldoc" "gcide" "wn")))
        )

  (setq dictem-use-user-databases-only t)
  (setq dictem-default-database "*")

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

  (global-set-key "\C-cxd" 'dictem-run-define-at-point)
  (global-set-key "\C-cxD" 'dictem-run-define-at-point-with-query)

  ;; (global-set-key "\C-cs" 'dictem-run-search)
  ;; (global-set-key "\C-cm" 'dictem-run-match)
  ;; (global-set-key "\C-cd" 'dictem-run-define)
)


;;;; Python alternatives that may be need to see.
;; https://stackoverflow.com/questions/21395011/python-module-with-access-to-english-dictionaries-including-definitions-of-words
;; https://github.com/atykhonov/google-translate -- google-translate module for emacs

;; google-translate
;;
(add-to-list 'load-path "~/.emacs.d/lib/google-translate")
(require 'google-translate)
(require 'google-translate-default-ui)
(customize-set-variable 'google-translate-default-source-language "en")
(customize-set-variable 'google-translate-default-target-language "ru")
(global-set-key "\C-cxg" 'google-translate-at-point)
(global-set-key "\C-cxG" 'google-translate-at-point-reverse)



