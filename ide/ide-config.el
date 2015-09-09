;;;

;; cedet + ecb 
;; load only if it need, not every time
(defun load-cedet-ecb () 
  " Загрузка ecb и cedet "
  (interactive)

  ;; load cedet 
  (add-to-list 'load-path "~/.emacs.d/cedet")
  (load-file "~/.emacs.d/cedet/common/cedet.elc")
  (global-ede-mode 1)
  
  ;; load ecb
  (add-to-list 'load-path "~/.emacs.d/ecb")
  (load-file "~/.emacs.d/ecb/ecb.elc")

  (setq ecb-mode-value 1)

  (defun ecb-toogle-visibility() 
	" Переключатель для ecb "
	(interactive)
	(setq ecb-mode-value (- 1 ecb-mode-value));; табы по 4
	(if (> ecb-mode-value 0)
		(ecb-deactivate)
	  (ecb-activate)))

  ;; ecb-togle-ecb-window ;; скрыть показать
  
  ;; left9 left10
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(ecb-layout-name "left10")
   '(ecb-layout-window-sizes (quote (("left10" (0.2297872340425532 . 0.7391304347826086) (0.10212765957446808 . 0.2463768115942029) (0.1276595744680851 . 0.2463768115942029)))))
   '(ecb-options-version "2.40")
   '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
   '(ecb-tree-indent 2)
   '(tool-bar-mode nil))
  (ecb-activate)) 

(setq ecb-tip-of-the-day nil)
;; finish of load cedet-ecb


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-key-map (quote ("C-c ." (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (t "gl" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (t "gd" ecb-goto-window-directories) (t "gs" ecb-goto-window-sources) (t "gm" ecb-goto-window-methods) (t "gh" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
 '(ecb-layout-name "left10")
 '(ecb-layout-window-sizes (quote (("left9" (0.2126865671641791 . 0.9864864864864865)) ("left10" (0.2297872340425532 . 0.7391304347826086) (0.10212765957446808 . 0.2463768115942029) (0.1276595744680851 . 0.2463768115942029)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-tree-indent 2)
 '(tool-bar-mode nil)
)
