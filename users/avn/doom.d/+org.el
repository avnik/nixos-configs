(setq +todo-file "~/.org/gtd.org"
      org-agenda-files '("~/.org"))
(setq +daypage-path "~/.org/days/")

(after! org
  (map! :map evil-org-mode-map
        :localleader
        :desc "Create/Edit Todo" "o" #'org-todo
        :desc "Schedule" "s" #'org-schedule
        :desc "Deadline" "d" #'org-deadline
        :desc "Refile" "r" #'org-refile
        :desc "Filter" "f" #'org-match-sparse-tree
        :desc "Tag heading" "t" #'org-set-tags-command)
  ;; The standard unicode characters are usually misaligned depending on the font.
  ;; This bugs me. Personally, markdown #-marks for headlines are more elegant.

   (setq
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-todo-keywords-for-agenda '((sequence "TODO" "WAITING" "NEXT" "|" "DONE" "CANCELED"))
        ;; Put state changes into the LOGBOOK drawer, to clean up a bit
        org-log-into-drawer t)

   (setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "STARTED(s)" "FEEDBACK(f)" 
                        "|" "DONE(d!/!)" "DELEGATED")
              (sequence "WAITING(w@/!)" "SOMEDAY(S!)" 
                        "|" "CANCELLED(c@/!)" "PHONE")
              (sequence "OPEN(O!)" "|" "CLOSED(C!)"))))

;;   (setq org-todo-keyword-faces 
;;      (quote (("TODO" :foreground "red" :weight bold)
;;              ("NEXT" :foreground "blue" :weight bold)
;;              ("STARTED" :foreground "blue" :weight bold)
;;              ("DONE" :foreground "forest green" :weight bold)
;;              ("WAITING" :foreground "orange" :weight bold)
;;              ("DELEGATED" :foreground "orange" :weight bold)
;;              ("SOMEDAY" :foreground "magenta" :weight bold)
;;              ("CANCELLED" :foreground "forest green" :weight bold)
;;              ("OPEN" :foreground "blue" :weight bold)
;;              ("CLOSED" :foreground "forest green" :weight bold)
;;              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("SOMEDAY" ("WAITING" . t))
              (done ("WAITING"))
              ("TODO" ("WAITING") ("CANCELLED"))
              ("NEXT" ("WAITING"))
              ("STARTED" ("WAITING"))
              ("DONE" ("WAITING") ("CANCELLED")))))
  ;; Normally its only like 3 lines tall, too hard to see anything.
  (set-popup-rule! "^\\*Org Agenda"
    :size 15
    :quit t
    :select t
    :parameters
    '((transient)))

  ;; org-match-sparse-tree
  ;; org-set-tags-command
  (defun +open-todo-file ()
    (interactive)
    "Opens the todo file"
    (find-file +todo-file))

  (map!
    :leader
    :desc "Open todo file" "O" #'+open-todo-file)

  (defun +show-agenda ()
    (interactive)
    (delete-other-windows)
    (with-popup-rules! nil
      (org-agenda-list)
      (calendar))
    (other-window 1)
    (split-window-vertically)
    (other-window 1)
    (todays-daypage))


  (map! :g
      "<f2>" #'+open-todo-file
      "<f1>" #'+show-agenda
      "<f3>" #'org-capture)

  (map! :leader
      (:prefix "o"
        :desc "Org Agenda" "a" #'org-agenda-list
        :desc "Org Agenda and Notes" "A" #'+show-agenda)
      (:when (featurep! :completion helm)
        "X" #'helm-org-capture-templates)))

