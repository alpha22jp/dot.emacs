;;; fuzzy-format.el --- select indent-tabs-mode and format code automatically.
;; -*- Mode: Emacs-Lisp -*-

;; Copyright (C) 2009 by 101000code/101000LAB

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.          See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

;; Version: 20130824.1200
;; X-Original-Version: 0.1.1
;; Author: k1LoW (Kenichirou Oyama), <k1lowxb [at] gmail [dot] com> <k1low [at] 101000lab [dot] org>
;; URL: http://code.101000lab.org, http://trac.codecheck.in

;;; Commentary:
;; This minor mode, fuzzy format mode, provides check indent format (tabs or spaces) of current buffer.
;; And it set indent-tabs-mode and format code automatically.
;; This minor mode take a neutral stance in the war of tabs indent and spaces indent...

;;; Install
;; Put this file into load-path'ed directory, and byte compile it if
;; desired.          And put the following expression into your ~/.emacs.
;;
;; (require 'fuzzy-format)
;; (setq fuzzy-format-default-indent-tabs-mode nil)
;; (global-fuzzy-format-mode t)
;;

;;; Change Log
;; 0.1.1: Fix advice bug
;; 0.1.0: display error line (it's fuzzy).
;; 0.0.9: Fix bug.
;; 0.0.8: new function fuzzy-format-check-pair.
;; 0.0.7: fuzzy-format-set-indent-mode bug fix.
;; 0.0.6: fuzzy-format-auto-format bug fix.
;; 0.0.5: new valiable fuzzy-format-default-indent-tabs-mode.
;; 0.0.4: change from fuzzy-format-no-check-modes to fuzzy-format-check-modes.
;; 0.0.3: set mode-line-buffer-identification.
;; 0.0.2: use defcustom, defgroup.
;; 0.0.1: fuzzy-format.el 0.0.1 released.

;;; Code:

(eval-when-compile (require 'cl))

(defgroup fuzzy-format nil
  "Fuzzy format."
  :group 'convenience
  :prefix "fuzzy-format-")

(defcustom fuzzy-format-default-indent-tabs-mode nil
  "Default indent-tabs-mode.Non-nil means tabs mode."
  :type 'string
  :group 'fuzzy-format)

(defcustom fuzzy-format-auto-format nil
  "Non-nil means auto format current buffer."
  :type 'boolean
  :group 'fuzzy-format)

(defcustom fuzzy-format-auto-indent nil
  "Non-nil means auto indent current buffer."
  :type 'boolean
  :group 'fuzzy-format)

(defcustom fuzzy-format-check-modes ;;default list from auto-complete.el
  '(emacs-lisp-mode lisp-interaction-mode
                    c-mode cc-mode c++-mode java-mode
                    perl-mode cperl-mode python-mode ruby-mode
                    ecmascript-mode javascript-mode php-mode css-mode
                    makefile-mode sh-mode fortran-mode f90-mode ada-mode
                    xml-mode sgml-mode)
  "Major modes `fuzzy-format-mode' check."
  :type '(list symbol)
  :group 'fuzzy-format)

(defcustom fuzzy-format-pair-regexp
  (list '("<div" . "</div>")
        '("<table" . "</table>")
        '("<th" . "</th>")
        '("<tr" . "</tr>")
        '("<td" . "</td>")
        '("<\\?php" . "\\?>"))
  "`fuzzy-format-check-pair' check pair regexp list."
  :group 'fuzzy-format)

(defcustom fuzzy-format-mode-line
  `(" " (:eval (format ,(propertize "%s" 'face 'font-lock-warning-face)
                       (if indent-tabs-mode "[T]" "[S]"))))
  "What to display in mode line for fuzzy format mode."
  :group 'fuzzy-format)
(put 'fuzzy-format-mode-line 'risky-local-variable t)

(defun fuzzy-format-check-space-or-tab()
  "Check current buffer."
  (interactive)
  (let ((space-count 0) (tab-count 0))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^  " nil t) ;; should be two spaces at least
        (cl-incf space-count))
      (goto-char (point-min))
      (while (re-search-forward "^\t" nil t)
        (cl-incf tab-count))
      (cond ((> space-count tab-count) "spaces")
            ((= space-count tab-count) "=")
            (t "tabs")))))

(defun fuzzy-format-set-indent-mode()
  "Check current buffer."
  (interactive)
  (if (memq major-mode fuzzy-format-check-modes)
      (let ((indent-mode (fuzzy-format-check-space-or-tab)))
        (cond ((equal indent-mode "tabs") (fuzzy-format-set-tabs-mode))
              ((equal indent-mode "spaces") (fuzzy-format-set-spaces-mode))
              (t (setq indent-tabs-mode fuzzy-format-default-indent-tabs-mode))))))

(defun fuzzy-format-indent()
  "Indent whole buffer."
  (interactive)
  (save-excursion
    (message "now indenting...")
    (indent-region (point-min) (point-max))
    (message "done")))

(defun fuzzy-format-tabify()
  "Tabify whole buffer."
  (interactive)
  (save-excursion
    (setq indent-tabs-mode t)
    (tabify (point-min) (point-max))
    (force-mode-line-update)))

(defun fuzzy-format-untabify()
  "Untabify whole buffer."
  (interactive)
  (save-excursion
    (setq indent-tabs-mode nil)
    (untabify (point-min) (point-max))
    (force-mode-line-update)))

(defun fuzzy-format-auto-format()
  "Auto format. Tabify or untabify and delete-trailing-whitespace."
  (let ((indent-mode (fuzzy-format-check-space-or-tab)))
    (unless (or (not fuzzy-format-auto-format)
                buffer-read-only)
      (delete-trailing-whitespace)
      (cond ((equal indent-mode "tabs") (fuzzy-format-tabify))
            ((equal indent-mode "spaces") (fuzzy-format-untabify))
            (t t)))))

(defun fuzzy-format-auto-indent()
  "Auto indent."
  (let ((indent-mode (fuzzy-format-check-space-or-tab)))
    (unless (or (not fuzzy-format-auto-indent)
                buffer-read-only)
      (fuzzy-format-indent))))

(defun fuzzy-format-set-tabs-mode()
  "Set tabs mode."
  (interactive)
  (setq indent-tabs-mode t)
  (force-mode-line-update)
  t)

(defun fuzzy-format-set-spaces-mode()
  "Set spaces mode."
  (interactive)
  (setq indent-tabs-mode nil)
  (force-mode-line-update)
  t)

(define-minor-mode fuzzy-format-mode
  "Fuzzy format mode"
  :init-value nil :lighter fuzzy-format-mode-line :keymap nil
  (if fuzzy-format-mode
      (progn
        (fuzzy-format-auto-format)
        (add-hook 'find-file-hook 'fuzzy-format-set-indent-mode)
        (add-hook 'after-save-hook 'fuzzy-format-set-indent-mode))
    (remove-hook 'find-file-hook 'fuzzy-format-set-indent-mode)
    (remove-hook 'after-save-hook 'fuzzy-format-set-indent-mode)))

(define-global-minor-mode global-fuzzy-format-mode
  fuzzy-format-mode fuzzy-format-mode-maybe
  :group 'fuzzy-format)

(defun fuzzy-format-mode-maybe ()
  "Return t if `fizzy-format-mode' can run on current buffer."
  (if (and (not (minibufferp (current-buffer)))
           (memq major-mode fuzzy-format-check-modes))
      (fuzzy-format-mode t)))

(defun fuzzy-format-check-pair()
  "Check pair `fuzzy-format-pair-regexp'."
  (interactive)
  (let
      ((pair-list fuzzy-format-pair-regexp)
       (current-point (point))
       (error-line 0)
       (current-line 1)
       (last-line (count-lines (point-min) (point-max)))
       (str "")
       (line-list nil)
       (s t))
    (goto-char (point-min))
    (while (and (not (> current-line last-line)) s)
      (goto-line current-line)
      (let
          ((l nil) (point nil))
        (setq str (fuzzy-format-get-current-line))
        (cl-loop for x in pair-list do (progn
                                      (while (string-match (car x) str point)
                                        (setq point (string-match (car x) str point))
                                        (push (list point x t (line-number-at-pos)) l)
                                        (setq point (cl-incf point)))
                                      (setq point nil)
                                      (while (string-match (cdr x) str point)
                                        (setq point (string-match (cdr x) str point))
                                        (push (list point x nil (line-number-at-pos)) l)
                                        (setq point (cl-incf point)))
                                      (setq point nil)))
        (setq l (sort l (lambda (a b) (< (car a) (car b)))))
        (cl-loop
         with pair = nil
         for x in l do (if (nth 2 x)
                           (push x line-list)
                         (setq pair (pop line-list))
                         (unless (eq (nth 1 pair) (nth 1 x))
                           (setq error-line (nth 3 pair))
                           (message "%s or %s: error: Unmatched pair of %s or %s\n" (nth 3 pair) (nth 3 x) (nth 1 pair) (nth 1 x))
                           (goto-line error-line)
                           (setq s nil)
                           (cl-return))))
          (cl-incf current-line)))

    (if (and s line-list)
        (progn
          (message "%s: Unmatched pair of %s" (nth 3 (car line-list)) (nth 1 (car line-list)))
          (goto-line (nth 3 (car line-list))))
      (unless (not s)
        (message "Check OK.")
        (goto-char current-point)))))

(defun fuzzy-format-get-current-line ()
  "Get current line."
  (let ((line-start (progn
                      (beginning-of-line)
                      (point)))
        (line-end (progn
                    (end-of-line)
                    (point))))
    (buffer-substring line-start line-end)))

(provide 'fuzzy-format)

;;; end
;;; fuzzy-format.el ends here
