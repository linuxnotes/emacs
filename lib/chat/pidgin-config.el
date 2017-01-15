(defun pidgin-load()
  (interactive)
  (add-to-list 'load-path "~/lib/emacs-chat")
  (require 'pidgin)
  ;;default input method
  ;;(setq pidgin-default-input-method "russian-computer")
  ;;set name of existing directory for store history
  ;; nead add / to directory description, 
  ;; bacause it will be write to file in concat folder name and file, and not 
  ;; in file in desired folder 
  (setq pidgin-messenger-directory "~/.pidgin_log_directory/")
  (pidgin-connect))

(provide 'pidgin-config)
