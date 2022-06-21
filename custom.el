(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(company-minimum-prefix-length 1)
 '(gist-list-format
   '((files "Filename" 24 nil identity)
     (created "Created" 16 nil "%D %R")
     (visibility "Visibility" 10 nil
                 (lambda
                   (public)
                   (or
                    (and public "public")
                    "private")))
     (description "Description" 0 nil identity)))
 '(magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(diminish nhexl-mode gnu-elpa-keyring-update plantuml-mode mozc-popup elscreen gist wgrep-pt pt textile-mode atomic-chrome use-package swift-mode solarized-theme smartparens smart-mode-line simplenote2 rtags helm-rtags region-bindings-mode recentf-ext quickrun popup mozc mc-extras markdown-mode magit json-mode js2-mode helm-swoop helm-gtags helm-descbinds helm-cscope helm-ag google-c-style git-gutter-fringe flycheck-irony expand-region exec-path-from-shell company-irony cmake-mode haskell-mode powerline))
 '(plantuml-indent-level 4)
 '(pt-arguments '("--smart-case" "--follow"))
 '(show-paren-mode t)
 '(sp-ignore-modes-list '(minibuffer-inactive-mode markdown-mode gfm-mode))
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tab-bar-tab ((t (:background "#002b36" :foreground "dark orange"))))
 '(textile-link-face ((t (:foreground "royalblue"))))
 '(textile-ul-bullet-face ((t (:foreground "royalblue")))))
