;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2010-04-27 16:06:58 +800 Zhixun LIN>
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

;; X Window 中的 visible-bell 还是很好看的。
(setq visible-bell t)
;;(color-theme-initialize)
;; One theme rules all.
(color-theme-zenburn)

;(require 'tmtheme)
;(setq tmtheme-directory "~/.emacs.d/tmthemes")
;(tmtheme-scan)
;(tmtheme-Blackboard)
