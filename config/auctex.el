;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2008-12-05 22:19:58  Zhixun LIN>
;;
;; AUCTeX
;;--------------------------------------
 (require 'tex-site)
(add-hook 'LaTeX-mode-hook 
	  (lambda()
	    (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
 	    (TeX-PDF-mode t)
 	    (setq TeX-command-default "XeLaTeX")
 	    (setq TeX-save-query  nil )
 	    (setq TeX-show-compilation t)
 	    ))