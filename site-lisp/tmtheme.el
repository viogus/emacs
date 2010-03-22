;;; tmtheme.el --- TextMate Themes

(require 'nxml-parse)
(require 'cl)

(defvar tmtheme-orig-list nil
  "The result of .tmtheme file parsing.")

(defvar tmtheme-transformed-list nil
  "Transformed theme data.")

(defvar tmtheme-directory "~/site-listp/themes"
  "Default look-up directory for TextMate themes.")

(defvar tmtheme-basic-lookup-alist
  '(("lineHighlight" . (highlight hl-line))
    ("selection"     . region)
    ("invisibles"    . escape-glyph)))

(defvar tmtheme-face-lookup-alist
  '(("constant"      . font-lock-constant-face)
    ("comment"       . font-lock-comment-face)
    ("function"      . font-lock-function-name-face)
    ("string"        . (font-lock-string-face font-lock-doc-face))
    ("\\(builtin\\)\\|\\(t\\.language\\)\\|\\(language.+keyword\\)"       . font-lock-builtin-face)
    ("variable"      . font-lock-variable-name-face)
    ("type"          . font-lock-type-face)
    ("preprocessor"  . font-lock-preprocessor-face)
    ("operator"      . font-lock-negation-char-face)
    ("keyword"       . font-lock-keyword-face)
    ))

(defvar tmtheme-face-record nil
  "Do NOT touch me.")

(defvar tmtheme-themes nil
  "All supported themes")

(defun tmtheme-scan (&optional dir)
  "Scan the directory, find *.tmTheme files, and define
corresponding theme commands."
  (interactive)
  (let ((path (if (stringp dir) dir tmtheme-directory))
        (theme-files nil))
    (if (not (file-directory-p path))
        (message (format "%s is not a directory or does not exist!" path))
      (setq theme-files
            (remove-if-not (lambda (file) (string-match "\\.tm[tT]heme$" file))
                           (directory-files tmtheme-directory)))
      (setq tmtheme-themes nil)
      (when theme-files
        (dolist (file theme-files)
          (tmtheme-generate-theme path file))))))

