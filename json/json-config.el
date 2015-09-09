;;;; Настройки для работы с json

(modify-coding-system-alist 'file "\\.json\\'" 'utf-8) ;; json файлы в utf-8
(require 'json-mode)
(provide 'json-config)
