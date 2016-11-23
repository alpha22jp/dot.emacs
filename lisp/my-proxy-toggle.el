;;; my-proxy-toggle.el --- Toggle URL proxy settings
;;

;;; Code:

(defvar my-proxy-use-proxy t)

(defvar my-proxy-setting
  (let ((http_proxy (getenv "http_proxy"))
        (https_proxy (getenv "https_proxy"))
        (no_proxy (getenv "no_proxy")))
    (list (if http_proxy (cons "http_proxy" http_proxy) nil)
          (if https_proxy (cons "https_proxy" https_proxy) nil)
          (if no_proxy (cons "no_proxy" no_proxy) nil))))

(defun my-proxy-toggle-proxy ()
  (interactive)
  (if my-proxy-use-proxy
      (progn
        (setq url-proxy-services nil)
        (setq my-proxy-use-proxy nil)
        (message "Unset proxy services"))
    (setq url-proxy-services my-proxy-setting)
    (setq my-proxy-use-proxy t)
    (message "Set proxy services")))

(when my-proxy-use-proxy
  (setq url-proxy-services my-proxy-setting))

(provide 'my-proxy-toggle)

;;; my-proxy-toggle.el ends here
