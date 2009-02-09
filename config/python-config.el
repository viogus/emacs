;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2009-01-24 21:29:25 +800 Zhixun LIN>
;;
;; python config 
;;--------------------------------------
;;(load "/usr/share/emacs/site-lisp/site-start.d/python-mode.el")
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/site-start.d/pymacs.el")

;;load pydb
;(require 'pydb)
;(autoload 'pydb "pydb" "Python Debugger mode via GUD and pydb" t)

;;load pymacs
;;not necessary for  gentoo
;(autoload 'pymacs-load "pymacs" nil t)
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")

;(require 'pycomplete)
;(autoload 'py-complete-init "py-complete")
;(add-hook 'python-mode-hook 'py-complete-init)

;;below is in  gentoo-site.d/60python-mode-gentoo.el
;(autoload 'jython-mode "python-mode" "Python editing mode." t)
;(autoload 'py-shell "python-mode" "Start an interactive Python interpreter in another window." t)
;(autoload 'doctest-mode "doctest-mode" "Editing mode for Python Doctest examples." t)
;(autoload 'py-complete "pycomplete" "Complete a symbol at point using Pymacs." t)
;(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
;(add-to-list 'auto-mode-alist '("\\.doctest$" . doctest-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
;(add-to-list 'interpreter-mode-alist '("jython" . jython-mode))

;;define some keys
;(require 'comint)
;(define-key comint-mode-map [(meta p)]
;  'comint-previous-matching-input-from-input)
;(define-key comint-mode-map [(meta n)]
;  'comint-next-matching-input-from-input)
;(define-key comint-mode-map [up]
;  'comint-next-input)
;(define-key comint-mode-map [down]
;  'comint-previous-input)

;;set ipython as the shell
;;but it's already set under gentoo
;(setq ipython-command "/usr/bin/ipython")
;(require 'ipython)




;(load-library "pylint")
;; use flymake with pylint
;(when (load "flymake" t)
;(defun flymake-pylint-init ()
;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;                       'flymake-create-temp-inplace))
;           (local-file (file-relative-name
;                        temp-file
;                        (file-name-directory buffer-file-name))))
;      (list "epylint" (list local-file))))

;(add-to-list 'flymake-allowed-file-name-masks
;               '("\\.py\\'" flymake-pylint-init)))
