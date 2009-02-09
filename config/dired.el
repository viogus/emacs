;;; dired.el --- for dir settings

;; Copyright (C) 2008  LIN Zhixun

;; Author: LIN Zhixun <zhixun.lin@gmail.com>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

;;使用dired-x mode 
(require 'dired-x nil t)
(when (featurep 'dired-x)
  (add-hook 'dired-load-hook
            (function (lambda ()
                        (load "dired-x")
                        ;; Set global variables here.  For example:
                        ;; (setq dired-guess-shell-gnutar "gtar")
			(setq dired-view-command-alist
			      '(("[.]pdf\\'" . "xpdf %s")
				("[.]avi\\'" . "mplayer %s")
				("[.]\\(jpe?g\\|gif\\|png\\)\\'" . "ee %s")))
                        )))
  (add-hook 'dired-mode-hook
            (function (lambda ()
                        ;; Set buffer-local variables here.  For example:
                        (setq dired-omit-mode t)
                        )))

  (setq dired-omit-extensions
        '(
          ".svn/" "CVS/" ".o" "~" ".bin" ".bak" ".obj" ".map" ".ico"
          ".pif" ".lnk" ".a" ".ln" ".blg" ".bbl" ".dll" ".drv" ".vxd"
          ".386" ".elc" ".lof" ".glo" ".idx" ".lot" ".fmt" ".tfm"
          ".class" ".lib" ".mem" ".x86f" ".sparcf" ".fasl"
          ".ufsl" ".fsl" ".dxl" ".pfsl" ".dfsl" ".lo" ".la" ".gmo"
          ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr"
          ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo"
          ".idx" ".lof" ".lot" ".glo" ".blg" ".bbl" ".cps" ".fn"
          ".fns" ".ky" ".kys" ".pg" ".pgs" ".tp" ".tps" ".vr" ".vrs"
          ".pdb" ".ilk"))

  (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\.\\|^~")
  (add-to-list 'dired-guess-shell-alist-default '("\\.dvi$" "dvipdfmx"))
  (add-to-list 'dired-guess-shell-alist-default '("\\.pl$" "perltidy"))
  )
;;让 dired 可以递归的拷贝和删除目录。 
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)


;;;;;;;;;;;;;;;;;;;; wdired stuff ;;;;;;;;;;;;;;;;;;;;
;; Apparently, lets you press C-x d to go to dired.
;; Then, press r to "edit" the directory.
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(autoload 'wdired-change-to-wdired-mode "wdired")
(add-hook 'dired-load-hook
       '(lambda ()
       (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
       (define-key dired-mode-map
       [menu-bar immediate wdired-change-to-wdired-mode]
       '("Edit File Names" . wdired-change-to-wdired-mode))))



(defun ywb-dired-filter-regexp (regexp &optional arg)
  (interactive
   (list (dired-read-regexp
          (concat (if current-prefix-arg "Exclude" "Exclude not")
                  " match (regexp): "))
         current-prefix-arg))
  (dired-mark-files-regexp regexp)
  (or arg (dired-toggle-marks))
  (dired-do-kill-lines))

(defun ywb-dired-filter-extension (extension &optional arg)
  (interactive
   (list (read-from-minibuffer
          (concat "Exclude extension is "
                  (if current-prefix-arg "" "not") ": "))
         current-prefix-arg))
  (ywb-dired-filter-regexp (concat "\\." extension "\\'") arg))
(define-key dired-mode-map "/r" 'ywb-dired-filter-regexp)
(define-key dired-mode-map "/." 'ywb-dired-filter-extension)
;; dired-mode 下一些自定义的命令
;; ywb-dired-compress-dir 用于压缩文件夹和解压缩文件
;; ywb-dired-w3m-visit 用 w3m 打开当前的文件
;; ywb-dired-jump-to-file 类似于 ibuffer 的 j 命令，快速跳到一个文件
;; ywb-dired-count-dir-size 计算当前文件夹的大小
;; ywb-dired-copy-fullname-as-kill 类似于 w，但是得到的是文件的命名
;; ywb-dired-quickview 类似于 TC 的相同按键的命令，可以用同一个 buffer
;;   打开文件。用于快速浏览目录下文件内容，但是不会开多个 buffer
(defun ywb-dired-w3m-visit ()
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (w3m-goto-url
     (if (string-match "^[a-zA-Z]:" file)
         (ywb-convert-cygwin-path file)
       (concat "file://" file)))))
;; 这个命令在 windows 下还比较常用。我比较喜欢 TC 的类似命令。这样在一
;; 些文件选择对话框时可以直接粘贴文件的路径。按前面的设置，直接按 W 得
;; 到文件全名。在 Windows 下按 C-1 W 得到 Windows 的文件路径，C-2 W
;; 得到 Cygwin 的路径，C-3 W 得到 Windows 目录的路径。
;;;###autoload
(defun ywb-dired-copy-fullname-as-kill (&optional arg)
  "In dired mode, use key W to get the full name of the file"
  (interactive "P")
  (let (file)
    (setq file (dired-get-filename nil t))
    (or (not arg)
        (cond ((= arg 1)
               (setq file (convert-standard-filename file)))
              ((= arg 2)
               (setq file (ywb-convert-to-cygwin-path file)))
              ((= arg 3)
               (setq file (convert-standard-filename (file-name-directory file))))))
    (if (eq last-command 'kill-region)
        (kill-append file nil)
      (kill-new file))
    (message "%s" file)))
;; 类似 TC 的一个命令，可以使用同一个 buffer 浏览多个文件，每次打开新文
;; 件就把前一个 buffer 关了。
(defvar ywb-dired-quickview-buffer nil)
(defun ywb-dired-quickview ()
  (interactive)
  (if (buffer-live-p ywb-dired-quickview-buffer)
      (kill-buffer ywb-dired-quickview-buffer))
  (setq ywb-dired-quickview-buffer
        (find-file-noselect (dired-get-file-for-visit)))
  (display-buffer ywb-dired-quickview-buffer))

;; 用 tar 压缩 mark 的文件或者目录。在压缩文件上用这个命令则解压缩文件。
(defun ywb-dired-compress-dir ()
  (interactive)
  (let ((files (dired-get-marked-files t)))
    (if (and (null (cdr files))
             (string-match "\\.\\(tgz\\|tar\\.gz\\)" (car files)))
        (shell-command (concat "tar -xvf " (car files)))
      (let ((cfile (concat (file-name-nondirectory
                            (if (null (cdr files))
                                (car files)
                              (directory-file-name default-directory))) ".tgz")))
        (setq cfile
              (read-from-minibuffer "Compress file name: " cfile))
        (shell-command (concat "tar -zcvf " cfile " " (mapconcat 'identity files " ")))))
    (revert-buffer)))

(add-hook 'dired-mode-hook (lambda ()
(define-key dired-mode-map "z" 'ywb-dired-compress-dir)
(define-key dired-mode-map "E" 'ywb-dired-w3m-visit)
(define-key dired-mode-map "j" 'ywb-dired-jump-to-file)
(define-key dired-mode-map " " 'ywb-dired-count-dir-size)
(define-key dired-mode-map "W" 'ywb-dired-copy-fullname-as-kill)
(define-key dired-mode-map "\C-q" 'ywb-dired-quickview)))


;;; dired.el ends here
