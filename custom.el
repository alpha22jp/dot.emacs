(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(company-minimum-prefix-length 1)
 '(gist-list-format
   (quote
    ((files "Filename" 24 nil identity)
     (created "Created" 16 nil "%D %R")
     (visibility "Visibility" 10 nil
                 (lambda
                   (public)
                   (or
                    (and public "public")
                    "private")))
     (description "Description" 0 nil identity))))
 '(helm-ag-base-command "pt --nocolor --nogroup --follow")
 '(magit-display-buffer-function (quote magit-display-buffer-same-window-except-diff-v1))
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (elscreen gist wgrep-pt pt textile-mode atomic-chrome use-package swift-mode solarized-theme smartparens smart-mode-line simplenote2 rtags region-bindings-mode recentf-ext quickrun popup mozc mc-extras markdown-mode magit json-mode js2-mode helm-swoop helm-gtags helm-descbinds helm-cscope helm-ag google-c-style git-gutter-fringe flycheck-irony expand-region exec-path-from-shell company-irony cmake-mode haskell-mode powerline)))
 '(pt-arguments (quote ("--smart-case" "--follow")))
 '(show-paren-mode t)
 '(sp-ignore-modes-list (quote (minibuffer-inactive-mode markdown-mode gfm-mode)))
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
