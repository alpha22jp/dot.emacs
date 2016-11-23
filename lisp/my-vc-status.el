;;; my-vc-status.el --- VCバックエンドに応じたstatus関数を呼び出す

;; Copyright (C) 2015  alpha22jp

;; Author: alpha22jp <alpha22jp@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(defun my-vc-status ()
  "Call VC status function depending on backend."
  (interactive)
  (require 'vc)
  (cond ((eq (vc-deduce-backend) 'SVN) (call-interactively 'svn-status))
        ((eq (vc-deduce-backend) 'Git) (call-interactively 'magit-status))
        (t (message "Buffer is not version controlled"))))

(provide 'my-vc-status)
;;; my-vc-status.el ends here
