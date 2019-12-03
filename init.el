;;; .emacs.d/init.el --- init.el for Emacs24
;;   Author: alpha22jp <alpha22jp@gmail.com>
;;   Created: 2008/06/05

;;; Commentary:

;;; Code:

;; package settings
;;
(when (require 'package nil 'noerror)
  (setq package-archives
        '(("gnu" . "http://elpa.gnu.org/packages/")
;;          ("melpa-stable" . "https://stable.melpa.org/packages/")
          ("melpa" . "http://melpa.org/packages/")))
  (package-initialize))

;; local lisp path settings
;;
(defvar my-lisp-dir-list '("~/.emacs.d/lisp" "~/.emacs.d/lisp-local"))
(mapc (lambda (dir)
        (mapc (lambda (e) (if (file-directory-p e)
                              (add-to-list 'load-path (expand-file-name e))))
              (directory-files dir t "^[^.]"))
        (add-to-list 'load-path (expand-file-name dir)))
      my-lisp-dir-list)

;; font settings
;;
(defvar my-default-font-family
  (cond ((eq system-type 'darwin) "Ricty Diminished")
        ((eq system-type 'windows-nt) "MeiryoKe_Console")
        (t  "Migu 2M")))
(defvar my-default-font-size
  (cond ((eq system-type 'darwin) '16)
        ((eq system-type 'windows-nt) '10)
        (t '11)))
(defun my-font-setting ()
  "My customized font setting function."
  (set-face-attribute 'default nil :font
                      (concat my-default-font-family "-"
                              (number-to-string my-default-font-size)))
  (unless (eq system-type 'windows-nt)
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      (font-spec :family "Ricty Diminished" :size 16))))
(unless (string= (frame-parameter nil 'font) "tty") (my-font-setting))

;; keyboard-translate settings
;;
(defun my-keyboard-translate ()
  "My customized keyboard translation function."
  (when (eq system-type 'darwin) (keyboard-translate ?¥ ?\\))
  (keyboard-translate ?\C-h ?\C-?))
(my-keyboard-translate)

;; frame settings
;;
(setq default-frame-alist
      (append (list
               '(cursor-color . "firebrick4")
               '(alpha . 95)
               '(width .  80)
               '(height . 40))
              default-frame-alist))
(add-hook 'after-make-frame-functions
          (lambda (f)
            (with-selected-frame f
              (my-font-setting)
              (my-keyboard-translate))))

;; custom variable settings
;;
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file)

;; general settings
;;
(setq user-full-name "alpha22jp")
(setq user-mail-address "alpha22jp@gmail.com")
(setq kill-whole-line t) ;; 行頭で "C-k" すると改行を含む行全体を削除
(setq auto-save-default nil) ;; 自動セーブしない
(setq create-lockfiles nil) ;; ロックファイルを作成しない
(setq make-backup-files nil) ;; バックアップファイルを作成しない
(setq inhibit-startup-screen t) ;; スタートアップ画面を表示しない
(setq read-file-name-completion-ignore-case t) ;; ファイル名補完でignore case
(setq find-file-visit-truename t) ;; シンボリックリンクを実体のパスで開く
(setq-default tab-width 4 indent-tabs-mode nil) ;; インデント幅は4で空白を使用
(setq ad-redefinition-action 'accept) ;; defadviceによる二重定義の警告を無視
(setq compile-command "LANG=C make") ;; デフォルトのコンパイルコマンド
(setq compilation-scroll-output 't) ;; compilationバッファを出力に合わせてスクロール
(which-function-mode) ;; カーソル位置の関数名表示を有効にする
(fset 'yes-or-no-p 'y-or-n-p) ;; "yes/no" が必要なときも "y/n" だけにする

;; extra local settings
;;
(require 'my-proxy-toggle nil 'noerror) ;; HTTPプロキシをトグルする
(require 'diff-color nil 'noerror) ;; diffのカラー表示設定
(require 'isearch-region nil 'noerror) ;; リージョンをisearchできるようにする
(require 'my-vc-status nil 'noerror) ;; VCバックエンドに応じたstatus関数を呼び出す
(require 'my-mode-line nil 'noerror) ;; モードラインのカスタマイズ
(require 'my-swap-buffer nil 'noerror) ;; バッファを分割されたウィンドウ間で入れ替え

;; color-theme
;;
(if (locate-library "solarized-theme")
    (load-theme 'solarized-dark t)
  (add-hook 'window-setup-hook
            (lambda ()
              (set-face-foreground 'default "#cfcfcf")
              (set-face-background 'default "#101010"))))

;; use-package
;;
(if (locate-library "use-package")
    (require 'use-package nil 'noerror)
  (defmacro use-package (&rest args))
  (defmacro bind-keys (&rest args)))

;; exec-path-from-shell
;;
(unless (eq system-type 'windows-nt)
  (use-package exec-path-from-shell
    :config (exec-path-from-shell-initialize)))

;; recentf
;;
(eval-after-load "recentf"
  '(progn
     (setq recentf-save-file "~/.emacs.d/.recentf")
     (setq recentf-max-saved-items 100)
     (setq recentf-exclude '("/.emacs.d/elpa/*" "/.simplenote2/*" "/TAGS$" "/COMMIT_EDITMSG$"))
     (use-package recentf-ext)))

;; atomic-chrome
;;
(use-package atomic-chrome
  :config
  (setq atomic-chrome-url-major-mode-alist
        '(("github\\.com" . gfm-mode)
          ("mail\\.google\\.com" . html-mode)
          ("redmine" . textile-mode)))
  (setq atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-start-server))

;; autoinsert
;;
(use-package autoinsert
  :config
  (auto-insert-mode)
  (setq auto-insert-directory "~/.emacs.d/template/")
  (setq auto-insert-query t)
  (require 'my-auto-insert nil 'noerror))

;; smartparens
;;
(use-package smartparens-config
  :diminish smartparens-mode
  :config
  (smartparens-global-mode)
  (show-smartparens-global-mode)
  (add-hook 'emacs-lisp-mode-hook 'smartparens-strict-mode))

;; company
;;
(use-package company
  :diminish company-mode
  :init (global-company-mode)
  :bind ("C-M-i" . company-complete)
  :config
  ;; (setq company-idle-delay nil) ; 自動補完をしない
  (bind-keys :map company-active-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous)
             ("<tab>" . company-complete-selection))
  (bind-keys :map company-search-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous)))

;; irony
;;
(use-package irony
  :diminish irony-mode
  :config
  (setq irony-additional-clang-options '("-std=c++11"))
  (push 'company-irony company-backends)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'c++-mode-hook 'irony-mode))

;; flycheck
;;
(use-package flycheck
  :defer t
  :config
  (when (require 'popup nil 'noerror)
    (setq flycheck-display-errors-function
          (lambda (errors)
            (let ((messages (mapcar #'flycheck-error-message errors)))
              (popup-tip (mapconcat 'identity messages "\n"))))))
  (setq flycheck-display-errors-delay 0.5)
  (bind-keys :map flycheck-mode-map
             ("C-M-n" . flycheck-next-error)
             ("C-M-p" . flycheck-previous-error)))

;; flycheck-irony
;;
(use-package flycheck-irony
  :defer t
  :if (locate-library "flycheck")
  :config (flycheck-irony-setup))

;; flycheck-cpplint
;;
(use-package flycheck-google-cpplint
  :defer t
  :if (locate-library "flycheck")
  :config
  (setq flycheck-googlelint-extensions "cpp,hpp,c,h")
  (setq flycheck-googlelint-verbose "3")
  (setq flycheck-googlelint-linelength "120")
  (flycheck-add-next-checker 'irony '(warning . c/c++-googlelint)))

;; rtags
;;
(use-package rtags
  :config
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (setq rtags-display-result-backend 'helm)
  (push 'company-rtags company-backends)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (rtags-is-indexed)
                (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
                (local-set-key (kbd "M-[") 'rtags-find-symbol)
                (local-set-key (kbd "M-@") 'rtags-find-references-at-point)
                (local-set-key (kbd "M-,") 'rtags-location-stack-back)))))

;; fuzzy-format
;;
(use-package fuzzy-format
  :config
  (delq 'makefile-mode fuzzy-format-check-modes)
  (global-fuzzy-format-mode))

;; elscreen
;;
(use-package elscreen
  :config
  (setq elscreen-prefix-key "\C-o")
  (elscreen-start)
  (add-hook 'dired-mode-hook (lambda () (local-unset-key "\C-o")))
  (add-hook 'compilation-mode-hook (lambda () (local-unset-key "\C-o")))
  (add-hook 'svn-status-mode-hook (lambda () (local-unset-key "\C-o"))))

;; psvn
;;
(use-package psvn
  :defer t
  :config
  (setq svn-status-hide-unmodified t)
  (setq svn-status-hide-unknown t)
  (setq svn-status-svn-file-coding-system 'utf-8))

;; magit
;;
(use-package magit
  :defer t
  :config
  (setq magit-diff-refine-hunk t)
  (add-hook 'magit-mode-hook 'diff-mode-setup-faces))

;; git-gutter
;;
(use-package git-gutter
  :diminish git-gutter-mode
  :config
  (setq git-gutter:handled-backends '(git svn))
  (global-git-gutter-mode t)
  (use-package git-gutter-fringe)
  (add-hook 'git-gutter-mode-hook
            (lambda ()
              (local-set-key (kbd "M-n") 'git-gutter:next-hunk)
              (local-set-key (kbd "M-p") 'git-gutter:previous-hunk)
              (local-set-key (kbd "M-l") 'git-gutter:popup-hunk)
              (local-set-key (kbd "M-r") 'git-gutter:revert-hunk))))

;; gist
;;
(use-package gist
  :defer t
  :config
  (setq gist-ask-for-description t))

;; simplenote2
;;
(use-package simplenote2
  :config
  ;; Windowsではcurlを使うとPOSTが失敗するため、url-retrieveを使う
  (when (eq system-type 'windows-nt) (setq request-backend 'url-retrieve))
  (setq simplenote2-email user-mail-address)
  (setq simplenote2-markdown-notes-mode 'markdown-mode)
  (add-hook 'simplenote2-create-note-hook 'simplenote2-set-markdown)
  (add-hook 'simplenote2-note-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c C-t") 'simplenote2-add-tag)
              (local-set-key (kbd "C-c C-c") 'simplenote2-push-buffer)
              (local-set-key (kbd "C-c C-d") 'simplenote2-pull-buffer)))
  (require 'my-simplenote2 nil 'noerror)
  (simplenote2-setup))

;; pt/wgrep-pt
;;
(use-package wgrep-pt
  :defer t
  :config
  (setq wgrep-auto-save-buffer t) ;; 編集完了と同時に保存
  (setq wgrep-enable-key "r")
  (add-hook 'pt-search-mode-hook 'wgrep-pt-setup))

;; helm
;;
(use-package helm
  :diminish helm-mode
  :config
  (setq helm-delete-minibuffer-contents-from-point t)
  (setq helm-buffer-max-length 35)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  ;; バッファの並び順を変更しない
  (defadvice helm-buffers-sort-transformer (around ignore activate)
    (setq ad-return-value (ad-get-arg 0)))
  ;; ファイルの選択枝に ".", ".." を含めない
  (advice-add 'helm-ff-filter-candidate-one-by-one
              :around (lambda (fcn file)
                        (unless (string-match "\\(?:/\\|\\`\\)\\.\\{1,2\\}\\'" file)
                          (funcall fcn file))))
  (bind-key "C-o" 'helm-occur-from-isearch isearch-mode-map)
  (bind-keys ("C-;" . helm-mini)
             ("C-z" . helm-resume)
             ("M-y" . helm-show-kill-ring))
  (bind-keys :map ctl-x-map
             ("m" . helm-man-woman)
             ("x" . helm-M-x)
             ("C-a" . helm-apropos)
             ("C-b" . helm-buffers-list)
             ("C-d" . helm-descbinds)
             ("C-f" . helm-find-files)
             ("C-r" . helm-recentf)))
(use-package helm-files
  :defer t
  :config
  ;; ファイルが存在しないは何もしない
  (defadvice helm-ff-kill-or-find-buffer-fname (around ignore activate)
    (when (file-exists-p candidate)
      ad-do-it))
  (bind-key "<tab>" 'helm-execute-persistent-action helm-find-files-map))

;; helm-ag
;;
(use-package helm-ag
  :defer t
  :init (bind-key "C-g" 'helm-ag ctl-x-map)
  :config
  (setq helm-ag-insert-at-point 'symbol)
  (setq helm-ag-base-command "pt --nocolor --nogroup --follow"))

;; helm-swoop
;;
(use-package helm-swoop
  :defer t
  :bind ("C-t" . helm-swoop)
  :config (bind-key "C-t" 'helm-swoop-from-isearch isearch-mode-map))

;; helm-gtags
;;
(use-package helm-gtags
  :defer t
  :diminish helm-gtags-mode
  :config
  ;; (setq helm-c-gtags-path-style 'relative)
  ;; (setq helm-c-gtags-ignore-case t)
  (setq helm-gtags-auto-update t)
  (setq helm-gtags-update-interval-second 0)
  (setq helm-gtags-pulse-at-cursor nil)
  (add-hook 'helm-gtags-mode-hook
            (lambda ()
              (local-set-key (kbd "M-.") 'helm-gtags-dwim)
              (local-set-key (kbd "M-@") 'helm-gtags-find-rtag)
              (local-set-key (kbd "M-[") 'helm-gtags-find-symbol)
              (local-set-key (kbd "M-,") 'helm-gtags-pop-stack))))

;; helm-cscope
;;
(use-package helm-cscope
  :disabled t
  :diminish helm-cscope-mode
  :config
  (require 'my-cscope nil 'noerror)
  (bind-keys :map helm-cscope-mode-map
             ("M-." . helm-cscope-find-global-definition)
             ("M-@" . helm-cscope-find-calling-this-funtcion)
             ("M-[" . helm-cscope-find-this-symbol)
             ("M-," . helm-cscope-pop-mark))
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (locate-dominating-file default-directory "cscope.out")
                (helm-cscope-mode)))))

;; multiple-cursors
;;
(use-package multiple-cursors
  :bind ("C-]" . mc/mark-all-dwim)
  :config (use-package mc-extras))

;; expand-region
;;
(use-package expand-region
  :bind
  ("C-@" . er/expand-region)
  ("C-M-@" . er/contract-region))

;; region bindings mode
;;
(use-package region-bindings-mode
  :diminish region-bindings-mode
  :config
  (region-bindings-mode-enable)
  (bind-key "<tab>" 'indent-region region-bindings-mode-map)
  (when (require 'multiple-cursors nil 'noerror)
    (bind-keys :map region-bindings-mode-map
               ("C-;" . comment-dwim)
               ("C-]" . mc/mark-all-like-this-dwim)
               ("C-l" . mc/edit-lines)
               ("M-n" . mc/mark-next-like-this)
               ("M-p" . mc/mark-previous-like-this)
               ("M-u" . mc/remove-current-cursor)
               ("C-M-n" . mc/cycle-forward)
               ("C-M-p" . mc/cycle-backward))))

;; smart-mode-line
;;
(use-package smart-mode-line
  :disabled t
  :config
  (setq rm-blacklist "\\` Abbrev\\'\\|\\` MRev\\'")
  (setq sml/name-width 32)
  (add-to-list 'rm-text-properties '("\\` mc" 'face 'font-lock-warning-face))
  (sml/setup))

;; powerline
;;
(use-package powerline
  :config
  (setq powerline-display-buffer-size nil)
  (if (require 'my-powerline nil 'noerror)
      (powerline-my-theme)
    (powerline-default-theme)))

;; quickrun
;;
(use-package quickrun
  :defer t
  :config
  (quickrun-add-command
   "c++/g++"
   '((:exec . ("%c -std=c++11 -pthread -Wall -Werror -Weffc++ %o -o %e %s" "%e %a")))
   :override t)
  (quickrun-add-command
   "javascript/node-harmony"
   '((:command . "node")
     (:description . "Run Javascript file with node.js(harmony)")
     (:cmdopt . "--harmony")))
  (quickrun-set-default "javascript" "javascript/node-harmony"))

;; c/c++ mode
;;
(eval-after-load "cc-mode"
  '(progn
     (add-hook 'c-mode-common-hook
               (lambda ()
                 (c-set-style "stroustrup")
                 (setq c-basic-offset 4)
                 (c-set-offset 'case-label 0)
                 (c-set-offset 'member-init-intro '+)
                 (when (locate-library "helm-gtags")
                   (when (locate-dominating-file default-directory "GTAGS")
                     (helm-gtags-mode)))
                 (c-toggle-hungry-state 1)
                 (setq truncate-lines t)
                 (setq comment-column 4)))
     (add-hook 'c++-mode-hook
               (lambda ()
                 (c-set-offset 'access-label -3)))))

;; emacs-lisp mode
;;
(when (locate-library "flycheck")
  (add-hook 'emacs-lisp-mode-hook 'flycheck-mode))

;; hexl mode
;;
(eval-after-load "hexl"
  '(progn
     ;; (setq hexl-options "-hex -group-by-8-bits")
     (setq hexl-bits 8)
     (add-hook 'hexl-mode-hook
               (lambda ()
                 (local-set-key (kbd "C-c C-s") 'hexl-insert-hex-string)))))

;; javascript mode
;;
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(eval-after-load "js2-mode"
  (setq js-indent-level 2))

;; json mode
;;
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

;; ruby mode
;;
(eval-after-load "ruby-mode"
  '(progn
     (require 'rcodetools nil 'noerror)
     (add-hook 'ruby-mode-hook
               (lambda ()
                 (local-set-key (kbd "C-c C-c") 'xmp)))))

;; haskell mode
;;
(add-hook 'haskell-mode-hook
          (lambda ()
            ;; (setq haskell-process-show-debug-tips nil)
            (interactive-haskell-mode 1)
            (turn-on-haskell-doc-mode)
            (turn-on-haskell-indentation)))

;; eshell mode
;;
(eval-after-load "esh-mode"
  '(progn
     (add-hook 'eshell-mode-hook
               (lambda ()
                 (define-key eshell-mode-map (kbd "\C-a") 'eshell-bol)))))

;; markdown mode
;;
(add-to-list 'auto-mode-alist
             '("\\.md\\'\\|app\\.simplenote\\.com_" . gfm-mode))
(add-hook 'markdown-mode-hook
          (lambda () (show-paren-mode 0)))

;; plantuml mode
;;
(use-package plantuml-mode
  :config
  (setq plantuml-default-exec-mode 'jar))
(add-to-list 'auto-mode-alist '("\\.uml" . plantuml-mode))
(add-hook 'plantuml-mode-hook
          (lambda () (plantuml-set-output-type "png")))

;; coding system settings
;;
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; input method
;;
(if (eq system-type 'windows-nt)
    ;; WindowsではWindows上のIMEを使う
    (require 'ime-temp-off nil 'noerror) ;; ミニバッファ中は自動的にIMEオフ
  (use-package mozc
    :bind ("<henkan>" . toggle-input-method)
    :config
    (setq default-input-method "japanese-mozc")
    (bind-key "<henkan>" 'toggle-input-method mozc-mode-map))
  (use-package mozc-popup
    :config
    (setq mozc-candidate-style 'popup)))


;; global key bindings
;;
(bind-keys :map ctl-x-map
           ("C-o" . my-swap-buffer)
           ("C-z" . save-buffers-kill-emacs)
           ("t" . toggle-truncate-lines))
(bind-keys ("M-h" . help-for-help)
           ("C-M-h" . help-for-help)
           ("M-g" . goto-line)
           ("C-^" . delete-indentation)
           ("M-^" . next-error)
           ("C-M-^" . previous-error)
           ("C-," . beginning-of-buffer)
           ("C-." . end-of-buffer)
           ("M-(" . backward-list)
           ("M-)" . forward-list)
           ("C-<tab>" . other-window)
           ("<f1>" . delete-other-windows)
           ("<f2>" . elscreen-previous)
           ("<f3>" . elscreen-next)
           ("<f4>" . split-window-vertically)
           ("<f5>" . quickrun)
           ("<f6>" . describe-personal-keybindings)
           ("<f7>" . compile)
           ("<f8>" . pt-regexp)
           ("<f9>" . vc-print-log)
           ("<f10>" . my-vc-status)
           ("<f11>" . vc-diff)
           ("<f12>" . vc-revert)
           ("<hiragana-katakana>" . dabbrev-expand))

(provide 'init)

;;; init.el ends here
