;;; dionysos-mode.el --- Dionysos mode

;; Copyright (C) 2015 Nicolas Lamirault <nicolas.lamirault@gmail.com>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;;; Code:


(require 'cl-lib)
(require 'f)
(require 'tabulated-list)


(defvar dionysos--directory-mode-hook nil)

(defvar dionysos--directory-mode-map
  (let ((map (make-keymap)))
    map)
  "Keymap for `dionysos--directory-mode' major mode.")

(define-derived-mode dionysos--directory-mode tabulated-list-mode
  "Dionysos mode"
  "Major mode for Dionysos."
  :group 'dionysos
  (setq tabulated-list-format [("Name"  40 t)
                               ("Type"  10 nil)
                               ])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Name" nil))
  (tabulated-list-init-header))

(defun dionysos--create-filenames-entries (filenames)
  "Create entries for 'tabulated-list-entries from `FILENAMES'."
  (mapcar (lambda (filename)
            (list filename
                  (vector (colorize-term (f-no-ext (f-filename filename)) 'green)
                          (f-ext filename))))
          filenames))

(defvar dionysos--directory-mode-history nil)

;;;###autoload
(defun dionysos-directory (directory)
  "Show music files from `DIRECTORY'."
  (interactive
   (list (read-from-minibuffer "Music directory : "
                               (car dionysos--directory-mode-history)
                               nil
                               nil
                               'dionysos--directory-mode-history)))
  (pop-to-buffer "*Dionysos*" nil)
  (dionysos--directory-mode)
  (setq tabulated-list-entries
        (dionysos--create-filenames-entries
         (dionysos--list-directory directory)))
  (tabulated-list-print t))




(provide 'dionysos-mode)
;;; dionysos-mode.el ends here
