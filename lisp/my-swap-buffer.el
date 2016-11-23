;;; my-swap-buffer.el --- Swap buffers between splitted window

;; Author: id:ikeas modified by alpha22jp
;; Keywords: split, window, swap

;;; Commentary:
;;; 参照: http://ikeas.hatenablog.com/entry/2015/01/30/223923

;;; Code:

(defun my-swap-buffer ()
  "Swap buffers between splitted window."
  (interactive)
  (let* ((current (selected-window))
         ;; Zero means this does not select minibuffer even if it's active
         (other (next-window current 0))
         (current-buf (window-buffer current)))
    (unless (or (eq current other)
                (window-minibuffer-p current))
      (set-window-buffer (selected-window) (window-buffer other))
      (set-window-buffer other current-buf)
      (select-window other))))

(provide 'my-swap-buffer)
;;; my-swap-buffer.el ends here
