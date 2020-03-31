Emacs helps

Usefull and other modules
----------------------
* **compile** - Compile the program including the current buffer.  Default: run `make'.
                Runs COMMAND, a shell command, in a separate process asynchronously
                with output going to the buffer `*compilation*'.

* **global-text-scale** Global text scale
                        It makes emacs slow, so disabled.

  .. code::

     ;; it make emacs VERY slow
     (use-package global-text-scale
       :load-path "lib/default-text-scale"
       :commands global-text-scale-adjust
       :bind
       (("M-+" . (lambda () (interactive) (global-text-scale-adjust 1))) ;
        ("M--" . (lambda () (interactive) (global-text-scale-adjust -1)))
        )
       )
     ;; (global-text-scale-adjust 0)
     ;; (global-text-scale-mode)  ;; enable/disable

 
* **powerline** -- beautiful mode line

  .. code::

     make emacs slow
     power line pretty status bar
     (package-install 'powerline)
     (powerline-default-theme)
     (setq powerline-default-separator 'arrow-fade)


* **evil** -- emacs vim mode

  .. code::

     (use-package evil
      :load-path "lib/evil"
      :commands evil-mode
      :init (require 'evil)
      :bind (([f9] . evil-mode)))

* **nlinum** -- line number mode, that should be faster than linum
                relative modes: **nlinum-relative**, **nlinum-hl**

  .. code::

     ;; https://www.emacswiki.org/emacs/LineNumbers
     ;; 
     (load-file "~/.emacs.d/nlinam/nlinum.el")
     (global-set-key [f8] 'nlinum-mode)

* **todo**   -- todo mode

  .. code::

     (add-to-list 'load-path "~/.emacs.d/todo/")
     (require 'todo-config)
     
* **emacs-nav** -- file tree

  .. code::

     (defun load-nav()
       "Load navigator panel"
       (interactive)
       (add-to-list 'load-path "~/.emacs.d/emacs-nav-49/")
       (require 'nav)
       (nav-disable-overeager-window-splitting)
       ;;(nav)
       ;; Optional: set up a quick key to toggle nav
       (global-set-key [?\C-x ?n ?n]  'nav-toggle))
     (load-nav)
