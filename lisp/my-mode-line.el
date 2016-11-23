;;; my-mode-line.el --- customize mode line
;;;

;;; Commentary:

;;; Code:

(eval-when-compile (require 'cl))

(defvar mode-line-cleaner-alist
  '((abbrev-mode . "")
    (auto-revert-mode . "")
    (emacs-lisp-mode . "Elisp")))

(defun clean-mode-line ()
  "Clean mode line."
  (loop for (mode . mode-str) in mode-line-cleaner-alist do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str (setcar old-mode-str mode-str))
          (when (eq mode major-mode) (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)

(provide 'my-mode-line)

;;; my-mode-line.el ends here
