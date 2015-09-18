;;;; Настройки для работы с json

(modify-coding-system-alist 'file "\\.json\\'" 'utf-8) ;; json файлы в utf-8
(require 'json-mode)

;; set for correct encoding without \u
(setq json-reformat:pretty-string? 't)
(provide 'json-config)
