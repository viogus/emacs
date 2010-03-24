;; -*- Emacs-Lisp -*-
;; Chunyu's .gnus.el is created on 2003/02/24 on db.hit.edu.cn.
;; Chunyu <dddkk@sina.com>.
;; 我的 .gnus.el 文件，专为 Gnus 5.10 的，没有在其他版本试过。
;;;;; Gnus 支持订阅多个源，一个主多个从，源可以是 news，可以是mail。
(setq gnus-select-method '(nntp "news.yaako.com")
      ;; 这些是其他的。
      gnus-secondary-select-methods
      '(;;(nnml "private") ;; 这个是本地邮件
	(nntp "news.newsfan.net") ;; 新帆
	;;(nntp "news.cnnb.net") ;; 宁波
	))
;;;;; 各种各样的变量设置 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 很多设置，其中由一些也是缺省值，留作参考；在变量名上按 C-h v RET
;;;;; 就能知道是作什么用的了。
(setq gnus-auto-select-subject 'first
      gnus-auto-select-first nil
      gnus-read-active-file nil
      gnus-read-newsrc-file nil
      gnus-save-newsrc-file nil
      gnus-save-killed-list nil
      gnus-asynchronous t
      ;; 看看 gnus 在做什么，每50封显示一下
      gnus-summary-display-while-building 50
      gnus-summary-display-arrow nil
      gnus-always-read-dribble-file t
      gnus-confirm-mail-reply-to-news t
      gnus-gcc-mark-as-read t ;; Archive的组自动标记为已读
      gnus-gcc-externalize-attachments 'all ;; 自己附件不做 Archive
      ;; 只处理最后一部分（body?）的空行，
      gnus-treat-strip-trailing-blank-lines 'last
      gnus-treat-strip-leading-blank-lines 'last
      gnus-treat-strip-multiple-blank-lines 'last
      ;; 在 X 下的时候，不要把表情符号翻译为图形
      gnus-treat-display-smileys nil)
;;;;; group parameters 还没建设好，呵呵
(setq gnus-parameters
      ;; 按我的邮件分类分别设置不同的 group parameters
      '(("list\\..*" (subscribed . t))
	("misc\\..*" (auto-expire . t))))
;;;;; 平时喜欢在 console 下，所以，需要配置一下原来不是很漂亮的 console face
(setq gnus-header-face-alist
      '(("From" nil gnus-header-from-face)
	("Subject" nil gnus-header-subject-face)
	("Newsgroups" nil gnus-header-newsgroups-face)
	;; 喜欢看看别人都用什么 news client，所以突出一下比较好！
	("User-Agent\\|X-Mailer\\|X-Newsreader" gnus-header-subject-face gnus-header-from-face)
	("" gnus-header-name-face gnus-header-content-face)))
;;;;; 我之看简体中文和英文的组，缺省为这个编码最好
(setq gnus-default-charset 'cn-gb-2312
      ;; 新帆用中文组名，需要配置这个，不过索性都是 gb2312 的
      gnus-group-name-charset-group-alist '((".*" . gb2312))
      ;; 有时候遇到 big5 的按一下 2 g 就能很容易的搞定
      gnus-summary-show-article-charset-alist '((1 . cn-gb-2312) (2 . big5))
      ;; 使用 iso-8859-1 的有一些不过就是 gb2312
      gnus-newsgroup-ignored-charsets '(unknown-8bit x-unknown iso-8859-1)
      ;; 在这些时候发送邮件，gb2312 的不用编码也能被多数人看到，他们也都用 gb2312 啊
      gnus-group-posting-charset-alist
      '(("^\\(cn\\)\\.[^,]*\\(,[ \n]*\\(cn\\)\\.[^,]*\\)*$" gb2312 (gb2312))
	("^\\(计算机\\|休闲娱乐\\).*" gb2312 (gb2312))
	(message-this-is-mail nil nil)
	(message-this-is-news nil t)))
;; Emacs 不支持 gb18030，如果 gb2312 能看到，就看到，看不到就看不到了，
;; 索性认为 gb18030 也是 gb2312 罢。
;; (define-coding-system-alias 'gb18030 'gb2312)
;; 这些都是我的地址，稍微改了改，如果你直接 copy 的，别忘了改啊。设置这
;; 个，在 mail group 里面就不用看自己的名字和地址，而是发送的地址了。
(setq gnus-ignored-from-addresses
      (regexp-opt '("dddkk@sina.com"
		    "sss@aa.lala.cn"
		    "sss@bb.lalalala.cn"
		    "chunyu@hhh.hhh")))
;; Archive 的组，按news和mail分开，再按月分。
(setq gnus-message-archive-group
      '((if (message-news-p)
	    (concat "news." (format-time-string "%Y-%m"))
	  (concat "mail." (format-time-string "%Y-%m")))))
