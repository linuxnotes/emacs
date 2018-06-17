;; HELP and TODO
;; C-q C-j перевод на другую строку можно использовать при
;; выполнении замены

;; TODO: Посмотреть что это
;;(global-set-key (kbd "C-c e") 'else-expand-placeholder)

;; Данную команду нужно использовать для того чтобы скомпилировать javascript file
;; emacs --batch -eval '(byte-compile-file "js2.el")')

;;{{{ удобный выбор файла и буфера
;; TDOO: сделать чтобы было активно, если открыт
;; только один буффер
;; (require 'lusty-explorer)
;; ;; вместо find-file
;; (global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
;; ;; вместо switch-to-buffer
;; (global-set-key (kbd "C-x b") 'lusty-buffer-explorer)
;; ;;}}}

;; пересобрать все файлы
;;C-u 0 M-x byte-recompile-directory

;; сменить кодировку файла
;;(set-buffer-file-coding-system)
;;(encode-coding-region) ;; перекодировать выделенный регион

;; чтобы перекодироваь регион нужно выполнить
;; recode-region

;;чтобы в xterm Alt корректно работало в
;; echo 'xterm*metaSendsEscape: true' >> /etc/X11/app-defaults/XTerm
;; sudo sh -c $'echo \'xterm*metaSendsEscape: true\' >> /etc/X11/app-defaults/XTerm'

;; for use same color theme in console mode
;; env TERM=xterm-256color emacs -nw
;; export TERM=xterm-256color

;;
;; C-u s for dired mode set the params for ls
;; i в dired mode добавляет содержимое каталога к текущему каталогу

;;  M - ` показывает меню в соседнем буфере

;; отключить tab и установить ширину tab
;; https://www.emacswiki.org/emacs/NoTabs
;; (setq indent-tabs-mode nil)
;; (infer-indentation-style)

;; toggle-truncate-lines ;; отключить перевод строк

;; https://www.emacswiki.org/emacs/BuildTags#toc3
;; cd /path/to/my/project
;; find . -type f -iname "*.[ch]" | etags -
;; (setq tags-table-list
;;      '("~/emacs" "/usr/local/lib/emacs/src"))
;; visit-tags-table M-. M-,

;; C-x C-- уменьшить текст
;; C-x C-+ увеличить текст

;; C-u M-q block-fill выравнивание правой и левой части
;; C-u <length> fill-region выравнять по заданной длине
;; fill-region 'right выровнять по правому краю


;; flush-lines ^\s-*$ удалить все пустые строки

;; .emacs.d/projectile-bookmarks.eld удалить, если projectile начал ругаться на end of file during parsing

;; (set-frame-fot "Font 9") set font size for window
										;
;; erase-buffer clear shell buffer
;; comint-clear-buffer for emacs > 25

;; C-x l [count-lines-page]
;; C-h l [view-lossage]

;; excecute after create frame
;; (defun set-my-scrollbars (_)
;;  (set-scroll-bar-mode 'right))
;; (add-to-list 'after-make-frame-functions #'set-my-scrollbars)

;; https://github.com/pft/elisp-assorted/blob/master/disk-usage.el


;; C-x r s r
;; Copy region into register r (copy-to-register).
;; C-x r i r
;; Insert text from register r (insert-register).
;; M-x append-to-register <RET> r
;; Append region to text in register r.
;; When register r contains text, you can use C-x r + (increment-register) to append to that register. Note that command C-x r + behaves differently if r contains a number. See Number Registers.
;;
;; M-x prepend-to-register <RET> r

;; It is bound to C-x TAB.
;; (indent-rigidly START END ARG &optional INTERACTIVE)
;; and than with <left> <right> <s-left> <s-right> region can be moved.


;; key + C-h describe key bindings

;; delete up to char 'zap-to-char
;; M-z
