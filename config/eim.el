;; -*- mode: Emacs-Lisp -*-
;; Time-stamp: <2009-01-21 22:45:37 +800 Zhixun LIN>
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip 暂时还不好用
(setq eim-use-tooltip nil)

(register-input-method
 "eim-wb" "euc-cn" 'eim-use-package
 "五笔" "汉字五笔输入法" "wb.txt")
;; (register-input-method
;;  "eim-py" "euc-cn" 'eim-use-package
;;  "拼音" "汉字拼音输入法" "py.txt")

;; 用 ; 暂时输入英文，如果能用shift就好了
(require 'eim-extra)
(global-set-key ";" 'eim-insert-ascii)
(setq default-input-method "eim-wb")
;(global-set-key [(shift )] 'toggle-input-method)
;;试试，还是很快的，就是说不知道自私快速切换了。