(setq chunyu-gnus-x-face
      ;; 我的 X-Face，用别的工具把图片转为字符串的时候，需要把这两个字
      ;; 符 \ 和 " 分别转义为 \\ 和 \" 其他字符不用转义
      (concat "$,MrC{\".#Of\"+5o4f&\"Y%BEXbu::2[3u0PK.G\\]'&Irj>a"
	      "%BRPq%aA\"6f<Ywarj_/AR5<o9'<!\"9.\\ZqzkDv-OK0&Vx&D"
	      "(0'5O(jx,]LgQk/J@P<F$X\\br>y\"[Eo8lEBloB*tfsz~]\\L"
	      "l\\}&C{}ar^R\\Ic9shnEW?'8o-9%MQ03+izFFbQV&CUKVd>%V"
	      "1sog)m1$L=Z(K!I5ID8nucdF}Bb(/r>b]7*t@GP%=VS_~:&~:F"
	      "$?7,i1Wqj\\C(q)|@71421c2ynlCQ<u%\"'6|28Oww\":7N6=F"
	      "s/?mUj&_^u&\\^yrrY{O"))
;; 根据不同的，我的名字和地址是不一样的。不用我自己改，Gnus 给我自动的
;; 改过来了。
(setq gnus-posting-styles
      '((".*" ;; 缺省是这个
	 ;; 签名文件，在我的 ~/.sig 目录里面由几个签名文件
	 (signature-file "~/.sig/default")
	 ;; 发信的姓名
	 (name "Wang Chunyu")
	 ;; 显示地址
	 (address "dddkk@sina.com"))
	("^cn\\..*\\|^nntp\\+news.*" ;; 新闻组里用这个
	 (signature-file "~/.sig/cnnews")
	 (name "进化的鱼")
	 (address "dddkk@sina.com")
	 ;; 这里用到我的 X-Face 了
	 ("X-Face" 'chunyu-gnus-x-face))
	("^nnml\\+private:list\\..*" ;; 订阅的一些国外的 mailing list 用这个
	 (signature-file "~/.sig/pubmail")
	 (name "Chunyu Wang")
	 (address "sss@aa.lala.cn"))
	("^nnml\\+private:\\(classmate\\|friends\\).*" ;; 部分邮件用这个
	 (signature-file "~/.sig/mail")
	 (name "我的名字")
	 (address "chunyu@hhh.hhh"))))
;;;;; 喜欢用 Supercite，可以有多种多样的引文形式 ;;;;;;;;;;;;;;;;;;;;;
(setq sc-attrib-selection-list nil
      sc-auto-fill-region-p nil
      sc-blank-lines-after-headers 1
      sc-citation-delimiter-regexp "[>]+\\|\\(: \\)+"
      sc-cite-blank-lines-p nil
      sc-confirm-always-p nil
      sc-electric-references-p nil
      sc-fixup-whitespace-p t
      sc-nested-citation-p nil
      sc-preferred-header-style 4
      sc-use-only-preference-p nil)
(setq mail-self-blind t
      message-from-style 'angles
      message-kill-buffer-on-exit t
      message-cite-function 'sc-cite-original
      message-elide-ellipsis " [...]\n"
      message-sendmail-envelope-from nil
      ;;有时候肯能需要这个两个变量，比如没有启动 Gnus 的时候打开邮件
      message-signature t
      message-signature-file "~/.sig/default"
      message-forward-as-mime nil ;; 转发不喜欢用附件邮件，还是直接的内容比较好
      ;; 也不喜欢内容里面由太多的邮件头信息，如果有一个
      ;; message-forward-with-headers 变量，这里就不用这么麻烦了 :(
      message-forward-ignored-headers 
      (concat 
       "^X-\\|^Old-\\|^Xref:\\|^Path:\\|^[Cc]c:\\|^Lines:\\|^Sender:"
       "\\|^Thread-\\|^[GB]cc:\\|^Reply-To:\\|^Received:\\|^User-Agent:"
       "\\|^Message-ID:\\|^Precedence:\\|^References:\\|^Return-Path:"
       "\\|^Cancel-Lock:\\|^Delivered-To:\\|^Organization:\\|^content-class:"
       "\\|^Mail-Copies-To:\\|^Return-Receipt-To:\\|^NNTP-Posting-Date:"
       "\\|^NNTP-Posting-Host:\\|^Content-Transfer-Encoding:"
       "\\|^Disposition-Notification-To:\\|^In-Reply-To:\\|^List-"
       "\\|^Status:\\|^Errors-To:\\|FL-Build:"))
;;;;; 压缩保存的邮件
(setq nnml-use-compressed-files t)
;;;;; 邮件分类 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 如果由重复，删除！
(setq nnmail-treat-duplicates 'delete
      nnmail-crosspost nil ; 同一个邮件不要到多个组
      nnmail-split-methods 'nnmail-split-fancy ; 这个分类方法比较灵活
      nnmail-split-fancy-match-partial-words t ; 单词部分匹配也算成功匹配
      nnmail-split-fancy
      '(| ;; 根据 mailing list 分类
	(any "emacs-devel@gnu.org" "list.emacs-devel")
	(any "guile-user@gnu.org" "list.guile-user")
	(any "guile-sources@gnu.org" "list.guile-sources")
	(any "ding@gnus.org" "list.ding")
	(any "fetchmail-friends" "list.fetchmail")
	(any "zope@zope.org" "list.zope")
	(to "chunyu@hhh.hhh\\|dddkk@sina.com\\|sss@aa" ;; 直接给我的再分类
	    (| (from "bbs@bbs" "mail.bbs") ;; 从 bbs 给自己转发的邮件
	       ;; ... 这里省去了一些 (from ...)
	       (from "m_pupil@yahoo.com.cn" "mail.friends") ;; It's me FKtPp ;)
	       "mail.misc")) ;; 匹配不上
	"misc.misc")) ;; 这里或许是 junk 了
