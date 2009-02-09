(defun insert-line-numbers ()
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (let ((fmt (format "%%0%dd "
                         (1+ (truncate 
                              (log (count-lines (point-min) (point-max)) 
                                   10)))))
            (i 0))
        (goto-char (point-min))
        (while (< (point) (point-max))
          (setq i (1+ i))
          (insert (format fmt i))
          (forward-line))))))

(defun delete-line-numbers ()
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
        (goto-char (point-min))
        (while (< (point) (point-max))
          (if (looking-at "[0-9][0-9]* ")
            (delete-region (match-beginning 0) (match-end 0)))
          (forward-line)))))

  
(defun renumber-lines ()
    (interactive)
    (delete-line-numbers)
    (insert-line-numbers))


(defun lse-newline ()
  "Insert newline and line number incremented with the same step 
   as previously."
  (interactive)
  (newline)
  (let ((nlpt (point))
        (line (progn
                (forward-line -1)
                (beginning-of-line)
                (if (looking-at "[0-9]+")
                    (let ((curr (string-to-number (match-string 0))))
                      (forward-line -1)
                      (beginning-of-line)
                      (if (looking-at "[0-9]+")
                          (let ((prev (string-to-number (match-string 0))))
                            (+ curr (abs (- curr prev))))
                        (+ 10 curr)))
                  10))))
    (goto-char nlpt)
    (beginning-of-line)
    (insert (format "%d " line))
    (when (looking-at " +")
      (delete-region (match-beginning 0) (match-end 0)))));;lse-newline


