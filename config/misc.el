;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2010-03-21 04:32:51 +800 Zhixun LIN>
;;用y/n代替yes/no
(fset 'yes-or-no-p 'y-or-n-p)
(setq outline-minor-mode-prefix (kbd "C-o"))
(defun newline-no-break () "Open and indent a new line below the
	current line." (interactive "*") (end-of-line) (newline-and-indent))
;; time stamp support
(setq time-stamp-active t)
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S +800 Zhixun LIN")
;; backup setting
					;(require 'backup-dir)
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/backups"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 3
 kept-old-versions 2
 version-control t)       ; use versioned backups
;; turn on syntax highlighting
(global-font-lock-mode t)

;; setup parentheses handling
(show-paren-mode 1)
(transient-mark-mode t)

;;tricks from emacs ninetytrick
;;auto decompress .gz .bz2 .Z files
(auto-compression-mode 1)

;; 默认进入auto-fill模式
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; 设置地理位置
;; (setq calendar-latitude 39.90)
;; (setq calendar-longitude 116.30)
;; (setq calendar-location-name "Beijing")
;;厦门的家
(setq calendar-latitude 24.50)
(setq calendar-longitude 118.12)
(setq calendar-location-name "Xiamen")


;;diary
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)
(setq diary-file "~/.emacs.d/diary")

;;假期的一些设置
(require 'cal-china-x)
(setq calendar-mark-diary-entries-flag t)
(setq calendar-mark-holidays-flag t)
(setq calendar-view-diary-initially-flag nil)
(setq calendar-week-start-day 1)
(setq holiday-christian-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays t)
(setq holiday-solar-holidays nil)
(setq calendar-holidays '((holiday-fixed 1 1 "元旦")
					;holiday-lunar 可以用holiday-chinese
				 (holiday-lunar 12 30 "春节" 0)
				 (holiday-lunar 1 1 "春节" 0)
				 (holiday-lunar 1 2 "春节" 0)
				 ;;1954-3-1 甲午年 正月廿七 子时
				 (holiday-chinese 1 27 "老妈生日" )
				 ;;1952-7-25 壬辰年 六月初四 寅时
				 (holiday-chinese 6 4 "老爸生日" )
				 ;;1978-4-7,戊午年 三月初一 午时
				 (holiday-fixed 4 7 "老哥生日")
				 ;;嫂子生日 80-1-14,己末年
				 (holiday-fixed 1 14 "嫂子生日")
				 ;;1982-3-10,壬戌年 二月十五 午时
				 (holiday-fixed 3 10 "我的生日")
				 (holiday-fixed 1 24 "ck's")
				 (holiday-solar-term "清明" "清明节")
				 (holiday-fixed 5 1 "劳动节")
				 (holiday-lunar 5 5 "端午节" 0)
				 (holiday-lunar 8 15 "中秋节" 0)
				 (holiday-fixed 10 1 "国庆节")
				 (holiday-fixed 10 2 "国庆节")
				 (holiday-fixed 10 3 "国庆节")
				 (holiday-fixed 4 1 "愚人节")
				 (holiday-fixed 5 4 "青年节")
				 (holiday-float 5 0 2 "母亲节")
				 (holiday-float 6 0 3 "父亲节")))
