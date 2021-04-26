;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Alexander V. Nikolaev"
      user-mail-address "avn@avnik.info"
      doom-theme 'doom-avn
      doom-font (font-spec :family "Go Mono" :size 18)
;      doom-font (font-spec :family "Anonymous Pro" :size 18)
;      doom-font (font-spec :family "Fira Mono" :size 18)
      doom-big-font (font-spec :family "Fira Mono" :size 22))
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'goto-address-mode) ;; Linkify links!
;; Place your private configuration here

(load! "+org")
