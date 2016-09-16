(defun pidgin-load()
  (interactive)
  (add-to-list 'load-path "~/lib/emacs-chat")
  (require 'pidgin)
  ;;default input method
  ;;(setq pidgin-default-input-method "russian-computer")
  ;;set name of existing directory for store history
  (setq pidgin-messenger-directory "~/.pidgin_log_directory")
  (pidgin-connect))

(provide 'pidgin-config)
