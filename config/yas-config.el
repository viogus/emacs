;;yas settings
;;(require 'yasnippet)
;;(yas/initialize)
;;load snippet,basically from yas package
(yas/load-directory "~/.emacs.d/snippets")
;;(define-key yas/minor-mode-map (kbd "C-c TAB") 'yas/list-snippets)
(defun yas/list-snippets (&optional show-all)
  "show possible yasnippets starting with current string or list all yasnippets for this mode if prefix-arg is given."
  (interactive "P")
  (let* ((possible-keys
          (or show-all
              (loop for syntax in yas/key-syntaxes
                    collect (buffer-substring-no-properties
                             (save-excursion (skip-syntax-backward syntax) (point)) (point)))))
         (candidates
          (loop for k being the hash-keys of (yas/snippet-table-hash (yas/current-snippet-table))
                using (hash-values v)
                for matched = (or show-all (loop for candidate in possible-keys
                                                 when (and (> (length candidate) 0)
                                                           (> (length k) (length candidate))
                                                           (string-equal candidate
                                                                         (substring k 0 (length candidate))))
                                                 return (substring k (length candidate))))
                when matched
                nconc (mapcar (lambda (v) (format "%-8s => %s"
                                                  (if (stringp matched) matched k)
                                                  (yas/template-name (cdr v)))) v))))
    (if candidates
        (dropdown-list candidates)
      (message "No matching snippets."))))
