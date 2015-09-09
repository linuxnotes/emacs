;; опции которые использовались в какое-то время
;; но по каким-то причинами были признаны не удобными

;; подсветка строки с курсором
(global-hl-line-mode 4)  ;; из-за этой опции возможны тормоза

;; нумерация строк для всех файлов 
(global-linum-mode 1) 

;; подсвечивает блоки, но раздражает
(setq show-paren-style 'expression) 

;; перемещение между буферами
(global-set-key [(control tab)] 'previous-buffer)
(global-set-key [(C-S-iso-lefttab)] 'next-buffer)

;; ;; add some shotcuts in popup menu mode
;; (define-key popup-menu-keymap (kbd "C-n") 'popup-next)
;; (define-key popup-menu-keymap (kbd "TAB") 'popup-next)
;; (define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
;; (define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
;; (define-key popup-menu-keymap (kbd "C-p") 'popup-previous)

;; (yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.
;; (yas/load-directory "~/.emacs.d/snippets/javascript-mode")
;; Let's have snippets in the auto-complete dropdown
;; (add-to-list 'ac-sources 'ac-source-yasnippet)

;; (defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
;;   (when (featurep 'popup)
;;     (popup-menu*
;;      (mapcar
;;       (lambda (choice)
;;         (popup-make-item
;;          (or (and display-fn (funcall display-fn choice))
;;              choice)
;;          :value choice))
;;       choices)
;;      :prompt prompt
;;      ;; start isearch mode immediately
;;      :isearch t
;;      )))

;; (setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))

;; переключение расскадки
;; http://ru-emacs.livejournal.com/82428.html
;; (defun reverse-input-method (input-method)
;;   "Build the reverse mapping of single letters from INPUT-METHOD."
;;   (interactive
;;    (list (read-input-method-name "Use input method (default current): ")))
;;   (if (and input-method (symbolp input-method))
;;       (setq input-method (symbol-name input-method)))
;;   (let ((current current-input-method)
;;         (modifiers '(nil (control) (meta) (control meta))))
;;     (when input-method
;;       (activate-input-method input-method))
;;     (when (and current-input-method quail-keyboard-layout)
;;       (dolist (map (cdr (quail-map)))
;;         (let* ((to (car map))
;;                (from (quail-get-translation
;;                       (cadr map) (char-to-string to) 1)))
;;           (when (and (characterp from) (characterp to))
;;             (dolist (mod modifiers)
;;               (define-key local-function-key-map
;;                 (vector (append mod (list from)))
;;                 (vector (append mod (list to)))))))))
;;     (when input-method
;;       (activate-input-method current))))

;; (defadvice read-passwd (around my-read-passwd act)
;;   (let ((local-function-key-map nil))
;;     ad-do-it))

;; либо переключаиться по С-\ и input-method russian-computer


(defun load-helm()
  (interactive)
  (add-to-list 'load-path "~/.emacs.d/helm/")
  (require 'helm-config.el))

;;(require 'advice)
;;(require 'layout-restore)

;; ;; когда windows установить путь до common lisp
;; (when (is-windows)
;;   (set-variable 'inferior-lisp-program "C:/Users/user/AppData/Roaming/.emacs.d/gcl/gcl.exe")
;;   (autoload 'fi:common-lisp "fi-site-init" "" t))

;; (defun local-hl-line-mode-off ()
;;   (interactive)
;;   (make-local-variable 'global-hl-line-mode)
;;   (setq global-hl-line-mode nil))
;;(add-hook 'ruby-mode-hook 'local-hl-line-mode-off)

;;; плавная прокрутка 
;; http://gaydov.blogspot.ru/2013/02/emacs.html
;; ;; При прокрутке применять font-lock не сразу, а после небольшой задежки.
;; (setq jit-lock-defer-time 0.01)

;; ;; Эту опцию часто советуют выставлять в t, но я не заметил разницы с nil.
;; ;(setq  redisplay-dont-pause t)

;; ;; Опционально: медленная плавная прокрутка колесиком.
;; (setq mouse-wheel-scroll-amount '(2 ((shift) . 2)))   ; Прокручивать по 2 строки.
;; (setq mouse-wheel-progressive-speed nil)
;; (setq mouse-wheel-follow-mouse 't)

;; ;; Опционально: никогда не прокручивать более, чем на 1 строку при перемещении курсора за
;; ;; нижнюю или верхнюю границу экрана.
;; (setq scroll-conservatively 10000)

;; ;; Опционально: отступ от верха и низа экрана в 1 строку, при попадании курсора за отступ
;; ;; происходит прокрутка.
;; (setq scroll-margin 1)
