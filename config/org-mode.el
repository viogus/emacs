;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2008-12-05 22:20:06  Zhixun LIN>
;;
;; org-mode
;;---------------------------------------------------
(setq org-log-done t)
 (define-key global-map "\C-cl" 'org-store-link)
 (define-key global-map "\C-ca" 'org-agenda)
(setq org-agenda-files (list "~/org/work.org"
                              "~/org/school.org" 
			      "~/org/ideas.org"
                              "~/org/home.org"))