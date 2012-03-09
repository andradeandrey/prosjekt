;;; anything-prosjekt.el --- Anything integration for prosjekt.

;; Copyright (C) 2012 Austin Bingham
;; Author: Austin Bingham <austin.bingham@gmail.com>

;; Originally based on anything-eproject by Daniel Hackney
;; http://www.emacswiki.org/emacs/anything-eproject.el

;; This file is NOT part of GNU Emacs.

;;; Commentary:
;;
;; Allows opening and closing prosjekt projects through anything, as well as
;; selection of files within a project.
;;
;; To activate, add anything-prosjekt.el to your load path and
;;
;;   (require 'anything-prosjekt)
;;
;; to your .emacs. You can then use the following sources
;;
;;  `anything-c-source-prosjekt-files'
;;    Search for files in the current prosjekt.
;;  `anything-c-source-prosjekt-projects'
;;    Open or close prosjekt projects.
;;
;; like this
;;
;;   (add-to-list 'anything-sources 'anything-c-source-prosjekt-files t)
;;   (add-to-list 'anything-sources 'anything-c-source-prosjekt-projects t)
;;
;; Prosjekt: https://github.com/abingham/prosjekt
;; Anything: http://www.emacswiki.org/emacs/Anything

;;; Code:

(defun prsj-temp-file-name ()
  (mapcar
   (lambda (item)
     (expand-file-name (concat prsj-proj-dir item)))
   (prsj-proj-files)))

(defvar anything-c-source-prosjekt-files
  '((name . "Files in prosjekt")
    (init . anything-c-source-prosjekt-files-init)
    ;(candidates-in-buffer)
    ; Grab candidates from all project files.
    (candidates . prsj-temp-file-name)
    (type . file)
    ; TODO: Understand this next one better.
    (real-to-display . (lambda (real)
                         (file-relative-name real prsj-proj-dir)))
    )
  "Search for files in the current prosjekt.")

(defun anything-c-source-prosjekt-files-init ()
  "Build `anything-candidate-buffer' of prosjekt files."
  (with-current-buffer (anything-candidate-buffer 'local)
    (mapcar
     (lambda (item)
       (insert (format "%s/%s\n" (prsj-get-project-item "name") item)))
     (prsj-proj-files))))

(defvar anything-c-source-prosjekt-projects
  '((name . "Prosjekt projects")
    (candidates . (lambda ()
                    (mapcar
                     'car
                     (prsj-get-config-item "project-list"))))
    (action ("Open Project" . (lambda (cand)
                                (prosjekt-open cand)))
            ("Close project" . (lambda (cand)
                                 (prosjekt-close)))))
  "Open or close prosjekt projects.")

(provide 'anything-prosjekt)

;;; anything-prosjekt.el ends here
