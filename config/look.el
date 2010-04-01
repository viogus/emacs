;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2010-04-02 01:09:26 +800 Zhixun LIN>
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

;;need none of the bars...
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
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

       (scroll-bar-mode -1)
       (tool-bar-mode -1)
       (menu-bar-mode -1)
       ;; 不要 tool-bar 和 scroll-bar。

       (require 'tmtheme)
       (setq tmtheme-directory "~/.emacs.d/tmthemes")
       (tmtheme-scan)
       (tmtheme-Blackboard)
       ))