;; topic mode 参考这里：(info "(gnus)Group Topics") ;;;;;;;;;;;;;;;;;;
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(add-hook 'mail-citation-hook 'sc-cite-original)
(add-hook 'message-mode-hook (lambda () (setq fill-column 72) (turn-on-auto-fill)))
;; html 的邮件不看！
(eval-after-load "mm-decode"
  '(progn
     (setq mm-discouraged-alternatives '("text/html")
	   mm-automatic-display (remove "text/html" mm-automatic-display))))
;;; 这个东西可以自动帮你更新，参考这里：(info "(gnus)Daemons")
;; (gnus-demon-init)
;; (gnus-demon-add-rescan)
;; (gnus-demon-add-disconnection)
;; (gnus-demon-add-scanmail)
;;;;; 颜色设置 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(unless window-system
;;;; 突出显示自己发送的帖子和别人回应我的帖子。参考这里设置的：
  ;; http://my.gnus.org/Members/dzimmerm/HowTo%2C2002-07-25%2C1027619165012198456/view
  (require 'gnus-sum)
  (defface chunyu-gnus-own-related-posting-face nil "Postings by myself.")
  (set-face-attribute 'chunyu-gnus-own-related-posting-face nil :foreground "red" :weight 'bold)
  (add-to-list 'gnus-summary-highlight
	       '((and (> score 6500) (eq mark gnus-unread-mark)) . chunyu-gnus-own-related-posting-face))
  (eval-after-load "gnus-cite"
    '(progn
       (set-face-attribute 'gnus-cite-face-2 nil :foreground "magenta")
       (set-face-attribute 'gnus-cite-face-3 nil :foreground "yellow")
       (set-face-attribute 'gnus-cite-face-4 nil :foreground "cyan")))
  (eval-after-load "gnus-art"
    '(progn
       (set-face-attribute 'gnus-header-subject-face nil :foreground "red" :weight 'bold)))
  ;; 一些颜色上的设置，我基本只在 console 下，所以颜色只有几种。
  (set-face-attribute 'gnus-group-mail-1-empty-face nil :foreground "magenta")
  (set-face-attribute 'gnus-group-mail-1-face nil :foreground "magenta" :weight 'bold)
  (set-face-attribute 'gnus-group-mail-2-empty-face nil :foreground "cyan")
  (set-face-attribute 'gnus-group-mail-2-face nil :foreground "cyan" :weight 'bold)
  (set-face-attribute 'gnus-group-mail-3-empty-face nil :foreground "green")
  (set-face-attribute 'gnus-group-mail-3-face nil :foreground "green" :weight 'bold)
  (set-face-attribute 'gnus-group-news-1-empty-face nil :foreground "magenta")
  (set-face-attribute 'gnus-group-news-1-face nil :foreground "magenta" :weight 'bold)
  (set-face-attribute 'gnus-group-news-2-empty-face nil :foreground "cyan")
  (set-face-attribute 'gnus-group-news-2-face nil :foreground "cyan" :weight 'bold)
  (set-face-attribute 'gnus-group-news-3-empty-face nil :foreground "green")
  (set-face-attribute 'gnus-group-news-3-face nil :foreground "green" :weight 'bold))

;; Choose account label to feed msmtp -a option based on From header in Message buffer;
;; This function must be added to message-send-mail-hook for on-the-fly change of From address
;; before sending message since message-send-mail-hook is processed right before sending message.
(defun cg-feed-msmtp ()
  (if (message-mail-p)
      (save-excursion
	(let* ((from
		(save-restriction
		  (message-narrow-to-headers)
		  (message-fetch-field “from”)))
	       (account
		(cond
		 ;; I use email address as account label in ~/.msmtprc
		 ((string-match “myemail1@server1.com” from)“myemail1@server1.com”)
		 ;; Add more string-match lines for your email accounts
		 ((string-match “myemail2@server2.com” from)“myemail2@server2.com”))))
	  (setq message-sendmail-extra-arguments (list “-a” account))))))

;(setq message-sendmail-envelope-from ‘header)
;(add-hook ‘message-send-mail-hook ‘cg-feed-msmtp)
