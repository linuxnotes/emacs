;; http://emacs.stackexchange.com/questions/13005/is-there-a-decent-log-viewing-mode-for-large-log-files
;; https://libraries.io/emacs/logview
;; https://github.com/doublep/logview/issues/3 -- config example
;; https://www.emacswiki.org/emacs/Logview  -- logview
;; https://github.com/doublep/datetime/blob/master/datetime.el -- datetime
;; http://ergoemacs.org/emacs/elisp_datetime.html -- datetime
;; https://github.com/zonuexe/emacs-datetime -- emacs datetime
;; https://github.com/zonuexe/emacs-datetime/blob/master/datetime-format.el -- datetime-format
;; http://stackoverflow.com/questions/21419976/looking-for-a-good-debug-log-file-viewer
;; https://github.com/doublep/logview
;; http://logio.org/
;; https://lovwrite.wordpress.com/about/ -- not by theme some writer
;; https://github.com/ARCANEDEV/LogViewer -- logviewer for php primary
;; http://stackoverflow.com/questions/2513479/redirect-prints-to-log-file

;; costom variables
(custom-set-variables

 ;; addition log format
 `(logview-additional-timestamp-formats
   '(("python-log-err"
      (java-pattern . "yyyy-MM-dd HH:mm:ss,SSS"))))

 ;; addition sumode
 `(logview-additional-submodes
   ;; "TIMESTAMP LEVEL [IGNORED] [THREAD] NAME"
   '(("PYTHON-LOGGING" . ((format . "TIMESTAMP LEVEL [IGNORED] [THREAD] ")
                          (levels . "PYTHON_LOG")
                          (aliases .  ("PythonLogSub"))))))

 ;; addition level mappings
 `(logview-additional-level-mappings
   '(("PYTHON_LOG" . ((error       "ERROR" "CRITICAL")
                      (warning     "WARN" "WARNING")
                      (information "INFO" "SESSION")
                      (debug       "DEBUG")
                      (trace       "TRACE")
                      (aliases     "PythonLogLevels"))))))

(provide 'logview-config)

;; Example for set timestamp with regexp
;; May be it doesnot working
;; '(logview-additional-timestamp-formats
;;  (quote
;;   (("xxx"
;;     (regexp . "[0-9]{4}-[01][0-9]-[0-3][0-9] [012][0-9]:[0-5][0-9]:[0-9]{8}")
;;     (aliases)))))