;;
(setq calendar-chinese-celestial-stem
["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(setq calendar-chinese-terrestrial-branch
["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"])


;; 防止页面滚动时跳动，方便上下文阅读
;(setq scroll-step 1
(setq scroll-margin 3
      scroll-conservatively 10000)
;; 设置 sentence-end 可以识别中文。
(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")


;; 光标靠近鼠标指针时，让鼠标指针自动让开
(mouse-avoidance-mode 'animate)

;;在行首 C-k 时，同时删除该行
(setq-default kill-whole-line t)
;;不要在鼠标点击的那个地方插入剪贴板内容。我不喜欢那样，经常把我的文档搞的一团糟。我觉得先用光标定位，然后鼠标中键点击要好的多。不管你的光标在文档的那个位置，或是在 minibuffer，鼠标中键一点击，X selection 的内容就被插入到那个位置。 
(setq mouse-yank-at-point t)
;;use a big kill ring
(setq kill-ring-max 200)
;;把 fill-column 设为 0. 这样的文字更好读。
(setq default-fill-column 70)

;;设置缺省目录为根目录
;(setq default-directory "~")

;; 临时记号
(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
   Use ska-jump-to-register to jump back to the stored position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))
(defun ska-jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))

(setq hippie-expand-try-functions-list
      '(try-expand-line
        try-expand-line-all-buffers
        try-expand-list
        try-expand-list-all-buffers
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name
        try-complete-file-name-partially
        try-complete-lisp-symbol
        try-compplete-lisp-symbol-partially
        try-expand-whole-kill))


;;自动在修改之后编译之
;;(add-hook 'after-save-hook
;;	  (lambda ()
;;	    (mapcar
;;	     (lambda (file)
;;	       (setq file (expand-file-name file))
;;	       (when (string= file (buffer-file-name))
;;		 (save-excursion (byte-compile-file file))))
;;             '("~/.emacs.d/init.el" "~/.gnus" "~/.emacs.d/config/.el"))))
;;;(defconst dotemacs-basic-conf-dir "~/.emacs.d/config/")
;(defconst dotemacs-ext-elisp-dir "~/.emacs.d/config/ext-elisp/")
;(defconst dotemacs-program-dir "~/.emacs.d/config/program/")
;;;;auto compile .el files after modification
(defun auto-byte-compile-el-file ()
  (let* ((filename (file-truename buffer-file-name)))
    (cond ((string= (substring filename                                       
            (- (length filename) 3)) ".el")
          (byte-compile-file filename)))))
(add-hook 'after-save-hook 'auto-byte-compile-el-file)

;; go to char
;; C-c a
(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `wy-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
		     char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))

;;ibuffer
(require 'ibuffer)

;; ido mode
(require 'ido)
(ido-mode t)				
(setq ido-ignore-buffers               ; ignore these guys
      '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido")
;;      ido-work-directory-list '("~/" "~/Desktop" "~/Documents")
      ido-save-directory-list-file "~/.emacs.d/.ido.last"
      ido-case-fold  t                 ; be case-insensitive
      ido-use-filename-at-point nil    ; don't use filename at point (annoying)
      ido-use-url-at-point nil         ;  don't use url at point (annoying)
      ido-enable-flex-matching t       ; be flexible
      ido-max-prospects 8              ; don't spam my minibuffer
      ido-confirm-unique-completion t) ; wait for RET, even with unique completion
;; iswithcb
;;{{{ iswitchb : fast switching buffers support
(require 'iswitchb)
(iswitchb-mode )
;;}}}
(defun zsh (&optional new)
  "Switch to the zsh buffer or start one if none exists."
  (interactive "P")
  (if new
      (ansi-term "/bin/zsh" "zsh")
      (if (get-buffer "*zsh*")
          (switch-to-buffer "*zsh*")
          (ansi-term "/bin/zsh" "zsh"))))
;;{{{ recentf : recent open files support
;;(require 'recentf)
;;(setq recentf-save-file "~/.emacs.d/_recentf")
;;(recentf-mode 1)
;;}}}

;;tabbar
;;(require 'tabbar)
;;(tabbar-mode)

;;epa support
;; it's default now
;(require 'epa-file)
;(epa-file-enable)

;;sdcv mode
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)

;; crazycool 的一个函数，显示 ascii 表
;;;###autoload
(defun ascii-table-show ()
  "Print the ascii table"
  (interactive)
  (with-current-buffer (switch-to-buffer "*ASCII table*")
    (setq buffer-read-only nil)
    (erase-buffer)
    (let ((i   0)
          (tmp 0))
      (insert (propertize
               "                                [ASCII table]\n\n"
               'face font-lock-comment-face))
      (while (< i 32)
        (dolist (tmp (list i (+ 32 i) (+ 64 i) (+ 96 i)))
          (insert (concat
                   (propertize (format "%3d " tmp)
                               'face font-lock-function-name-face)
                   (propertize (format "[%2x]" tmp)
                               'face font-lock-constant-face)
                   "    "
                   (propertize (format "%3s" (single-key-description tmp))
                               'face font-lock-string-face)
                   (unless (= tmp (+ 96 i))
                     (propertize " | " 'face font-lock-variable-name-face)))))
        (newline)
        (setq i (+ i 1)))
      (beginning-of-buffer))
    (toggle-read-only 1)))

;; WoMan 不打开新的 frame
(setq woman-use-own-frame nil)

;;config of 2 windows
(defun ywb-favorite-window-config (&optional percent)
  "Split window to proper portion"
  (interactive "P")
  (or percent (setq percent 30.5))
  (setq percent (/ percent 100.0))
  (let (buf)
    (if (> (length (window-list)) 1)
        (setq buf (window-buffer (next-window))))
    (delete-other-windows)
    (let ((maxwidth (window-width)))
      (split-window-horizontally (round (* maxwidth percent))))
    (if buf (save-selected-window
               (next-window)
             (pop-to-buffer buf)))))


;;; Many thanks TO ilovecpp
(defvar switch-major-mode-last-mode nil)
(make-variable-buffer-local 'switch-major-mode-last-mode)

(defun major-mode-heuristic (symbol)
  (and (fboundp symbol)
       (string-match ".*-mode$" (symbol-name symbol))))

(defun switch-major-mode (mode)
  (interactive
   (let ((fn switch-major-mode-last-mode)
         val)
     (setq val
           (completing-read
            (if fn
                (format "Switch major mode to (default %s): " fn)
              "Switch major mode to: ")
            obarray 'major-mode-heuristic t nil nil (symbol-name fn)))
     (list (intern val))))
  (let ((last-mode major-mode))
    (funcall mode)
    (setq switch-major-mode-last-mode last-mode)))
;;(global-set-key (kbd "C-c m") 'switch-major-mode)

;;thanks to ywb
;;it's a usage about abbreve minor mode
(setq ywb-dict-file "~/.emacs.d/.dict")
(defun ywb-read-dict-file ()
  "Read dictionary file"
  (interactive)
  (if (file-exists-p ywb-dict-file)
      (save-excursion
        (let ((buffer (find-file-noselect ywb-dict-file))
              (done nil)
              mode beg end)
          (set-buffer buffer)
          (goto-char (point-min))
          (re-search-forward "^\\*\\s-*\\(.*-mode\\)" nil t)
          (setq mode (buffer-substring (match-beginning 1)
                                       (match-end 1)))
          (setq beg (1+ (match-end 0)))
          (while (progn
                   (if (re-search-forward "^\\*\\s-*\\(.*-mode\\)" nil t)
                       (setq end (match-beginning 0))
                     (setq end (point-max))
                     (setq done t))
                   ;; (message "mode: %s, beg: %d, end: %d" mode beg end)
                   (with-current-buffer  (get-buffer-create (format " %s-dict" mode))
                     (erase-buffer)
                     (setq major-mode (intern mode))
                     (insert-buffer-substring buffer beg end))
                   (setq mode (match-string 1))
                   (setq beg (1+ (match-end 0)))
                   (not done)))
          (kill-buffer buffer)))
    (message "file %s is not exits!" ywb-dict-file)))
(ywb-read-dict-file)

;;emms 
(defun emms ()
  (interactive)
  (require 'emms-init))
;(global-set-key "\C-cme" 'emms)

;(require 'multi-eshell)
;(global-set-key  "\C-zc" 'multi-eshell)
;(global-set-key  "\C-zn" 'multi-eshell-switch)
;(setq multi-eshell-shell-function '(eshell))

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




;;for work with mozrepl
(defun moz-conkeror-setup ()
  (comint-send-string inferior-moz-buffer
                      "{ let ctx = {};
                         ctx.__proto__ = conkeror;
                         ctx.conkeror = conkeror;
                         ctx.window = conkeror.window_watcher.activeWindow;
                         ctx.buffer = ctx.window.buffers.current;
                         ctx.document = ctx.buffer.document;
                         repl.enter(ctx); }"))

(add-hook 'inferior-moz-hook 'moz-conkeror-setup)


(add-to-list 'auto-mode-alist '("\\.conkerorrc" . java-mode))
