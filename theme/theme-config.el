;;;; Цветовая схема
;; Dark Blue 2  Deep Blue RobinHood Subtle Hacker Taylor ; тоже показались интересными
;; настроим цвет
(provide 'theme-config)
(add-to-list 'load-path "~/.emacs.d/theme")
(if (is-windows)
	(add-to-list 'load-path "~/.emacs.d/theme/color-theme"))
;;(require 'color-theme)                                                                      
;;(color-theme-initialize)                                                                    

(when (not (boundp 'custom-theme-load-path))
  (message "custome theme load path")
  (defvar custom-theme-load-path '() "variable for themes")
  (message "custome theme load path %s" custom-theme-load-path)
)

(if (not custom-theme-load-path)
	(setq custom-theme-load-path (expand-file-name "~/.emacs.d/theme/"))
  (add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/theme/"))
)

;;http://emacsthemes.caisah.info/zenburn-theme/
;;git clone https://github.com/bbatsov/zenburn-emacs
;;git clone https://github.com/bkruczyk/badwolf-emacs.git
;;git clone https://github.com/jasonblewis/color-theme-wombat.git
;; (condition-case nil
;; 	(load-theme 'badwolf t)
;;   (error (load-theme 'badwolf))
;; )
;; (condition-case nil
;; 	(load-theme 'wombat t)
;;   (error (load-theme 'wombat))
;; )
(condition-case nil
	(load-theme 'zenburn t)
  (error (load-theme 'zenburn))
)
;; (load-theme 'gotham t)
;; (color-theme-xp) 
;; (require 'color-theme-gruber-darker)
;; (color-theme-gruber-darker)
;; (require 'color-theme-subdued)
;; (color-theme-subdued)
;; (color-theme-tty-dark) ; возможно подходит для терминала 

