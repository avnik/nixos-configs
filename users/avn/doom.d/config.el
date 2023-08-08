;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Alexander V. Nikolaev"
      user-mail-address "avn@avnik.info"
;      doom-theme 'doom-avn
      doom-theme 'doom-dracula
      doom-font (font-spec :family "Go Mono" :size 18)
;      doom-font (font-spec :family "Anonymous Pro" :size 18)
;      doom-font (font-spec :family "Fira Mono" :size 18)
      doom-big-font (font-spec :family "Fira Mono" :size 22))
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'goto-address-mode) ;; Linkify links!

;; Place your private configuration here
(setq deft-directory "~/notes")

(after! minimap-mode
  (pushnew! minimap-major-modes 'prog-mode))

;; Prefer ormolu for haskell
(set-formatter! 'ormolu "ormolu" :modes '(haskell-mode))

(after! emojify
  (setq emojify-download-emojis-p nil))

(after! highlight-indent-guides
  (setq highlight-indent-guides-method 'bitmap))

;;; Stolen  from hlissner
;;; :completion company
;; IMO, modern editors have trained a bad habit into us all: a burning need for
;; completion all the time -- as we type, as we breathe, as we pray to the
;; ancient ones -- but how often do you *really* need that information? I say
;; rarely. So opt for manual completion:
(after! company
  (setq company-idle-delay nil))

;;; :tools lsp
;; Disable invasive lsp-mode features
(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil
        ;; If an LSP server isn't present when I start a prog-mode buffer, you
        ;; don't need to tell me. I know. On some machines I don't care to have
        ;; a whole development environment for some ecosystems.
        lsp-enable-suggest-server-download nil))
(after! lsp-ui
  (setq lsp-ui-sideline-enable nil  ; no more useful than flycheck
        lsp-ui-doc-enable nil))  

(load! "+reverse-im")
(load! "+org")
