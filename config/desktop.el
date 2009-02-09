;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2008-12-25 17:10:33  Zhixun LIN>
;; desktop support
(require 'desktop)
(setq desktop-base-file-name ".emacs_desktop")
(setq desktop-base-lock-name ".emacs_desktop.lock")
;(setq desktop-path '("." "~/.emacs.d/"))
;(desktop-save-mode)
;not open
(setq desktop-buffers-not-to-save
      (concat "\\(" "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
	      "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb" 
	      "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
;;copy from emacswiki for single file
(setq *foo-desktop-dir* (expand-file-name "~/.emacs.d/desktop"))
(setq desktop-dir *foo-desktop-dir*)
(setq desktop-path (list *foo-desktop-dir*))
(desktop-save-mode 1) ;; Switch on desktop.el
(setq *foo-desktop-file* (concat  desktop-dir
				  (concat    "/" 
					     desktop-base-file-name)))
(setq *foo-desktop-lock* (concat desktop-dir
				 (concat    "/" 
					    desktop-base-lock-name)))
(defun desktop-in-use-p ()
  (and (file-exists-p *foo-desktop-file*)
       (file-exists-p *foo-desktop-lock*)))
(defun autosave-desktop ()
  (if (desktop-in-use-p)
      (desktop-save-in-desktop-dir)))
;; Can be switched off with (cancel-timer *foo-desktop-saver-timer*)
(add-hook 'after-init-hook
	  (lambda ()
	    (setq *foo-desktop-saver-timer* 
		  (run-with-timer 5 300 'autosave-desktop))))




