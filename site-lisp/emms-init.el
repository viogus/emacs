;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2008-12-25 19:41:04  Zhixun LIN>
;;emms
;;-------------------
(require 'emms-setup)
(emms-standard)
(setq
 ;; 添加音乐文件默认的目录
 emms-source-file-default-directory "~/audio"
 ;; 播放器优先顺序
 emms-player-list '(emms-player-mplayer
                    emms-player-timidity
                    emms-player-mpg321
                    emms-player-ogg123)
 ;; 播放列表名，第一个字符不是空格则不隐藏
 emms-playlist-buffer-name " *EMMS*"
 ;; 默认列表窗口的宽度
 emms-playlist-mode-window-width 35
 ;; 让 emacs 来检测歌词文件的编码
 emms-lyrics-coding-system nil
 ;; 歌词文件查找目录
 ;emms-lyrics-dir "/home/lin/audio/lrc/"
 ;; 歌词滚动的速度
 emms-lyrics-scroll-timer-interval 1
 ;; 调节音量的声道
 emms-volume-amixer-control "PCM"
 ;; 保存打分的文件
 emms-score-file "~/.emacs.d/.emms-score"
 emms-playlist-default-major-mode 'emms-playlist-mode)
;; 播放列表不折行显示
(add-hook 'emms-playlist-mode-hook
          (lambda ()
            (toggle-truncate-lines 1)))
;; 在 mode-line 中显示播放的文件信息
(require 'emms-mode-line)
(emms-mode-line 1)
;; 显示播放音乐的长度和播放时间
(require 'emms-playing-time)
(emms-playing-time 1)
;; 显示歌词
;(require 'emms-lyrics)
;(emms-lyrics 1)
;; 调整音量
(require 'emms-volume)
;; 使用标记来管理列表
(require 'emms-mark)
;; 修改音乐的标签
(require 'emms-tag-editor)
;; 给音乐打分
(require 'emms-score)
(emms-score 1)
;; 自动识别音乐标签的编码
(require 'emms-i18n)
;; 自动保存和导入上次的播放列表
(require 'emms-history)

;; 自带调整音量的命令在开启输入法后很不好用，所以改成下面这样
(defvar emms-volume-amixer-raise-commands
  '(?=))
(defvar emms-volume-amixer-lower-commands
  '(?-))
(defun emms-volume-amixer-raise (&optional arg)
  (interactive "P")
  (if arg
      (emms-volume-amixer-change -2)
    (emms-volume-amixer-change 2))
  (let (command)
    (while (progn
             (setq command (read-event))
             (cond ((member command emms-volume-amixer-raise-commands)
                    (emms-volume-amixer-change 2))
                   ((member command emms-volume-amixer-lower-commands)
                    (emms-volume-amixer-change -2)))))
    (setq unread-command-events (list command))))
(defun emms-volume-amixer-lower ()
  (interactive)
  (emms-volume-amixer-raise -1))

;; 按键绑定
(define-key emms-volume-minor-mode-map "=" 'emms-volume-mode-plus)
(dolist (kbd
         '(("=" . emms-volume-raise)
           ("A" . emms-score-up-file-on-line)
           ("X" . emms-score-down-file-on-line)
           ("N" . emms-playlist-new)))
  (define-key emms-playlist-mode-map (car kbd) (cdr kbd)))
(define-prefix-command 'ctl-ce-map)
(global-set-key "\C-cm" 'ctl-ce-map)
(set-keymap-parent ctl-ce-map emms-playlist-mode-map)
(dolist (kbd
         '(("m" . emms-playlist-mode-go-popup)
           ("u" . emms-score-up-playing)
           ("s" . emms-start)
           ("x" . emms-stop)
	   ("n" . emms-next)
	   ("p" . emms-previous)
           ("-" . emms-volume-amixer-lower)
           ("t" . emms-lyrics-visit-lyric)
           ("=" . emms-volume-amixer-raise)))
  (define-key ctl-ce-map (car kbd) (cdr kbd)))
(define-key dired-mode-map "P" 'emms-add-dired)

;; mode line format
(setq emms-mode-line-format "[ %s "
      emms-playing-time-display-format "%s ]")
;(setq global-mode-string
 ;     '("" emms-mode-line-string " " emms-playing-time-string))


(emms-history-load)                     ; 这一句最好放到配置最后面
(provide 'emms-init)
