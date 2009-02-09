;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2009-02-07 02:47:02 +800 Zhixun LIN>

;; packages :local emacs packages
;; config   :my config files
;(require 'site-gentoo)
;Gentoo by default stores stuff here. Emacs packages installed through the
;system are only accessible through this.
;(when (file-exists-p "/usr/share/emacs/site-lisp/site-gentoo.el")
;  (load "/usr/share/emacs/site-lisp/site-gentoo"))
;;gnus init file
;(setq gnus-init-file "~/.emacs.d/gnus.el")

(defun my-add-subdirs-to-load-path (dir) 
  (let ((default-directory (concat dir "/"))) 
    (setq load-path (cons dir load-path)) 
    (normal-top-level-add-subdirs-to-load-path)))

(my-add-subdirs-to-load-path "~/.emacs.d/site-lisp")
;;(add-to-list 'load-path "~/.emacs.d/site-lisp")
(mapc 'load (directory-files "~/.emacs.d/config" t "\.elc$"))
(put 'narrow-to-region 'disabled nil)
;;personal 
(setq user-full-name "LIN Zhixun")
(setq user-mail-address "zhixun.lin@gmail.com")

;;server
(server-start)
(setq server-raise-frame t)
;;for stumpwm usage
;;use es for EDITOR
(if window-system
      (add-hook 'server-done-hook
                (lambda () (shell-command "stumpish 'eval (stumpwm::return-es-called-win stumpwm::*es-win*)'"))))

;;utf8 settings
;; utf8 preferred
(prefer-coding-system 'utf-8)
;;for usage of version control
(setq require-final-newline t)
;;slime
(setq inferior-lisp-program "sbcl")

;;vc
(require 'git)
(add-to-list 'vc-handled-backends 'GIT)
(autoload 'git-status "git" "Entry point into git-status mode." t)
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)
(setq initial-scratch-message nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(require 'ecb)
;(require 'xcscope)
;(global-set-key [(f4)] 'speedbar-get-focus)
;;temp area of some testing code

(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line"
  (interactive "P")
  (let ((beg (line-beginning-position)) 
	(end (line-end-position arg)))
    (copy-region-as-kill beg end))
  )

(defun copy-word (&optional arg)
  "Copy words at point"
  (interactive "P")
  (let ((beg (progn (if (looking-back "[a-zA-Z0-9]" 1) (backward-word 1)) (point))) 
	(end (progn (forward-word arg) (point))))
    (copy-region-as-kill beg end))
  )


(defun copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (let ((beg (progn (backward-paragraph 1) (point))) 
	(end (progn (forward-paragraph arg) (point))))
    (copy-region-as-kill beg end))
  )


;Change cutting behaviour:
;"Many times you'll do a kill-line command with the only intention of getting
;the contents of the line into the killring. Here's an idea stolen from Slickedit,
;if you press copy or cut when no region is active you'll copy or cut the current line:"
;<http://www.zafar.se/bkz/Articles/EmacsTips>
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))



;;use w3m to browse common lisp hyperspec
;;but use firefox for normal web browsing
(setq browse-url-browser-function '(("hyperspec" . w3m-browse-url)
("weitz" . w3m-browse-url)
("." . browse-url-firefox)))
(defun toggle-browser ()
  "Toggle browser between Firefox and emacs-w3m."
  (interactive)
  (setq browse-url-browser-function 
        (if (eql browse-url-browser-function 'browse-url-firefox)
            'w3m-browse-url
          'browse-url-firefox))
  (message "%s" browse-url-browser-function))


;;;;auto compile .el files after modification
(defun auto-byte-compile-el-file ()
  (let* ((filename (file-truename buffer-file-name)))
    (cond ((string= (substring filename                                       
            (- (length filename) 3)) ".el")
          (byte-compile-file filename)))))
(add-hook 'after-save-hook 'auto-byte-compile-el-file)




;(require 'autoinsert)

