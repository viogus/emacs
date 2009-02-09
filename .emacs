;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2008-12-05 12:18:48  Zhixun LIN>
(require 'site-gentoo)
;(setq viper-mode t)
;(require 'viper)
(global-unset-key [(control z)])
(global-set-key "\C-cw"
                     (lambda ()
                       (interactive)
                       (let ((woman-use-topic-at-point t))
                         (woman))))
(global-set-key [(meta g)] 'goto-line)
;(global-set-key [(control a)] 'speedbar)
(global-set-key (kbd "M-<SPC>") 'set-mark-command)
;;用y/n代替yes/no
(fset 'yes-or-no-p 'y-or-n-p)
(setq outline-minor-mode-prefix (kbd "C-o"))

;; time stamp support
(setq time-stamp-active t)
;(setq time-stamp-warn-inactive t)
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S  Zhixun LIN")
(global-set-key [(f5)]
                '(lambda ()
                   (interactive)
                   (insert
                    (format-time-string
                     "%Y-%m-%d %H:%M:%S")))) 

;; setup default font and init windows position
;(set-default-font "-*-Courier New-normal-r-*-*-14-*-*-*-c-*-fontset-most")
(set-frame-font "Bitstream Vera Sans Mono-12")
;(set-default-font "Courier New-12")
(set-fontset-font (frame-parameter nil 'font)
              'unicode  '("Microsoft YaHei" . "unicode-bmp"))
;;turn off toolbar and scrollbar
(tool-bar-mode -1)
(scroll-bar-mode -1)
;;set gemestry of 80x36
(set-frame-height (selected-frame) 36)
(set-frame-width (selected-frame) 80)
(set-frame-position (selected-frame) 0 0)
;;set the color theme
(setq default-frame-alist
 '(
    (foreground-color . "Wheat")
    (background-color . "black")
    (cursor-color     . "#DDDDDD")
   )
)
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



;; 默认进入auto-fill模式
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; 在标题栏显示buffer的名称
(setq frame-title-format "emacs@%b")

;; 设置地理位置
(setq calendar-latitude 39.90)
(setq calendar-longitude 116.30)
(setq calendar-location-name "Beijing")

;;diary
(setq view-diary-entries-initially t
       mark-diary-entries-in-calendar t
       number-of-diary-entries 7)
 (add-hook 'diary-display-hook 'fancy-diary-display)
 (add-hook 'today-visible-calendar-hook 'calendar-mark-today)
(setq diary-file "~/.emacs.d/diary")

;;假期的一些设置
(setq mark-diary-entries-in-calendar t)
(setq appt-issue-message nil)
(setq mark-holidays-in-calendar nil)
(setq view-calendar-holidays-initially nil)
(setq calendar-week-start-day 1)
(setq holiday-christian-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays nil)
(setq holiday-solar-holidays nil)
(setq holiday-general-holidays '((holiday-fixed 1 1 "元旦")
                         (holiday-fixed 4 1 "愚人节")
                         (holiday-fixed 5 4 "青年节")
                         (holiday-float 5 0 2 "母亲节")
                         (holiday-float 6 0 3 "父亲节")
                         (holiday-fixed 10 1 "国庆节")))

;; 防止页面滚动时跳动，方便上下文阅读
(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 10000)

;; 光标靠近鼠标指针时，让鼠标指针自动让开
(mouse-avoidance-mode 'animate)

;;在 mode-line 上显示时间
(display-time-mode 1)
(setq display-time-day-and-date t)

;;在行首 C-k 时，同时删除该行
(setq-default kill-whole-line t)

;;关闭起动时的那个“开机画面”。 
(setq inhibit-startup-message t)
;initial-scratch-message

;;显示列号。 
(setq column-number-mode t) 

(setq mouse-yank-at-point t);;不要在鼠标点击的那个地方插入剪贴板内容。我不喜欢那样，经常把我的文档搞的一团糟。我觉得先用光标定位，然后鼠标中键点击要好的多。不管你的光标在文档的那个位置，或是在 minibuffer，鼠标中键一点击，X selection 的内容就被插入到那个位置。 

(setq kill-ring-max 200)
;;用一个很大的 kill ring. 这样防止我不小心删掉重要的东西。我很努莽的，你知道 :P 

(setq default-fill-column 60)
;;把 fill-column 设为 0. 这样的文字更好读。

;;使用dired-x mode
(add-hook 'dired-load-hook
          (function (lambda ()
                      (load "dired-x"))))

(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
;;让 dired 可以递归的拷贝和删除目录。 


 (setq default-directory "~")
;;设置缺省目录为根目录


;; 临时记号
(global-set-key [(control ?\.)] 'ska-point-to-register)
(global-set-key [(control ?\,)] 'ska-jump-to-register)
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
;;hippie-expand 所使用的补全函数及使用的顺序
(global-set-key [(meta ?/)] 'hippie-expand)
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

;;(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            (setq dired-view-command-alist
                  '(("[.]\\(jpe?g\\|gif\\|png\\)\\'" . "ee %s")))))

;;自动在修改之后编译之
(add-hook 'after-save-hook
      (lambda ()
        (mapcar
         (lambda (file)
           (setq file (expand-file-name file))
           (when (string= file (buffer-file-name))
             (save-excursion (byte-compile-file file))))
             '("~/.emacs" "~/.gnus" "~/.wl"))))



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

(define-key global-map (kbd "C-c a") 'wy-go-to-char)

;;eshell
;;--------------
;;eshell alias

;;emms
;;-------------------
(setq emms-stream-bookmarks-file "~/.emacs.d/emms/emms-streams")
(setq emms-history-file "~/.emacs.d/emms/emms-history")
(setq emms-cache-file "~/.emacs.d/emms/emms-cache")

(require 'emms-setup)
(emms-standard)
(emms-default-players)
(setq emms-source-file-default-directory "~/audio/")

 ;; 播放器优先顺序
 emms-player-list '(emms-player-mplayer
                    emms-player-timidity
                    emms-player-mpg321
                    emms-player-ogg123)

;; enable emms scoring
(setq emms-score-enabled-p t)

;; Start browser with album
(setq emms-browser-default-browse-type 'info-album)

;(require 'emms-player-mpd)
;(add-to-list 'emms-player-list 'emms-player-mpd)
;(setq emms-player-mpd-server-name "localhost")
;(setq emms-player-mpd-server-port "6600")
;(setq emms-player-mpd-music-directory "~/audio/mpd")
;(add-to-list 'emms-info-functions 'emms-info-mpd)


;;use mplayer for mms 
;;default action
(setq emms-stream-default-action "play")
;;mplayer mms
(define-emms-simple-player mplayer '(file url)
  "mms://"
  "mplayer" "-nocache") 



;;ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)


;; ido mode
(require 'ido)
(ido-mode t)

;; iswithcb
;;{{{ iswitchb : fast switching buffers support
(require 'iswitchb)
(iswitchb-mode )
;;}}}


;;{{{ recentf : recent open files support
(require 'recentf)
(setq recentf-save-file "~/.emacs.d/_recentf")
(recentf-mode 1)
;;}}}

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
(require 'bbdb)
(bbdb-initialize 'gnus 'message 'sc) 
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus) 
;(require 'message-x)
;;
;;emacs-w3m
;;------------------------------
;;  (if  (=  emacs-major-version  23) 
;;  	 (require  'w3m-load) 
;;       )
;;  (setq browse-url-browser-function 'w3m-browse-url) 
;;  (autoload 'w3m-browse-url "w3m"  "Ask  a  WWW  browser  to  show  a  URL."  t) 
;; ;; ;;  optional  keyboard  short-cut 
;;  (global-set-key  "\C-xm"  'browse-url-at-point)
;; ;; ;;enable cookies
;;  (setq w3m-use-cookies t)
;;  (autoload 'browse-url-interactive-arg "browse-url")
;;use desktop to save w3m buffers
;;;   (defun desktop-buffer-w3m-misc-data ()
;;;     "Save data necessary to restore a `w3m' buffer."
;;;     (when (eq major-mode 'w3m-mode)
;;;       w3m-current-url))

;;;   (defun desktop-buffer-w3m ()
;;;     "Restore a `w3m' buffer on `desktop' load."
;;;     (when (eq 'w3m-mode desktop-buffer-major-mode)
;;;       (let ((url desktop-buffer-misc))
;;;         (when url
;;;  	 (require 'w3m)
;;;  	 (if (string-match "^file" url)
;;;  	     (w3m-find-file (substring url 7))
;;;  	   (w3m-goto-url url))
;;;  	 (current-buffer)))))

;;;   (add-to-list 'desktop-buffer-mode-handlers 'desktop-buffer-w3m)
;;;   (add-to-list 'desktop-save-buffer 'desktop-buffer-w3m-misc-data)
;;; ;  (add-to-list 'desktop-buffer-misc-functions 'desktop-buffer-w3m-misc-data)
;;;   (add-to-list 'desktop-save-buffer 'w3m-mode)
;;; ;; google suggest for search
;;;     (defun google-suggest ()
;;;      "Search `w3m-search-default-engine' with google completion canditates."
;;;      (interactive)
;;;      (w3m-search w3m-search-default-engine
;;; 		 (completing-read  "Google search: " 
;;; 				   (dynamic-completion-table
;;; 				   google-suggest-aux))))

;;;    (defun google-suggest-aux (input)
;;;      (with-temp-buffer 
;;;        (insert
;;; 	(shell-command-to-string
;;; 	 (format "w3m -dump_source %s" 
;;; 		 (shell-quote-argument 
;;; 		  (format
;;; 		   "http://www.google.com/complete/search?hl=en&js=true&qu=%s"
;;; 		   input)))))
;;;        (read
;;; 	(replace-regexp-in-string "," ""
;;; 				  (progn
;;; 				    (goto-char (point-min))
;;; 				    (re-search-forward "\(" (point-max) t 2)
;;; 				    (backward-char 1)
;;; 				    (forward-sexp)
;;; 				    (buffer-substring-no-properties
;;; 				     (1- (match-end 0)) (point)))))))


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

(global-set-key (kbd "C-c e") 'switch-to-irc)

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
  (ercp :server "irc.freenode.net" :port 7000 :full-name "Zhixun LIN"))

; (call-interactively 'erc-server-select))


;; smileys
(require 'smiley)
(add-to-list 'smiley-regexp-alist '("\\(:-?]\\)\\W" 1 "forced"))
(add-to-list 'smiley-regexp-alist '("\\s-\\(:-?/\\)\\W" 1 "wry"))
(add-to-list 'smiley-regexp-alist '("\\(:-?(\\)\\W" 1 "sad"))
(add-to-list 'smiley-regexp-alist '("\\((-?:\\)\\W" 1 "reverse-smile"))
(add-to-list 'smiley-regexp-alist '("\\(:-?D\\)\\W" 1 "grin"))
(add-to-list 'smiley-regexp-alist '("\\(:-?P\\)\\W" 1 "poke"))




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

;;tabbar
 (require 'tabbar)
 (tabbar-mode)


;;tricks from emacs ninetytrick
;;auto decompress .gz .bz2 .Z files
(auto-compression-mode 1)

;;‘C-x r j e’ to open DotEmacs, ‘C-x r j i’ to open an‘ideas’ file:
(set-register ?e '(file . "~/.emacs"))
(set-register ?i '(file . "~/org/ideas.org"))
;;Copy and paste from registers - ‘C-x r s R’ and ‘C-x r g R’ (think: register-set/
;;    register-get). 

;;
;; APROPOS URL
;;--------------------------------

;; You define an alist with regexps and the matching url to be used, for example
;; doing:

;; M-x browse-apropos-url RET /. RET

;; means: “I’m at work, take me to slashdot.org”

;; Searching the emacswiki for “python” is done like this:

;; M-x browse-apropos-url RET ewiki python RET

;; Translating “hello world” to spanish is easy:

;; M-x browse-apropos-url RET gt en es hello world RET

;; ‘gt’ is just the keyword that identifies Google translate, ‘en’ and ‘es’ are
;; google language keywords so you can use ‘fr’ or any other that google
;; understands.

;; Example apropos-url-alist regexp entires

;; Here is an example of some regexps and their respective url.

(setq apropos-url-alist
      '(("^gw?:? +\\(.*\\)" . ;; Google Web 
         "http://www.google.com/search?q=\\1")

        ("^g!:? +\\(.*\\)" . ;; Google Lucky
         "http://www.google.com/search?btnI=I%27m+Feeling+Lucky&q=\\1")
        
        ("^gl:? +\\(.*\\)" .  ;; Google Linux 
         "http://www.google.com/linux?q=\\1")
        
        ("^gi:? +\\(.*\\)" . ;; Google Images
         "http://images.google.com/images?sa=N&tab=wi&q=\\1")

        ("^gg:? +\\(.*\\)" . ;; Google Groups
         "http://groups.google.com/groups?q=\\1")

        ("^gd:? +\\(.*\\)" . ;; Google Directory
         "http://www.google.com/search?&sa=N&cat=gwd/Top&tab=gd&q=\\1")

        ("^gn:? +\\(.*\\)" . ;; Google News
         "http://news.google.com/news?sa=N&tab=dn&q=\\1")

        ("^gt:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(\\w+://.*\\)" . ;; Google Translate URL
         "http://translate.google.com/translate?langpair=\\1|\\2&u=\\3")
        
        ("^gt:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(.*\\)" . ;; Google Translate Text
         "http://translate.google.com/translate_t?langpair=\\1|\\2&text=\\3")

        ("^/\\.$" . ;; Slashdot 
         "http://www.slashdot.org")

        ("^/\\.:? +\\(.*\\)" . ;; Slashdot search
         "http://www.osdn.com/osdnsearch.pl?site=Slashdot&query=\\1")        
        
        ("^fm$" . ;; Freshmeat
         "http://www.freshmeat.net")

        ("^ewiki:? +\\(.*\\)" . ;; Emacs Wiki Search
         "http://www.emacswiki.org/cgi-bin/wiki?search=\\1")
 
        ("^ewiki$" . ;; Emacs Wiki 
         "http://www.emacswiki.org")

        ("^arda$" . ;; The Encyclopedia of Arda 
         "http://www.glyphweb.com/arda/")
         
         ))

;Of course, if no regexp is matched the input is used as the url.

;; Don't know if it's the best way , but it seemed to work. (Requires emacs >= 20)
(defun browse-apropos-url (text &optional new-window)
  (interactive (browse-url-interactive-arg "Location: "))
  (let ((text (replace-regexp-in-string 
               "^ *\\| *$" "" 
               (replace-regexp-in-string "[ \t\n]+" " " text))))
    (let ((url (assoc-default 
                text apropos-url-alist 
                '(lambda (a b) (let () (setq __braplast a) (string-match a b)))
                text)))
      (browse-url (replace-regexp-in-string __braplast url text) new-window))))

;; Now, if you are reading a spanish text and wondering what a sentence means.
;; Just mark the sentence and do the following:

;; M-x browse-apropos-url-on-region RET gt es en RET

;; This will append the region content to “gt es en “ and use your browser to let
;; google do the hard work.

(defun browse-apropos-url-on-region (min max text &optional new-window)
  (interactive "r \nsAppend region to location: \nP")
  (browse-apropos-url (concat text " " (buffer-substring min max)) new-window))

;; Google specific additions - searching and translations from emacs

;; Added : 29 September 2008 Richard Riley

;; Email : rileyrgdev AT gmail DOT com

;; Updated: 1 Oct 2008 rgr : added some stuff to treat url/word under point
;; intelligently for gnus/w3m use. If in a w3m buffer it will launch the url of
;; the underlying w3m link if cursor is on a rendered html link. In non w3m
;; buffers it will attempt to use the text at point as a url. See F4 binding
;; below.

;; Updated: 16 Oct 2008 rgr : added cleverer handling for single word
;; translations to use google dictionary. other little clean ups for prompting
;; and default under-point defaults.

;; Updated: 23 Oct 2008 rgr : function for region/word at point now in thingatpt+
;; and called region-or-word-at-point

;; Updated: 25 Oct 2008 rgr : added prefix key for the browse function in order
;; to launch external browser

;; Here is some wrapper code to facilitate access to the apropos browse using a
;; region/word at point or a prompt for google search and translation services
;; which is what I use this great function above for 99% of the time..


;(require 'browse-apropos-url)
;; (provide 'browse-url)

;; ;(require 'thingatpt+)

;; (defun rgr/browse-url (arg &optional url)
;;   "Browse the URL passed. Use a prefix arg for external default browser else use default browser which is probably W3m"
;;   (interactive "P")
;;   (setq url (or url (w3m-url-valid (w3m-anchor)) (browse-url-url-at-point) (region-or-word-at-point)))
;;   (if arg
;;       (when url (browse-url-default-browser url))
;;     (if  url (browse-url url) (call-interactively 'browse-url))
;;     ))

;; (defun rgr/google(term)
;;   "Call google search for the specified term. Do not call if string is zero length."
;;   (let ((url (if (zerop (length term)) "http://www.google.com " (concat "gw: " term))))
;;     (browse-apropos-url url)))

;; (defun rgr/google-search-prompt()
;;   (interactive)
;;   (rgr/google (read-string "Google the web for the following phrase : "
;; 			   (region-or-word-at-point))))

;; (add-to-list 'apropos-url-alist '("^googledict:? +\\(\\w+\\)|? *\\(\\w+\\) +\\(.*\\)" . "http://www.google.com/dictionary?hl=en&langpair=\\1|\\2&q=\\3"))
;; (add-to-list 'apropos-url-alist '("^ewiki2:? +\\(.*\\)" .  "http://www.google.com/cse?cx=004774160799092323420%3A6-ff2s0o6yi&q=\\1&sa=Search"))

;; (defun rgr/call-google-translate (langpair prompt)
;;   (interactive)
;;   (let* ((thing (region-or-word-at-point))
;; 	 )
;;     (setq thing (read-string (format prompt thing) nil nil thing))
;;     (browse-apropos-url  (concat (if (string-match " " thing) (quote "gt")(quote "googledict")) " " langpair " " thing))))

;; (defun rgr/browse-apropos-url (prefix prompt)
;;   (interactive)
;;   (let* ((thing (region-or-word-at-point))
;; 	 )
;;     (setq thing (read-string (format prompt thing) nil nil thing))
;;     (browse-apropos-url  (concat prefix " " thing))))

;; 					; google keys and url keys
;; (define-key mode-specific-map [?B] 'browse-apropos-url)

;; 					; use f4 for direct URLs. C-u f4 for external default browser.
;; (global-set-key (kbd "<f4>") 'rgr/browse-url)

;; (global-set-key (kbd "<f8>") (lambda()(interactive)(rgr/call-google-translate "de en "  "German to English (%s): ")))
;; (global-set-key (kbd "<f6>") (lambda()(interactive)(rgr/call-google-translate "en de "  "English to German (%s): ")))

;; (global-set-key (kbd "<f3>") 'rgr/google-search-prompt)
;; (global-set-key (kbd "C-<f5>")  (lambda()(interactive)(rgr/browse-apropos-url "ewiki2"  "Emacs Wiki Search (%s): ")))



;;eshell
;;--------
;(setq eshell-prompt-regexp "^[^#$\n]*[#$] ")
(require 'ansi-color)
(require 'eshell)
(defun eshell-handle-ansi-color ()
  (ansi-color-apply-on-region eshell-last-output-start
			      eshell-last-output-end))
(add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)

;;weblogger for blogging in blogger.com
;;-----
;; (require 'weblogger)
;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(weblogger-config-alist (quote (("default" ("user" . "zhixun.lin@gmail.com") ("server-url" . "http://www.blogger.com/api/RPC2") ("weblog" . "7616600715604178489")) ("mind" ("user" . "zhixun.lin@gmail.com") ("server-url" . "http://www.blogger.com/api/RPC2") ("weblog" . "8494537379828802516"))))))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  )
;; ;; (load-file "weblogger.el")
;; (global-set-key "\C-cbs" 'weblogger-start-entry)
;;
;; C-c b s will then switch to a new buffer where you can compose a
;; entry.
;;
;; C-x C-s    -- post-and-publish current buffer to the weblog.
;;               Calling weblogger-publish-entry with an prefix argument
;;               (i.e. C-u C-x C-s) will prompt for which weblog
;;               to use.
;;
;; C-c C-c    -- save as draft and bury the buffer.
;;
;; C-c C-n    -- post (but not publish) the current entry and
;;               load the next entry.
;;
;; C-c C-p    -- post (but not publish) the current entry and
;;               load the previous entry.
;;
;; C-c C-k    -- delete the current entry.
;;
;; M-g        -- synchronise weblogger.el's idea of the entries available
;;               with the weblog server.
;;
;; C-c C-t m  -- edit the main template.
;;
;; C-c C-t a  -- edit the Archive Index template
;;
;; C-c C-s s  -- Change the server being used.
;;
;; C-c C-s w  -- Change the weblog.
;;
;; C-c C-s u  -- Change the user (re-login).

;; icicles
;;-----------------------------

;(require 'lacarte)
;(require 'icicles)

;;; find file at point
;(require 'ffap)
;; rebind C-x C-f and others to the ffap bindings (see variable ffap-bindings)
;(ffap-bindings)
;; C-u C-x C-f finds the file at point
;(setq ffap-require-prefix t)
;; browse urls at point via w3m
;(setq ffap-url-fetcher 'w3m-browse-url)
;