(defun tmtheme-generate-theme (path file)
  "Parse, transform the tmTheme file. If succeed, define the theme."
  (let* ((theme-name (tmtheme-gen-theme-name file))
         (pl-name    (concat "tmtheme-plist-" theme-name))
         (tm-name    (concat "tmtheme-" theme-name))
         (full-path  (concat path "/" file)))
    ;; Make sure the file exists.
    (when (and (file-directory-p path) (file-exists-p full-path))
      (if (not (tmtheme-parse-xml full-path))
          ;; XML parse error.
          (message (format "%s parse error." full-path))
        (tmtheme-transform-theme)
        (if (or (not (listp tmtheme-transformed-list))
                (not tmtheme-transformed-list))
            ;; XML parse succeeds, but transform error.
            (progn
              (if (and (stringp tmtheme-transformed-list)
                       (string-match "^error:" tmtheme-transformed-list))
                  (message (format "[tmtheme] %s transform %s."
                                   full-path tmtheme-transformed-list))
                (message (format "[tmtheme] %s transform error: unknown."
                                 full-path))))
          ;; Everything's OK.
          (set (intern pl-name) tmtheme-transformed-list)
          (fset (intern tm-name)
                (cons 'lambda `(() (interactive)
                                (tmtheme-apply ,theme-name))))
          (add-to-list 'tmtheme-themes theme-name))))))

(defun tmtheme-gen-theme-name (file)
  (let ((oname (progn (string-match "^\\(.+\\)\\.tm[tT]heme$" file)
                      (match-string 1 file))))
    (while (and (string-match "[^0-9a-zA-Z_\\-]+" oname)
                (match-beginning 0))
      (setq oname (replace-match "-" t t oname)))
    (if (string-match "-$" oname)
        (setq oname (replace-match "" t t oname)))
    oname))

(defun tmtheme-apply (name)
  (tmtheme-apply-plist
   (symbol-value (intern (concat "tmtheme-plist-" name)))))

(defun tmtheme-apply-plist (plist)
  (let ((pl (remove-if-not
             (lambda (lst) (string= "settings" (car lst)))
             plist)))
    (if (or (not (listp pl))
            (not pl))
        (message (format "[tmtheme] Don'n know how to apply this theme."))
      (setq tmtheme-face-record nil)
      (dolist (setting (car pl))
        (when (listp setting)
          (tmtheme-apply-setting setting))))))

(defun tmtheme-apply-setting (setting)
  (let ((name  (tmtheme-get-val setting "name"))
        (scope (tmtheme-get-val setting "scope"))
        (sett  (tmtheme-get-val setting "settings"))
        ;; ignore case here
        (case-fold-search t))
    (if (not name)
        ;; default, invisibles, highlight, selection
        (progn
          (tmtheme-set-attr 'default sett)
          (let ((clr    "")
                (tmname "")
                (facenm nil))
            (dolist (lue tmtheme-basic-lookup-alist)
              (setq tmname (car lue)
                    facenm (cdr lue))
              (setq clr (tmtheme-get-val sett tmname))
              (when (stringp clr)
                (tmtheme-set-face-color
                 facenm clr (not (string= "invisibles" tmname)))))))
      ;; other faces
      (catch 'done
        (dolist (lue tmtheme-face-lookup-alist)
          (let ((regex  (car lue))
                (faces  (cdr lue)))
            (when (and sett
                       (not (tmtheme-get-record regex))
                       (or (string-match-p regex name)
                           (string-match-p regex scope)))
              (add-to-list 'tmtheme-face-record regex)
              (mapc (lambda (face)
                      (tmtheme-set-attr face sett))
                    (if (listp faces) faces (list faces)))
              (throw 'done t)))))
      )))

(defun tmtheme-get-record (regex)
  (catch 'tmtheme-record-exist
    (dolist (rec tmtheme-face-record)
      (if (string= rec regex)
          (throw 'tmtheme-record-exist t)))
    nil))

(defun tmtheme-set-face-color (faces clr &optional setbg)
  (let ((color (tmtheme-color clr)))
    (if (listp faces)
        (dolist (face faces)
          (tmtheme-set-face-attrs face
                                  :background (if setbg color 'unspecified)
                                  :foreground (if setbg 'unspecified color)))
      (tmtheme-set-face-attrs faces
                              :background (if setbg color 'unspecified)
                              :foreground (if setbg 'unspecified color)))))

(defsubst tmtheme-get-val (alst key)
  (cdr (assoc key alst)))

(defsubst tmtheme-set-attr (face alst)
  (let* ((bg-clr  (tmtheme-get-val alst "background"))
         (fg-clr  (tmtheme-get-val alst "foreground"))
         (fstyle  (tmtheme-get-val alst "fontStyle"))
         (bold    (and (stringp fstyle) (string-match-p "bold" fstyle)))
         (italic  (and (stringp fstyle) (string-match-p "italic" fstyle)))
         (underln (and (stringp fstyle) (string-match-p "underline" fstyle))))
  (tmtheme-set-face-attrs face
   :background (if (stringp bg-clr) bg-clr 'unspecified)
   :foreground (if (stringp fg-clr) fg-clr 'unspecified)
   :weight     (if bold 'bold 'unspecified)
   :slant      (if italic 'italic 'normal)
   :underline  (if underln t nil))))

(defsubst tmtheme-set-face-attrs (face &rest body)
  (when (facep face)
    (apply 'set-face-attribute face nil body)))

(defun tmtheme-color (clr)
  (if (string-match "\\(^#\\sw\\{6\\}\\)" clr)
      (match-string 1 clr)
    clr))

(defun tmtheme-parse-xml (theme-file)
  "Parse the XML into a list. Thanks to nxml."
  (if (and (stringp theme-file)
           (file-exists-p theme-file))
      (condition-case nil
          (progn
            (setq tmtheme-orig-list (nxml-parse-file theme-file))
            t)
        nil)
    nil))

(defun tmtheme-transform-theme ()
  (when tmtheme-orig-list
    (setq tmtheme-transformed-list
          (catch 'tmtheme-unresolved-error
            (tmtheme-transform tmtheme-orig-list)))))

(defun tmtheme-transform (lst)
  "Transform the parsed list into something more convenient, recursively."
  (let ((head (car lst))
        (body nil))
    (cond
     ((string= head "plist")
      (tmtheme-transform (nth 3 lst)))

     ((string= head "dict")
      (set (setq body (make-symbol "tmtheme-dict")) nil)
      (let ((key nil))
        (dolist (entry (cdr lst))
          (when (and (listp entry) entry)
            (if (and (not key) (string= (car entry) "key"))
                ;; the key
                (setq key (nth 2 entry))
              ;; the value
              (add-to-list body `(,key . ,(tmtheme-transform entry)) t)
              (setq key nil)))))
      ;; for dict, return alist
      (symbol-value body))

     ((string= head "array")
      (set (setq body (make-symbol "tmtheme-array")) nil)
      (dolist (entry (cdr lst))
        (when (and (listp entry) entry)
          (add-to-list body (tmtheme-transform entry) t)))
     ;; for array, return list
      (symbol-value body))

     ((string= head "string")
      (nth 2 lst))

     (nil (throw 'tmtheme-unresolved-error (format "error: %s" head))))))

;; debug routines
(defun tmtheme-dump-all ()
  (when tmtheme-themes
    (dolist (tm tmtheme-themes)
      (tmtheme-dump tm)
      (insert "\n"))))

(defun tmtheme-dump (name)
  (flet ((tmtheme-apply-setting (setting) (insert (format "%S\n" setting))))
    (insert (format ";; %s\n" name))
    (tmtheme-apply name)))

(provide 'tmtheme)

;;; tmtheme.el ends here.
