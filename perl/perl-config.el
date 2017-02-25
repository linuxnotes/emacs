;; Config for perl
;; git pull https://github.com/flymake/emacs-flymake-perlcritic.git .
;; git pull https://github.com/Perl-Critic/Perl-Critic.git ~/git/
;; chmod +x ~/git/Perl-Critic/bin/perlcritic


;;; cperl-mode is preferred to perl-mode
(defalias 'perl-mode 'cperl-mode)

(if (is-linux)
	(progn
	  (defun perl-mode-complex-hook ()
		;; определение и вызов функции
		((lambda ()
		   (define-key perl-mode-map (kbd "C-c f") 'flymake-display-err-menu-for-current-line)
		   (define-key cperl-mode-map (kbd "C-c f") 'flymake-display-err-menu-for-current-line)
		   (flymake-mode)
		   (yas-minor-mode)
		   (define-key perl-mode-map (kbd "C-x i") 'yas-expand) ;; redifine insert-file that not used
		   (define-key cperl-mode-map (kbd "C-x i") 'yas-expand) ;; redifine insert-file that not used
		   ))
		)
	  (add-hook 'perl-mode-hook 'perl-mode-complex-hook)
	  (add-hook 'cperl-mode-hook 'perl-mode-complex-hook)
	  (add-to-list 'load-path "~/git/Perl-Critic/extras/")
	  (require 'perlcritic)
	  ;; If flymake_perlcritic isn't found correctly, specify the full path
	  (setq flymake-perlcritic-command
			"~/.emacs.d/perl/bin/flymake_perlcritic")
	  ;; Lets set it to be the most severe available.
	  (setq flymake-perlcritic-severity 4)
	  ;; If you don't want to use the default ~/.perlcriticrc
	  ;;(setq flymake-perlcritic-profile "~/projects/big-project/perlcriticrc")
	  (require 'flymake-perlcritic)
	  ;;
	  (setenv "PATH"
			  (concat
			   (expand-file-name "~/perl5/bin") ":"
			   (expand-file-name "~/git/Perl-Critic/bin/") ":"
			   (getenv "PATH")
			   ))
	  (setenv "PERL5LIB"
			  (concat
			   (expand-file-name "~/perl5/lib/perl5") ":"
			   (expand-file-name "~/perl5") ":"
			   (getenv "PERL5LIB")))
	  (setenv "PERL_LOCAL_LIB_ROOT"
			  (concat
			   (expand-file-name "~/perl5") ":")
			  (getenv "PERL_LOCAL_LIB_ROOT"))
	  )
  nil)

(provide 'perl-config)
