;;; isearch-region.el --- 選択範囲をisearch
;;
;; 参照: http://blog.shibayu36.org/entry/2013/12/30/190354

;;; Commentary:

;;; Code:

(defadvice isearch-mode (around isearch-mode-default-string
                                (forward &optional regexp op-fun recursive-edit word-p)
                                activate)
  "Advice for isearch region."
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))

(provide 'isearch-region)

;;; isearch-region ends here
