;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2008-12-26 23:22:37  Zhixun LIN>
;;
;; muse settings

;;; 加载 muse 并做适当初始化
;; muse 所在的目录

(require 'muse-mode)
(require 'muse-html)
(require 'muse-project)

;; 启动就把 C-c C-f 绑定到 muse-project-find-file
 (global-set-key (kbd "C-c C-f")
 		(lambda ()
 		  (interactive)
 		  (let* ((project (muse-project "wiki"))
 			 (default (muse-get-keyword :default (cadr project))))
 		    (muse-project-find-file
 		     (car (muse-read-project-file
 			   project (if default
 				       (format "Find page: (default: %s) "
 					       default)
 				       "Find page: ")
 			   default))
 		     project))))

;; muse 工程设置
(setq muse-project-alist
      `(
	("wiki" ("~/workspace/writing/wiki/src"
		 :default "index")
		(:base "kid-html"
		       :path "~/workspace/writing/wiki/publish"))))

;; muse-mode 的设置
(add-hook 'muse-mode-hook
	  '(lambda ()
	    ;; 打开 auto-fill 功能
	    (auto-fill-mode t)
	    (footnote-mode)
	    (setq outline-regexp "\\*+ ")
	    (outline-minor-mode)
	    (hide-body)))

(define-key muse-mode-map (kbd "C-c C-b") 'muse-browse-result)
;; 引进 org-mode 的一些舒服的键绑定
(require 'org)
(define-key muse-mode-map (kbd "<tab>") 'org-cycle)
(define-key muse-mode-map (kbd "<S-iso-lefttab>") 'org-shifttab)

;; muse-colors 设置
(setq muse-colors-autogen-headings 'outline)
(setq muse-colors-evaluate-lisp-tags nil)
(setq muse-colors-inline-images nil)
(custom-set-faces
 '(muse-link ((((class color) (background light)) (:foreground "Purple" :underline t))
	      (((class color) (background dark)) (:foreground "Cyan" :underline t))
	      (t (:underline t))))
 '(muse-bad-link ((t (:foreground "red" :underline t)))))


;; 设置发布的 html 页面的字符集
(setq muse-html-charset-default "utf-8")
;; 设置源文件的字符集
(setq muse-html-encoding-default 'utf-8)

;;; 定义我自己的发布格式 kid-html
(muse-derive-style "kid-html" "html"
		   :strings 'kid-muse-markup-strings
		   :header 'kid-muse-html-header
		   :footer 'kid-muse-html-footer
		   :functions 'kid-muse-html-markup-functions
		   :after 'kid-muse-html-insert-contents
		   :style-sheet 'kid-muse-html-style-sheet)

(setq muse-html-table-attributes
      " class=\"muse-table\"")

(defconst kid-muse-markup-strings
  '((fn-sep             .       "<h2>Footnote</h2>\n")))

(defconst kid-muse-html-header
  "~/workspace/writing/wiki/src/template/header.html")
(defconst kid-muse-html-footer
  "<!-- Page published by Emacs Muse ends here -->
  </div>
  </div>
  </body>
</html>\n"
  "Footer used for publishing kid-HTML files.")
(defconst kid-muse-html-style-sheet
  "<LINK REL=StyleSheet HREF=\"css/style.css\" TYPE=\"text/css\">"
  "Style-sheet used for publishing kid-HTML files")

(require 'cl)
(defun kid-muse-html-make-header (header max-len)
  "Make sure the HEADER is not longer than MAX-LEN"
  (let ((len (length header)))
    (if (> len max-len)
	(concat (substring header 0 (- max-len 3)) "...")
	header)))

(defun kid-muse-html-insert-contents ()
  (let ((max-depth 6)
        (index 1)
        base contents l)
    (save-excursion
      (goto-char (point-min))
      (catch 'done
        (while (re-search-forward "^<h\\([0-9]+\\)>\\(.+?\\)</h\\1>" nil t)
          (unless (get-text-property (point) 'read-only)
            (setq l (1- (string-to-number (match-string 1))))
            (if (null base)
                (setq base l)
              (if (< l base)
                  (throw 'done t)))
            (when (<= l max-depth)
              (setq contents (cons (cons l (muse-match-string-no-properties 2))
                                   contents))
              (goto-char (match-beginning 2))
              (muse-html-insert-anchor (concat "sec" (int-to-string index)))
              (setq index (1+ index)))))))
    (setq index 1 contents (nreverse contents))
    (goto-char (point-min))
    (search-forward "<!--contents goes here-->" nil t)
    (let ((depth 1) (sub-open 0) (p (point)))
      (when contents
	(muse-insert-markup "<div class=\"contents\"><h2>Contents</h2>\n<dl>\n")
	(while contents
	  (muse-insert-markup "<dt>\n"
			      "<a href=\"#sec" (int-to-string index) "\">"
			      (muse-html-strip-links (cdar contents))
			      "</a>\n"
			      "</dt>\n")
	  (setq index (1+ index)
		depth (caar contents)
		contents (cdr contents))
	  (when contents
	    (cond
	      ((< (caar contents) depth)
	       (let ((idx (caar contents)))
		 (while (< idx depth)
		   (muse-insert-markup "</dl>\n</dd>\n")
		   (setq sub-open (1- sub-open)
			 idx (1+ idx)))))
	      ((> (caar contents) depth) ; can't jump more than one ahead
	       (muse-insert-markup "<dd>\n<dl>\n")
	       (setq sub-open (1+ sub-open))))))
	(while (> sub-open 0)
	  (muse-insert-markup "</dl>\n</dd>\n")
	  (setq sub-open (1- sub-open)))
	(muse-insert-markup "</dl>\n</div>\n"))
	(muse-publish-mark-read-only p (point)))))

(defvar kid-muse-html-markup-functions
  '((anchor . kid-muse-html-markup-anchor)))
(defun kid-muse-html-markup-anchor ()
  "insert a simple anchor"
  (unless (get-text-property (match-end 1) 'muse-link)
    (let ((anchor (match-string 2)))
      (muse-insert-markup "<a name=\"" anchor "\" id=\"" anchor "\"></a>")
      (insert "\n\n"))
    (match-string 1)))

;;; 在发布之后拷贝附近到发布目录，方法比较笨，遍历需要拷贝的目录，对于
;;; 每个文件，如果目标文件不存在或者是比源文件要旧，就拷贝过去覆盖掉它。

(defvar kid-muse-html-attachment-directories
  '(("~/workspace/writing/wiki/src/lisp" . "~/workspace/writing/wiki/publish/lisp")
    ("~/workspace/writing/wiki/src/image" . "~/workspace/writing/wiki/publish/image")
    ("~/workspace/writing/wiki/src/attachment" . "~/workspace/writing/wiki/publish/attachment")
    ("~/workspace/writing/wiki/src/package" . "~/workspace/writing/wiki/publish/package"))
  "Directories in which attachement needs to be copied.
Each entry is of the form (SRC-DIR . DEST-DIR) where each file in
SRC-DIR is copied into DEST-DIR.")

(defun kid-muse-html-copy-attachements ()
  (mapc #'(lambda (entry)
	    (let ((src (car entry))
		  (dest (cdr entry)))
	      (mapc #'(lambda (file)
			(let ((src-file file)
			      (dest-file 
			       (concat dest "/" (file-name-nondirectory file))))
			  (if (file-newer-than-file-p
			       src-file
			       dest-file)
			      (copy-file src-file dest-file t))))
		    ;we must exclude `.' and `..'
		    (directory-files src t "^[^.]")))) 
	kid-muse-html-attachment-directories))
(add-hook 'muse-after-project-publish-hook
	  #'(lambda (proj)
	      (if (string= (car proj) "wiki")
		  (kid-muse-html-copy-attachements))))
