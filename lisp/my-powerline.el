;; my-powerline.el --- My powerline theme
;;

;;; Commentary:
;; Based on: http://blechmusik.hatenablog.jp/entry/2013/12/13/020823

;;; Code:

(defface my-powerline-inactive
  '((t (:background "grey60" :inherit mode-line-inactive)))
  "My powerline inactive face."
  :group 'powerline)

(defface my-powerline-ime-active
  '((t (:background "Springgreen4" :inherit mode-line-inactive
        :foreground "white")))
  "My powerline active face for ime active mode."
  :group 'powerline)

(defface my-powerline-ime-inactive
  '((t (:background "VioletRed" :inherit mode-line-inactive
        :foreground "white")))
  "My powerline active face for ime inactive mode."
  :group 'powerline)

(defface my-powerline-buffer-name
  '((t (:background "royal blue" :inherit mode-line-inactive
        :foreground "white")))
  "My powerline active face for buffer name."
  :group 'powerline)

(defface my-powerline-major-mode
  '((t (:background "grey80" :inherit mode-line-inactive)))
  "My powerline active face for major mode."
  :group 'powerline)

(defface my-powerline-line-num
  '((t (:background "Yellow4" :inherit mode-line-inactive
        :foreground "white")))
  "My powerline active face for line number."
  :group 'powerline)

(unless (functionp 'ime-get-mode)
  (defun ime-get-mode () current-input-method))

(defpowerline powerline-ime-mode
  (if (ime-get-mode) "[あ]" "[Aa]"))

(defun get-buffer-file-eol-type ()
  "Get string which show end of line type of current buffer."
  (cl-case (coding-system-eol-type buffer-file-coding-system)
    (0 "LF")
    (1 "CRLF")
    (2 "CR")
    (otherwise "??")))

(defun get-buffer-file-coding-type ()
  "Get string which show coding type of current buffer."
  (let ((coding-type-str (symbol-name buffer-file-coding-system)))
    (cond ((string-match-p "utf-8" coding-type-str) "UTF-8")
          ((string-match-p "shift" coding-type-str) "S-JIS")
          ((string-match-p "japanese-iso-8bit" coding-type-str) "EUC-JP")
          ((string-match-p "iso-2022-jp" coding-type-str) "JIS")
          (t "ASCII"))))

(defpowerline powerline-coding-type
   (concat (get-buffer-file-coding-type) "[" (get-buffer-file-eol-type) "]"))

(defpowerline powerline-buffer-status
  (concat (if (buffer-modified-p) "M" "-") ":"
          (if buffer-read-only "R" "-")))

(defun powerline-my-theme ()
  "Setup a mode-line with major and minor modes centered."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (face3 (if active 'my-powerline-ime-active 'my-powerline-inactive))
                          (face4 (if active 'my-powerline-ime-inactive 'my-powerline-inactive))
                          (face5 (if active 'my-powerline-line-num 'my-powerline-inactive))
                          (face6 (if active 'my-powerline-buffer-name 'my-powerline-inactive))
                          (face7 (if active 'my-powerline-major-mode 'my-powerline-inactive))
                          (face-ime (if (ime-get-mode) face4 face3))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          powerline-default-separator
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           powerline-default-separator
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list
                                (powerline-raw "%4l" face5 'r)
                                (powerline-raw ":" face5)
                                (powerline-raw "%3c" face5 'r)
                                (funcall separator-left face5 face-ime)
                                (powerline-ime-mode face-ime 'l)
                                (funcall separator-left face-ime face1)
                                (powerline-coding-type face1 'l)
                                (funcall separator-left face1 face2)
                                (powerline-buffer-status face2 'l)
                                (funcall separator-left face2 face6)
                                (powerline-buffer-id face6 'l)
                                (funcall separator-left face6 face7)
                                (powerline-major-mode face7 'l)
                                (funcall separator-left face7 face1)
                                (powerline-minor-modes face1 'l)
                                (funcall separator-left face1 face2)
                                (powerline-vc face2)
                                (powerline-raw " " face2)))
                          (rhs (list
                                (when which-function-mode
                                  (powerline-raw which-func-format face2 'r)))))
                     (concat (powerline-render lhs)
                             (powerline-fill face2 (powerline-width rhs))
                             (powerline-render rhs)))))))

(provide 'my-powerline)

;;; my-powerline.el ends here
