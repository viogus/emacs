;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2010-01-17 02:02:36 +800 Zhixun LIN>
;;关闭起动时的那个“开机画面”。 
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
;;(require 'color-theme)
;;显示列号。 
(setq column-number-mode t) 
;;在 mode-line 上显示时间
(display-time-mode 1)
(setq display-time-day-and-date t)
;; 在标题栏显示buffer的名称
(setq frame-title-format "emacs@%b")

(cond ((not window-system)
       ;; 如果不在 window 环境中(字符界面时)
       (setq frame-background-mode 'dark)
       ;; 设置背景为黑的，这样 Emacs 的很多缺省颜色会和黑色背景协调。
       (eval-after-load "log-view"
         ;; 设置 log-view 的颜色。
         '(progn
            (set-face-attribute 'log-view-file-face nil :foreground "blue" :weight 'bold)
            (set-face-attribute 'log-view-message-face nil :foreground "yellow" :weight 'bold))))

      ((eq window-system 'x)
       ;; 如果在 X Window 中
;;       (global-set-key (kbd "C--") 'undo)
       ;; Console 中习惯了 C-_ 作为 Undo，不妨把这个也改过来。

       (setq visible-bell t)
       ;; X Window 中的 visible-bell 还是很好看的。

       (setq x-stretch-cursor nil)
       ;; 如果设置为 t，光标在 TAB 字符上会显示为一个大方块 :)。

       ;(scroll-bar-mode -1)
       ;(tool-bar-mode -1)
       ;(menu-bar-mode -1)
       ;; 不要 tool-bar 和 scroll-bar。

       (setq default-frame-alist
             ;; 缺省的颜色设置。
             `(;(vertical-scroll-bars)
               ;(top . 0) (left . 0) (width . 80) (height . 37)
               (background-color . "DarkSlateGrey")
               (foreground-color . "Wheat")
               (cursor-color     . "gold1")
               (mouse-color      . "gold1")))
       ;; setup default font and init windows position
       ;;set it in .Xdefault
       ;(set-frame-font "Lucida Sans Typewriter Std-9")
       ;;(set-frame-font "Bitstream Vera Sans Mono-9")
       ;;(set-frame-font "Lucida Typewriter Std-9")
       ;;(set-frame-font "Monaco-10")
       ;(set-fontset-font (frame-parameter nil 'font)
	;		 'unicode  '("微米黑" . "unicode-bmp"))
;;
       ;; 其他颜色设置。
       (if (facep 'mode-line)
           (set-face-attribute 'mode-line nil :foreground "DarkSlateGrey" :background "Wheat"))
       (if (facep 'fringe)
           (set-face-attribute 'fringe nil :foreground "limegreen" :background "gray30"))
       (if (facep 'tool-bar)
           (set-face-background 'tool-bar "DarkSlateGrey"))
       (if (facep 'menu)
           (face-spec-set 'menu '((t (:foreground "Wheat" :background "DarkSlateGrey")))))
       (if (facep 'trailing-whitespace)
           (set-face-background 'trailing-whitespace "SeaGreen1"))
       (if (facep 'minibuffer-prompt)
           (face-spec-set 'minibuffer-prompt '((t (:foreground "cyan")))))))
