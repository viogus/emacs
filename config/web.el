;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2009-01-10 12:10:37 +800 Zhixun LIN>
;;
;;emacs-w3m
;;------------------------------
(if  (=  emacs-major-version  23) 
    (require  'w3m-load) 
  )
(setq browse-url-browser-function 'w3m-browse-url) 
(autoload 'w3m-browse-url "w3m"  "Ask  a  WWW  browser  to  show  a  URL."  t) 
;; ;; ;;  optional  keyboard  short-cut 
;; ;; ;;enable cookies
(setq w3m-use-cookies t)
;;my favourite session
(setq w3m-session-file "~/.emacs.d/w3m-session")
(setq w3m-session-save-always t)
(setq w3m-session-load-always t)
(setq w3m-session-show-titles t)
(setq w3m-session-duplicate-tabs 'ask) ;  'never, 'always, 'ask
;;define my own engine
(require 'w3m-search)
(setq w3m-search-default-engine "google")

(add-to-list 'w3m-search-engine-alist
	     '("acronym" "http://www.acronymfinder.com/af-query.asp?acronym=%s&string=exact"))
(add-to-list 'w3m-search-engine-alist
	     '("wikipedia-en" "http://en.wikipedia.org/wiki/Special:Search?search=%s"))

;; Make the previous search engine the default for the next
;; search.

(defadvice w3m-search (after change-default activate)
  (let ((engine (nth 1 minibuffer-history)))
    (when (assoc engine w3m-search-engine-alist)
      (setq w3m-search-default-engine engine))))
;;delete unwanted engine
(let ((unwanted (regexp-opt '("altavista"
			      "eiei"
			      "eiwa"
			      "iij-archie"
			      "rpmfind"
			      "yahoo"
			      "debian"
			      "technorati"
			      "All"
			      "alc"
			      "-ja"
			      "-jp"))))
  (mapcar (lambda (elt)
	    (when (or (string-match unwanted (car elt))
		      (eq 'euc-japan (nth 2 elt)))
	      (setq w3m-search-engine-alist (delete elt w3m-search-engine-alist))))
	  w3m-search-engine-alist))
;;copy from wiki~~~
;;
(defvar piyo-w3m--query-history nil
  "The query history isn't saved seperately!")
(defun piyo-w3m-search (line)
  "Modeled on `w3m-search', but if the first word is a search engine as defined in `w3m-search-default-engine',
 then use that engine instead."
  (interactive (piyo-w3m--read-query-smart))
  (let* ((defeng w3m-search-default-engine)
         (srceng (mapcar 'car w3m-search-engine-alist))
         (sepr " ")
         (brok (split-string line sepr))
         (possiblesea (pop brok)))
    (apply 'w3m-search 
           (if (member possiblesea srceng)
               (list possiblesea (join-string brok " "))
             (list defeng (join-string (push possiblesea brok) " "))))))

(defun join-string (lst &optional seperator)
  "The reverse of `split-string'"
  (interactive)
  (mapconcat 'identity lst seperator))

(defun piyo-w3m--read-query-dumb ()
  "For reference. Not reference by running code."
  (let ((defeng w3m-search-default-engine))
    (list (w3m-search-read-query
	   (format "%s search: " defeng)
	   (format "%s search (default %%s): " defeng)
	   'piyo-w3m--query-history))))

(defun piyo-w3m--read-query-smart ()
  "Use `completing-read' to find the first matching search engine. But allow space input."
  (let ((defeng w3m-search-default-engine)
        (minibuffer-local-completion-map (copy-sequence minibuffer-local-completion-map)))
    (setcdr (assoc ?\s ; change space character
                   minibuffer-local-completion-map) 'self-insert-command)
    (let ((completion-ignore-case t))
      (list (completing-read (format "%s search: " defeng)
                             w3m-search-engine-alist nil nil nil 'piyo-w3m--query-history)))))


;;add some alist for fun
(add-to-list 'w3m-uri-replace-alist
	     '("\\`ac:" w3m-search-uri-replace "acronym"))
(add-to-list 'w3m-uri-replace-alist
	     '("\\`we:" w3m-search-uri-replace "wikipedia-en"))

(setq w3m-key-binding 'info)

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
;;e-blog for blogger.com
(require 'e-blog)
(global-set-key "\C-cb" 'e-blog-new-post)
