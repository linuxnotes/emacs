;;; Макросы

;; для создания макроса нужно сделать 
;; макрос, потом name-last-kbd-macro
;; потом insert-kbd-macro (можно и без name-last-kbd-macro)

;; макрос для преобразования new в Ext.create
(fset 'newToExtCreate
   [?\S-\C-f ?\S-\C-f ?\S-\C-f ?\S-\C-f ?\C-x ?\C-m ?n ?e ?w ?  return ?E ?x ?y backspace ?t ?/ backspace ?. ?c ?r ?e ?a ?t ?e ?\( ?\" return ?\C-s ?\( ?\C-b ?\S-\C-f ?\C-x ?\C-m ?\( return ?\" ?, return])

(fset 'var_to_property
   [?\S-\C-f ?\S-\C-f ?\S-\C-f ?\S-\C-f ?\C-w ?\C-s ?= ?\C-b ?\S-\C-f ?\C-w ?\C-_ ?\C-b ?\S-\C-f ?\C-x ?\C-m ?= return ?: return ?\C-e ?\C-b ?\C-\M-n ?\S-\C-f ?\C-x ?\C-m ?\; return ?, return])

(fset 'shifttab
   [?\C-u ?- ?4 ?\C-x tab])

(fset 'arrtofuncall
   [?\C-  ?\C-f ?\C-x ?\C-m ?\[ return ?\( return ?\C-s ?\] ?\C-  ?\C-b ?\C-  ?\C-f ?\C-x ?\C-m ?\] return ?\) return ?\C-x ?\C-s])

(fset 'quote-dict
   [?\C-  ?\C-s ?: ?\C-b ?\" ?\C-a ?\C-n])

;;забиндим это на esc-esc-n
(global-set-key (kbd "\e\en") 'newToExtCreate)
(global-set-key [backtab] 'shifttab)

(provide 'my-user-macro)


