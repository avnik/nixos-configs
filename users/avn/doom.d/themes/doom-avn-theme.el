;; doom-avn-theme.el --- a more avn version of doom-one
(require 'doom-themes)

;;
(defgroup doom-avn-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-avn-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-avn-theme
  :type 'boolean)

(defcustom doom-avn-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-avn-theme
  :type 'boolean)

(defcustom doom-avn-comment-bg doom-avn-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-avn-theme
  :type 'boolean)

(defcustom doom-avn-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-avn-theme
  :type '(or integer boolean))


;;
(def-doom-theme doom-avn
  "A dark theme based off of doom-one with more black colors."

  ;; name        gui       256       16
  ((bg         '("#010101" nil       nil))
   (bg-alt     '("#010101" nil       nil))
;;   (bg-alt     '("#1c1f24" nil       nil))
   (base0      '("#242730" "#101010" "black"        ))
   (base1      '("#2a2e38" "#1e1e1e" "brightblack"  ))
   (base2      '("#21272d" "#21212d" "brightblack"  ))
   (base3      '("#23272e" "#262626" "brightblack"  ))
   (base4      '("#484854" "#5e5e5e" "brightblack"  ))
   (base5      '("#62686E" "#666666" "brightblack"  ))
   (base6      '("#757B80" "#7b7b7b" "brightblack"  ))
   (base7      '("#9ca0a4" "#979797" "brightblack"  ))
   (base8      '("#DFDFDF" "#dfdfdf" "white"        ))
   (fg         '("#bbc2cf" "#bfbfbf" ))
   (fg-alt     '("#5D656B" "#5d5d5d" ))

   (grey       base4)
   (red        '("#ff665c" "#ff6655" ))
   (orange     '("#e69055" "#dd8844" ))
   (green      '("#7bc275" "#99bb66" ))
   (teal       '("#4db5bd" "#44b9b1" ))
   (yellow     '("#FCCE7B"           ))
   (blue       '("#51afef"           ))
   (dark-blue  '("#1f5582"           ))
   (magenta    '("#C57BDB"           ))
   (violet     '("#a991f1"           )) ;a9a1e1
   (cyan       '("#5cEfFF"           ))
   (dark-cyan  '("#6A8FBF"           ))

   ;; face categories
   (highlight      blue)
   (vertical-bar   base0)
   (selection      dark-blue)
   (builtin        magenta)
   (comments       (if doom-avn-brighter-comments dark-cyan base5))
   (doc-comments   (if doom-avn-brighter-comments (doom-lighten dark-cyan 0.15) (doom-lighten base4 0.3)))
   (constants      violet)
   (functions      cyan)
   (keywords       blue)
   (methods        violet)
   (operators      magenta)
   (type           yellow)
   (strings        green)
   (variables      base8)
   (numbers        orange)
   (region         "#3d4451")
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    yellow)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (hidden-alt `(,(car bg-alt) "black" "black"))
   (-modeline-pad
    (when doom-avn-padded-modeline
      (if (integerp doom-avn-padded-modeline) doom-avn-padded-modeline 4)))

   (modeline-fg     "#bbc2cf")
   (modeline-fg-alt (doom-blend blue grey (if doom-avn-brighter-modeline 0.4 0.08)))

   (modeline-bg
    (if doom-avn-brighter-modeline
        `("#383f58" ,@(cdr base1))
      `(,(car bg-alt) ,@(cdr base0))))
   (modeline-bg-l
    (if doom-avn-brighter-modeline
        modeline-bg
      `(,(doom-darken (car bg) 0.15) ,@(cdr base1))))
   (modeline-bg-inactive   (doom-darken bg 0.25))
   (modeline-bg-inactive-l `(,(doom-darken (car bg-alt) 0.2) ,@(cdr base0))))


  ;; --- extra faces ------------------------
  ((elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   (font-lock-comment-face
    :foreground comments
    :background (if doom-avn-comment-bg (doom-darken bg-alt 0.095)))
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground blue :bold bold)

   (doom-modeline-bar :background (if doom-avn-brighter-modeline modeline-bg highlight))
   (doom-modeline-buffer-path :foreground (if doom-avn-brighter-modeline base8 blue) :bold bold)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if doom-avn-brighter-modeline base8 highlight))

   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))

   ;; --- major-mode faces -------------------
   ;; css-mode / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)

   ;; markdown-mode
   (markdown-header-face :inherit 'bold :foreground red)

   ;; org-mode
   (org-hide :foreground hidden)
   (solaire-org-hide-face :foreground hidden-alt))


  ;; --- extra variables --------------------
  ;; ()
  )

;;; doom-avn-theme.el ends here
