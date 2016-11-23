;;; my-auto-insert.el --- 
;;;

;;; Code:

(defun my:template-get-filename-base ()
  (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))

(defun my:template-get-filename-ext ()
  (file-name-extension (file-name-nondirectory (buffer-file-name))))

(defvar my:template-replacement-alist
  '(("%file%"          . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-base%"     . (lambda () (my:template-get-filename-base)))
    ("%date%"          . (lambda () (format-time-string "%Y-%m-%d")))
    ("%include-guard%" . (lambda () (format "%s_%s_"
                                            (upcase (my:template-get-filename-base))
                                            (upcase (my:template-get-filename-ext)))))))

(defun my:template-insert ()
  (mapc (lambda (c)
          (progn
            (replace-string (car c) (funcall (cdr c)) nil)
            (goto-char (point-min))))
        my:template-replacement-alist))

(setq auto-insert-alist
      (append
       '((("\\.\\(c\\|cpp\\)$" . "C/C++ source") . ["template.c" my:template-insert])
         (("\\.\\(h\\|hpp\\)$" . "C/C++ header") . ["template.h" my:template-insert])
         )
       auto-insert-alist))

(provide 'my-auto-insert)

;;; my-auto-insert.el ends here
