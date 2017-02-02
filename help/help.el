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
