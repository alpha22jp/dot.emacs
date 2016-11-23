;;; diff-color.el --- diffの表示をカラフルにする (Emacs23向け)
;;
;; 参照: http://www.clear-code.com/blog/2012/4/3.html

;; diffの表示方法を変更
(defun diff-mode-setup-faces ()
  ;; 追加された行は緑で表示
  (set-face-attribute 'diff-added nil :background "#335533")
  ;; 削除された行は赤で表示
  (set-face-attribute 'diff-removed nil :background "#553333")
  ;; 追加された行の強調表示
  (set-face-attribute 'diff-refine-added nil
                      :foreground nil :background nil
		      :inherit 'diff-added :inverse-video t)
  ;; 削除された行の強調表示
  (set-face-attribute 'diff-refine-removed nil
                      :foreground nil :background nil
		      :inherit 'diff-removed :inverse-video t)
  ;; 文字単位での変更箇所は色を反転して強調
  (set-face-attribute 'diff-refine-changed nil
                      :foreground nil :background nil
                      :weight 'bold :inverse-video t))
(add-hook 'diff-mode-hook 'diff-mode-setup-faces)

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

(provide 'diff-color)
