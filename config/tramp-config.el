;;Revert buffer with tramp sudo without losing changes already made
(require 'tramp)
(defun xwl-revert-buffer-with-sudo ()
  "Revert buffer using tramp sudo.
   This will also reserve changes already made by a non-root user."
  (interactive)
  (let ((f (buffer-file-name)))
    (when f
      (let ((content (when (buffer-modified-p)
		       (widen)
		       (buffer-string))))
	(if (file-writable-p f)
	    (revert-buffer)
	  (kill-buffer (current-buffer))
	  (if (file-remote-p f)
	      (find-file
	       (replace-regexp-in-string "^\\/[^:]+:" "/sudo:" f))
	    (find-file (concat "/sudo::" f)))
	  (when content
	    (let ((buffer-read-only nil))
	      (erase-buffer)
	      (insert content))))))))
(defun find-alternative-file-with-sudo ()
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
 	     buffer-file-name))))
(global-set-key (kbd "C-x C-r") 'find-alternative-file-with-sudo)
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq tramp-backup-directory-alist backup-directory-alist)

(defun th-rename-tramp-buffer ()
  (when (file-remote-p (buffer-file-name))
    (rename-buffer
     (format "%s:%s"
	     (file-remote-p (buffer-file-name) 'method)
	     (buffer-name)))))

(add-hook 'find-file-hook
	  'th-rename-tramp-buffer)

(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it's read-only."
  (if (and (not (file-writable-p (ad-get-arg 0)))
	   (y-or-n-p (concat "File "
			     (ad-get-arg 0)
			     " is read-only.  Open it as root? ")))
      (th-find-file-sudo (ad-get-arg 0))
    ad-do-it))

(defun th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file))))

(defadvice find-file (around my-find-file activate)
  "Open FILENAME using tramp's sudo method if it’s read-only and not owned by current user."
   (let* ((my-filename (ad-get-arg 0))
	  (file-owner-uid (nth 2 (file-attributes my-filename))))
     (if (not (file-writable-p my-filename))
	 (if (and (not (= file-owner-uid (user-uid)))
		  (y-or-n-p (concat "File " my-filename " is read-only. Open it as root? ")))
	     (progn
	       (ad-set-arg 0 (concat "/sudo::" my-filename))
	       ad-do-it
	       (rename-buffer
		(format "%s:%s"
			 (file-remote-p (buffer-file-name) 'method)
			 (buffer-name))))
	   (if (and (= file-owner-uid (user-uid))
		    (y-or-n-p (concat "File " my-filename " is read-only. Make buffer writable? ")))
	       (progn
		 ad-do-it
		 (toggle-read-only -1))))
       ad-do-it)))
(defun wl-sudo-find-file (file dir)
  (find-file (concat "/sudo:localhost:" (expand-file-name file dir))))
