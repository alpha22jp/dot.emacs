;; ime-temp-off.el
;; ミニバッファに入るときにIMEを一時的にオフにする
;; 参照: http://d.hatena.ne.jp/Tan90909090/20121022/1350892975

(defvar my-temp-ime-mode nil)
(defun my-into-minibuffer-func()
  (setq my-temp-ime-mode (ime-get-mode))
  (ime-force-off))
(defun my-quit-minibuffer-func()
  (if my-temp-ime-mode
      (ime-force-on))
  (setq my-ime-temp nil))

;; 通常のミニバッファ
(add-hook 'minibuffer-setup-hook 'my-into-minibuffer-func)
(add-hook 'minibuffer-exit-hook 'my-quit-minibuffer-func)

;; インクリメンタル検索
(add-hook 'isearch-mode-hook 'my-into-minibuffer-func)
(add-hook 'isearch-mode-end-hook 'my-quit-minibuffer-func)

(provide 'ime-temp-off)
