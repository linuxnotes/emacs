;; bindings special key functions for different charset
;; for emacs > 24.1
;; https://www.linux.org.ru/forum/desktop/8850631
;; http://ru-emacs.livejournal.com/82428.html
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))
;; M-x reverse-input-method RET *computer RET

(setq read-passwd-map
       (let ((map read-passwd-map))
         (set-keymap-parent map minibuffer-local-map)
         (define-key map [return] #'exit-minibuffer)
         (define-key map [backspace] #'delete-backward-char)
         map))

(defadvice read-passwd (around my-read-passwd act)
  (let ((local-function-key-map nil))
    ad-do-it))

(provide 'charset-bindings)
