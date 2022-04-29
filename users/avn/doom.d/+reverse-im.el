(use-package! reverse-im
  :config
  (reverse-im-activate "russian-computer")
  (after! evil
    ;; cyrillic tweaks
    (define-key evil-normal-state-map (kbd "C-х") #'evil-force-normal-state)
    (define-key evil-insert-state-map (kbd "C-х") #'evil-normal-state)
    (define-key evil-visual-state-map (kbd "C-х") #'evil-exit-visual-state)))
