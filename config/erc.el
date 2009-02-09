;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2009-01-08 13:42:58 +800 Zhixun LIN>
;;
;; ERC
;;----------------------------

;; fires up a new frame and opens your servers in there. You will need
;; to modify it to suit your needs.
(setq erc-server-coding-system 
      (quote
       (utf-8 . utf-8)))
;; passwords
(setq erc-prompt-for-nickserv-password nil)
;;set default server &nick
(setq erc-server "irc.freenode.net" 
      erc-port 7000
      erc-nick "viogus"
      erc-user-full-name "Zhixun LIN"
      ;erc-email-userid "zhixun.lin@gmail.com" ; for when ident is not activated
      erc-prompt-for-password nil) ; OPN doesn't require passwords
;; auto identify nickname
(add-hook 'erc-after-connect '(lambda (SERVER NICK)
               (erc-message "PRIVMSG" "NickServ identify password")))
;; channels
(setq erc-autojoin-channels-alist
       '(("freenode.net" "#emacs" "#gentoo-cn" )))

;; new buffer with private messages
(setq erc-auto-query 'buffer)
;; hilight my interest
;(require 'erc-match)
;;track channels
(erc-track-mode t) 
;;timestamp
(erc-timestamp-mode t)
(setq erc-timestamp-format "[%R-%m/%d]")

(erc-button-mode nil) ;slow
(setq erc-user-full-name "Zhixun LIN")
(defun erc-global-get-channel-buffer-list ()
  "Return a list of the ERC-channel-buffers"
  (erc-buffer-filter '(lambda() (if (string-match "^[^#].*:\\([0-9]*\\|ircd\\)$" (buffer-name (current-buffer))) nil t)) nil))

(defun switch-to-irc ()
  "Switch to an IRC buffer, or run `erc-select'.
When called repeatedly, cycle through the buffers."
  (interactive)
;  (let ((buffers (and (fboundp 'erc-buffer-list)
;		      (erc-buffer-list))))
 (let ((buffers (erc-global-get-channel-buffer-list)))
    (when (eq (current-buffer) (car buffers))
      (bury-buffer)
      (setq buffers (cdr buffers)))
    (if buffers
	(switch-to-buffer (car buffers))
      ;(erc "localhost" 6667 erc-nick erc-user-full-name t)
      ;; (erc "irc.phasenet.co.uk" erc-port erc-nick erc-user-full-name t)
      ;; (erc "irc.slashnet.org" erc-port erc-nick erc-user-full-name t)
;; (call-interactively 'erc-select))));交互式选择
      (erc :server "irc.freenode.net" :port erc-port :nick erc-nick :full-name erc-user-full-name ))))



;;switch to buff
(defun erc-switch-to-buffer ()
  "read events(chars), and switch to appropriate erc buffer"
  (interactive)
  (let ((buffers (erc-channel-list nil))
	buffer
	(index))
    ;;  lookup-key 
    (while (let ((char (char-to-string (read-event "channel #: ")))
		 )
	     (setq buffer
		   (cond ((string-match "[a-z]" char)
			  ;; letters -> ??
			  (aget '(("e" . "#emacs")
				  ("s" . "#scheme")
				  ("g" . "#gentoo")
				  ("p" . "#postgresql")
				  ("x" . "#xfree86-devel")
				  ("c" . "#scsh")
				  ("f" . "#sawfish")
				  ("z" . "#zsh")
				  )
				char 't))
			 ((string-match "[0-9]" char)
			  (nth (string-to-number char) buffers)))))
      (switch-to-buffer buffer))))

(define-key erc-mode-map [(meta ?g)] 'erc-switch-to-buffer)


;; Function to aid on starting erc
(defun irc ()
  "Start to waste time on IRC with ERC."
  (interactive)
  (select-frame (make-frame '((name . "Emacs IRC")
 			      (minibuffer . t))))
  (erc :server "irc.freenode.net" :port 7000 :full-name "Zhixun LIN"))

; (call-interactively 'erc-server-select))


;; smileys
(require 'smiley)
(add-to-list 'smiley-regexp-alist '("\\(:-?]\\)\\W" 1 "forced"))
(add-to-list 'smiley-regexp-alist '("\\s-\\(:-?/\\)\\W" 1 "wry"))
(add-to-list 'smiley-regexp-alist '("\\(:-?(\\)\\W" 1 "sad"))
(add-to-list 'smiley-regexp-alist '("\\((-?:\\)\\W" 1 "reverse-smile"))
(add-to-list 'smiley-regexp-alist '("\\(:-?D\\)\\W" 1 "grin"))
(add-to-list 'smiley-regexp-alist '("\\(:-?P\\)\\W" 1 "poke"))


