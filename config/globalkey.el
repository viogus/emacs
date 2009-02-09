;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2009-01-21 22:35:37 +800 Zhixun LIN>

;;; UNSET keys
;;;-------------------------------------
;;use C-z for gnu screen 
(global-unset-key [(control z)])

;;C-z
(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)

(global-set-key (kbd "C-c $") 'toggle-truncate-lines)

;;; GLOBAL keys
;;;----------------------------------------
(global-set-key [(f5)]
                '(lambda ()
                   (interactive)
                   (insert
                    (format-time-string
                     "%Y-%m-%d %H:%M:%S")))) 
(global-set-key "\C-cw"
                     (lambda ()
                       (interactive)
                       (let ((woman-use-topic-at-point t))
                         (woman))))
;; 交换这两个按键。因为大多数情况下，回车后是要缩进的。
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)

;;dev-studio-beginning-of-line
;;borrowed from the idea of borland dev studio's editor behaviour
;;
(global-set-key "\C-a" 'dev-studio-beginning-of-line)

;;ffap is useful
;;
(global-set-key (kbd "C-c j") 'ffap)   
;; 王垠主页上的一个命令。很好用。类似 vim 的相同命令。
(global-set-key "%" 'his-match-paren)
;; 跳到匹配的括号处
;;;###autoload
(defun his-match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char))))
    (cond ((string-match "[[{(<]" next-char) (forward-sexp 1))
          ((string-match "[\]})>]" prev-char) (backward-sexp 1))
          (t (self-insert-command (or arg 1))))))


;;m-g m-g goto-line
;;m-g g goto-percent-line
(global-set-key (kbd "M-g g") 'ywb-goto-line)
;;;###autoload
(defun ywb-goto-line (percent)
  (interactive (list (or current-prefix-arg
                         (string-to-number
                          (read-from-minibuffer "Goto percent: ")))))
  (let* ((total (count-lines (point-min) (point-max)))
         (num (round (* (/ total 100.0) percent))))
    (goto-line num)))


;(global-set-key [(control a)] 'speedbar)
;; set mark
(global-set-key (kbd "M-<SPC>") 'set-mark-command)
;; tempt register
(global-set-key [(control ?\.)] 'ska-point-to-register)
(global-set-key [(control ?\,)] 'ska-jump-to-register)

;;hippie-expand 所使用的补全函数及使用的顺序
(global-set-key [(meta ?/)] 'hippie-expand)


;;goto char 

;(define-key global-map (kbd "C-c a") 'wy-go-to-char)
;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
;;
; (global-set-key  "\C-xm"  'browse-url-at-point)
;; erc keybinding
(global-set-key (kbd "C-c e") 'switch-to-irc)

;;‘C-x r j e’ to open DotEmacs, ‘C-x r j i’ to open an‘ideas’ file:
;(set-register ?e '(file . "~/.emacs"))
;(set-register ?s '(file . "~/.sawfishrc"))
;(set-register ?i '(file . "~/org/ideas.org"))
;; alter key binding for M-x
;(global-set-key “\C-x\C-m” ‘execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)

;;use c-w for backspace a word,& c-x c-k for former "c-w"
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-xw" 'kill-region)
;;(global-set-key "\C-c\C-k" 'kill-region); just for a backup of c-x c-k

;;
;;emms
;(global-set-key (kbd "H-x") 'emms-playlist-mode-go)
