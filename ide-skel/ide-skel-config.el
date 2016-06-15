;;;

(defun my-custom-to-sql-ide() 
  (interactive)
  ";; Превращаем emacs в аналог sqldeveloper
  ;; ide-skel, sqlplus, tabbar, plsql
  ;; Инструкция по установке 
  ;; 1. устанавливается instant-client 
  ;; 2. устанавливается instant-client-sqlplus
  ;; 3. устанавливаются расширения для emacs
  ;; 4. конфигурируется tnsnames.ora
  ;; TST1 =
  ;; (DESCRIPTION =
  ;;   (ADDRESS = (PROTOCOL = TCP)(HOST = hostname)(PORT = portnumber))
  ;;   (CONNECT_DATA =
  ;;     (SERVER = DEDICATED)
  ;;     (SERVICE_NAME = XE)
  ;;   )
  ;; )
  ;; для создания подключения sqlplus user/password@TNSNAME "

  (add-to-list 'load-path "~/.emacs.d/ide-skel")
  (require 'tabbar)
  (require 'ide-skel)

  (partial-completion-mode)
  (icomplete-mode)

  (defun ide-skel-toggle-bottom-view-window-and-activate()
	(interactive)
    (ide-skel-toggle-bottom-view-window)
	(let ((win (ide-skel-get-bottom-view-window)))
	  (when (not (null win))
		(select-window win))))

  ;; for convenience
  (global-set-key [C-f4] 'ide-skel-proj-find-files-by-regexp)
  (global-set-key [C-f5] 'ide-skel-proj-grep-files-by-regexp)
  (global-set-key [C-f10] 'ide-skel-toggle-left-view-window)
  (global-set-key [C-f11] 'ide-skel-toggle-bottom-view-window-and-activate)
  (global-set-key [C-f12] 'ide-skel-toggle-right-view-window)
  (global-set-key [C-prior] 'tabbar-backward)
  (global-set-key [C-next]  'tabbar-forward)

  (require 'sqlplus)
  (setf sqlplus-command "sqlplus64")
  (setenv "TNS_ADMIN" (getenv "HOME"))
  (setenv "JAVA_HOME" "/usr/lib/jvm/java-7-openjdk-amd64")
  (setenv "ORACLE_HOME" "/usr/lib/oracle/11.2/client64")
  (setenv "LD_LIBRARY_PATH" (concat  (getenv "ORACLE_HOME") "/lib:$JAVA_HOME/jre/lib/amd64:/usr/local/lib:/usr/lib/oracle/11.2/client64/lib"))
  (setenv "NLS_LANG" "AMERICAN_AMERICA.UTF8")
  (setenv "PATH" (concat
         "~/bin/utils/"
         ":"
         (getenv "PATH")))
  
;;;; (require 'folding)
  ;; подсветка скобок
  ;; (require 'highlight-sexp)
  ;; (add-hook 'lisp-mode-hook 'highlight-sexp-mode)
  ;; (add-hook 'emacs-lisp-mode-hook 'highlight-sexp-mode)

;;;; plsql
  ;; C-c C-c compile current psql buffer
  (defun load-pl-sql-mode() 
	(interactive)
	(require 'plsql)
	(setq plsql-indent 2) 
	)
  (load-pl-sql-mode) ;; будем грузить по умолчанию
  (add-to-list 'auto-mode-alist '("\\.sql$" . plsql-mode))
)

(defun my-include-sqlplus2() 
  (interactive)
  ;; (add-to-list 'load-path "~/.emacs.d/ide-skel")
  (setenv "LD_LIBRARY_PATH" "$ORACLE_HOME/lib:$JAVA_HOME/jre/lib/amd64:/usr/local/lib:/usr/lib/oracle/12.1/client/lib")
  (setenv "NLS_LANG" "AMERICAN_AMERICA.UTF8")
  (load-file "~/.emacs.d/ide-skel/sqlplus2.el")
  ;; (require 'sqlplus2)
)

(provide 'ide-skel-config)
