(defun my-custom-to-sql-ide() 
  (interactive)
  ";; Превращаем emacs в аналог sqldeveloper
  ;; ide-skel, sqlplus, tabbar, plsql
  ;; Инструкция по установке 
  ;; 1. устанвливается instant-client 
  ;; 2. устанавливается instant-client-sqlplus
  ;; 3. устанваливаются расширения для emacs
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

  ;; for convenience
  (global-set-key [C-f4] 'ide-skel-proj-find-files-by-regexp)
  (global-set-key [C-f5] 'ide-skel-proj-grep-files-by-regexp)
  (global-set-key [C-f10] 'ide-skel-toggle-left-view-window)
  (global-set-key [C-f11] 'ide-skel-toggle-bottom-view-window)
  (global-set-key [C-f12] 'ide-skel-toggle-right-view-window)
  (global-set-key [C-prior] 'tabbar-backward)
  (global-set-key [C-next]  'tabbar-forward)

  (require 'sqlplus)
  (setenv "LD_LIBRARY_PATH" "$ORACLE_HOME/lib:$JAVA_HOME/jre/lib/amd64:/usr/local/lib:/usr/lib/oracle/12.1/client/lib")
  (setenv "NLS_LANG" "AMERICAN_AMERICA.UTF8")
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
	(setq plsql-indent 4) 
	)
  (load-pl-sql-mode) ;; будем грузить по умолчанию
  (add-to-list 'auto-mode-alist '("\\.sql$" . plsql-mode))
)
