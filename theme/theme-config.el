;;;; Theme config
;; remove toolbars
(tool-bar-mode -1)
(scroll-bar-mode -1)
;;Don't show startup screen
(setq inhibit-startup-message t)
;; short answers
(fset 'yes-or-no-p 'y-or-n-p)
;;(setq scroll-step 1)
;;show pair brackets
(show-paren-mode t)

;; Dark Blue 2  Deep Blue RobinHood Subtle Hacker Taylor ; тоже показались интересными
;; настроим цвет
;;; fonts
;; cp hack2.0 /usr/share/fonts/truetype/ -R
;; fc-cache
;; set-default-font font keep-size fonts if font equal t then also for future
(defun initfuncs-set-fonts (&rest args)
  (message "initfuncs-set-fonts")
  (condition-case nil
      (progn (set-default-font "Hack 12" t t)
             ;;(set-default-font "DejaVu Sans Mono 9" t t)
             ;;(set-face-attribute 'default nil :height 90) ;; 90 = 9pt
             (message "font setted"))
    (error
     (if (is-linux)
         (set-default-font "Monospace 10" t t) ;; шрифт для Linux
       (set-default-font "Courier New 10" t t))
     )))
(initfuncs-set-fonts)
;; excecute after create frame
;;(add-to-list 'after-make-frame-functions #'initfuncs-set-fonts)

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
(provide 'theme-config)
