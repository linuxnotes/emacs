;; Configuration for spelling checking

(let ((langs '("english" "russian")))
      (setq lang-ring (make-ring (length langs)))
      (dolist (elem langs) (ring-insert lang-ring elem)))

(defun cycle-ispell-languages ()
      (interactive)
      (let ((lang (ring-ref lang-ring -1)))
        (ring-insert lang-ring lang)
        (ispell-change-dictionary lang)))

;; aspell-ru must be installed if aspell else irussian
(setq-default ispell-program-name "ispell")
(setq ispell-local-dictionary "russian")

;; for aspell 
;; http://filonenko-mikhail.blogspot.ru/2012/03/emacs.html
;; need install aspell aspell-ru aspell-en
;; su
;; cd /usr/lib/aspell
;; cp ru.dat ru_backup.dat
;; grep '^special' en.dat >>ru.dat
;; aspell dump master en >w.en
;; aspell dump master ru-yo >w.ru
;; cat w.ru w.en >w.all
;; aspell --lang=ru --encoding=UTF-8 create master ruen.rws < w.all
;; rm -f w.ru w.en w.all
;; echo "add ruen.rws" > ru.multi
;; exit

;; ;; configuration
;; (setq ispell-highlight-face (quote flyspell-incorrect))
;; (setq ispell-have-new-look t)
;; (setq ispell-enable-tex-parser t)
;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'latex-mode-hook 'flyspell-mode)
;; (setq flyspell-delay 1)
;; (setq flyspell-always-use-popup t)

;; (setq flyspell-issue-welcome-flag nil)
;; Need change dictionry to russian for working

;; M+x ispell-change-dictionary RET
;; ru RET
;; M+x ispell

;; (setq
;;  ispell-program-name "aspell"
;;  ispell-extra-args '("--sug-mode=ultra"))

;; add for text mode
(dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))

;; (dolist (hook '(js2-mode-hook python-mode-hook sql-mode-hook emacs-lisp-mode-hook 
;; 							  lisp-mode-hook lua-mode-hook web-mode-hook))
;;       (add-hook hook (lambda () (progn 
;; 								  (flyspell-prog-mode)))))

(add-hook 'prog-mode-hook (lambda() (flyspell-prog-mode)))

(provide 'spell-config)


