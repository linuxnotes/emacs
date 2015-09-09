;;;; Цветовая схема
;; Dark Blue 2  Deep Blue RobinHood Subtle Hacker Taylor ; тоже показались интересными
;; настроим цвет
(provide 'theme-config)
(add-to-list 'load-path "~/.emacs.d/theme")
(if (is-windows)
	(add-to-list 'load-path "~/.emacs.d/theme/color-theme"))
;;(require 'color-theme)                                                                      
;;(color-theme-initialize)                                                                    

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/theme/"))
;;http://emacsthemes.caisah.info/zenburn-theme/
;;git clone https://github.com/bbatsov/zenburn-emacs
(load-theme 'zenburn t)
;; (load-theme 'gotham t)
;; (color-theme-xp) 
;; (require 'color-theme-gruber-darker)
;; (color-theme-gruber-darker)
;; (require 'color-theme-subdued)
;; (color-theme-subdued)
;; (color-theme-tty-dark) ; возможно подходит для терминала 

