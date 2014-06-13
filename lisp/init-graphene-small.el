;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (let ((graphene-sys
  (cond ((eq system-type 'darwin) "osx")
        ((eq system-type 'gnu/linux) "linux")
        ((eq system-type 'windows-nt) "windows")
        (t "other"))))
  (defvar graphene-sys-defaults (intern (format "graphene-%s-defaults" graphene-sys))
    "Symbol for the specific system-based defaults file."))


(defgroup graphene nil
  "Graphene custom settings."
  :group 'environment)

(defcustom graphene-linum-auto t
  "Whether graphene should enable line numbers with prog-modes."
  :type 'boolean
  :group 'graphene)

(defcustom graphene-autopair-auto t
  "Whether graphene should enable pair matching with prog-modes."
  :type 'boolean
  :group 'graphene)

(defcustom graphene-parens-auto t
  "Whether graphene should show matching pairs with prog-modes."
  :type 'boolean
  :group 'graphene)

(defcustom graphene-prog-mode-hooks
  '(prog-mode-hook
    csharp-mode-hook
    coffee-mode-hook
    css-mode-hook
    sgml-mode-hook
    html-mode-hook)
  "List of hooks to be treated as prog-mode."
  :type 'sexp
  :group 'graphene)

(defcustom graphene-default-font nil
  "The universal default font."
  :type 'string
  :group 'graphene)

(defcustom graphene-variable-pitch-font nil
  "The font to use in the variable-pitch face."
  :type 'string
  :group 'graphene)

(defcustom graphene-fixed-pitch-font nil
  "The font to use in the fixed-pitch face."
  :type 'string
  :group 'graphene)

(defvar graphene-prog-mode-hook nil
  "A hook to be run on entering a de facto prog mode.")              

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kill-default-buffer ()
  "Kill the currently active buffer -- set to C-x k so that users are not asked which buffer they want to kill."
  (interactive)
  (let (kill-buffer-query-functions) (kill-buffer)))

(defun kill-buffer-if-file (buf)
  "Kill a buffer only if it is file-based."
  (when (buffer-file-name buf)
    (when (buffer-modified-p buf)
        (when (y-or-n-p (format "Buffer %s is modified - save it?" (buffer-name buf)))
            (save-some-buffers nil buf)))
    (set-buffer-modified-p nil)
    (kill-buffer buf)))

(defun kill-all-buffers ()
    "Kill all file-based buffers."
    (interactive)
    (mapc (lambda (buf) (kill-buffer-if-file buf))
     (buffer-list)))

(defun kill-buffer-and-window ()
  "Close the current window and kill the buffer it's visiting."
  (interactive)
  (progn
    (kill-buffer)
    (delete-window)))

(defun create-new-buffer ()
  "Create a new buffer named *new*[num]."
  (interactive)
  (switch-to-buffer (generate-new-buffer-name "*new*")))

(defun insert-semicolon-at-end-of-line ()
  "Add a closing semicolon from anywhere in the line."
  (interactive)
  (save-excursion
    (end-of-line)
    (insert ";")))

(defun comment-current-line-dwim ()
  "Comment or uncomment the current line."
  (interactive)
  (save-excursion
    (push-mark (beginning-of-line) t t)
    (end-of-line)
    (comment-dwim nil)))

(defun newline-anywhere ()
  "Add a newline from anywhere in the line."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun increase-window-height (&optional arg)
  "Make the window taller by one line. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window arg))

(defun decrease-window-height (&optional arg)
  "Make the window shorter by one line. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window (- 0 arg)))

(defun decrease-window-width (&optional arg)
  "Make the window narrower by one column. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window (- 0 arg) t))

(defun increase-window-width (&optional arg)
  "Make the window wider by one column. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window arg t))

;; Create a new instance of emacs
(when window-system
  (defun new-emacs-instance ()
    (interactive)
    (let ((path-to-emacs
           (locate-file invocation-name
                        (list invocation-directory) exec-suffixes)))
      (call-process path-to-emacs nil 0 nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene Editing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Delete marked text on typing
(delete-selection-mode t)

;; Soft-wrap lines
(global-visual-line-mode t)

;; Linum format to avoid graphics glitches in fringe
(setq linum-format " %4d ")

;; Don't use tabs for indent; replace tabs with two spaces.
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; Nicer scrolling with mouse wheel/trackpad.
(unless (and (boundp 'mac-mouse-wheel-smooth-scroll) mac-mouse-wheel-smooth-scroll)
  (global-set-key [wheel-down] (lambda () (interactive) (scroll-up-command 1)))
  (global-set-key [wheel-up] (lambda () (interactive) (scroll-down-command 1)))
  (global-set-key [double-wheel-down] (lambda () (interactive) (scroll-up-command 2)))
  (global-set-key [double-wheel-up] (lambda () (interactive) (scroll-down-command 2)))
  (global-set-key [triple-wheel-down] (lambda () (interactive) (scroll-up-command 4)))
  (global-set-key [triple-wheel-up] (lambda () (interactive) (scroll-down-command 4))))

;; Character encodings default to utf-8.
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; apply syntax highlighting to all buffers
(global-font-lock-mode t)

(eval-after-load 'smartparens
  '(progn
     (require 'smartparens-config)
      (defun graphene--sp-pair-on-newline (id action context)
 	  	"Put trailing pair on newline and return to point."
 	  	(save-excursion
	     (newline)
	     (indent-according-to-mode)))
	  (defun graphene--sp-pair-on-newline-and-indent (id action context)
	   "Open a new brace or bracket expression, with relevant newlines and indent. "
	   (graphene--sp-pair-on-newline id action context)
	   (indent-according-to-mode))
	  (sp-pair "{" nil :post-handlers
 	         '(:add ((lambda (id action context)
	                    (graphene--sp-pair-on-newline-and-indent id action context)) "RET")))
	  (sp-pair "[" nil :post-handlers
	          '(:add ((lambda (id action context)
	                    (graphene--sp-pair-on-newline-and-indent id action context)) "RET")))
	  (sp-local-pair '(markdown-mode gfm-mode) "*" "*"
	                :unless '(sp-in-string-p)
	                :actions '(insert wrap))
	  (push 'coffee-mode sp-autoescape-string-quote-if-empty)

      (setq sp-highlight-pair-overlay nil)))

(require 'web-mode)

(push '("php" . "\\.phtml\\'") web-mode-engine-file-regexps)

(dolist (engine-regexp web-mode-engine-file-regexps)
  (when (cdr engine-regexp)
    (add-to-list 'auto-mode-alist `(,(cdr engine-regexp) . web-mode))))

(add-hook 'web-mode-hook
          (lambda ()
            (setq web-mode-disable-auto-pairing t)))

;; Main hook to be run on entering de facto prog modes, enabling linum, autopair,
;; plus setting binding newline key to newline-and-indent
(add-hook 'graphene-prog-mode-hook
          (lambda ()
            (when graphene-linum-auto
              (graphene-linum))
            (when graphene-autopair-auto
              (graphene-autopair))
            (when 'graphene-parens-auto
                (graphene-parens))
            (define-key (current-local-map) [remap newline] 'newline-and-indent)))

(defun graphene-linum ()
  (linum-mode t))

(defun graphene-autopair ()
  (require 'smartparens)
  (smartparens-mode t))

(defun graphene-parens ()
  (show-paren-mode nil)
  (setq blink-matching-paren nil)
  (show-smartparens-mode t)
  (setq sp-show-pair-delay 0))

;; auto markdown(gfm)-mode
(push '("\\.md\\'" . gfm-mode) auto-mode-alist)
(push '("\\.markdown\\'" . gfm-mode) auto-mode-alist)
(add-hook 'gfm-mode-hook (lambda () (auto-fill-mode t)))

;; auto json-mode
(push '("\\.json\\'" . json-mode) auto-mode-alist)

;; auto feature-mode
(push '("\\.feature\\'" . feature-mode) auto-mode-alist)

;; don't compile sass/scss on saving
(setq scss-compile-at-save nil)

;; 2-space indent for CSS
(setq css-indent-offset 2)

;; Default Ruby filetypes
(dolist (regex
         '("\\.watchr$" "\\.arb$" "\\.rake$" "\\.gemspec$" "\\.ru$" "Rakefile$" "Gemfile$" "Capfile$" "Guardfile$" "Rakefile$" "Cheffile$" "Vagrantfile$"))
  (add-to-list 'auto-mode-alist `(,regex . ruby-mode)))

;; Remap newline to newline-and-indent in ruby-mode
(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key (current-local-map) [remap newline] 'reindent-then-newline-and-indent)))

;; Attach de facto prog mode hooks after loading init file
(add-hook 'after-init-hook
          (lambda ()
            (dolist (hook graphene-prog-mode-hooks)
              (add-hook hook (lambda () (run-hooks 'graphene-prog-mode-hook))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene Env
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq resize-mini-windows nil
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode t)

(put 'dired-find-alternate-file 'disabled nil)
(put 'autopair-newline 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene Look
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Work around Emacs frame sizing bug when line-spacing
;; is non-zero, which impacts e.g. grizzl.
(add-hook 'minibuffer-setup-hook
          (lambda ()
            (set (make-local-variable 'line-spacing) 0)))

(setq redisplay-dont-pause t)

(scroll-bar-mode -1)

(tool-bar-mode -1)

(blink-cursor-mode -1)

(defvar graphene-geometry-file
  (expand-file-name ".graphene-geometry" user-emacs-directory)
  "The file where frame geometry settings are saved.")

(defun graphene-load-frame-geometry ()
  "Load saved frame geometry settings."
  (if (file-readable-p graphene-geometry-file)
      (with-temp-buffer
        (insert-file-contents graphene-geometry-file)
        (read (buffer-string)))
    '(160 70 0 0)))

(defun graphene-save-frame-geometry ()
  "Save current frame geometry settings."
  (with-temp-file graphene-geometry-file
    (print (graphene-get-geometry) (current-buffer))))

(defun graphene-get-geometry ()
  "Get the current geometry of the active frame."
  (list (frame-width) (frame-height) (frame-parameter nil 'top) (frame-parameter nil 'left)))

(defun graphene-set-geometry ()
  "Set the default frame geometry using the values loaded from graphene-geometry-file."
  (let ((geom (graphene-load-frame-geometry)))
    (let ((f-width (car geom))
          (f-height (cadr geom))
          (f-top (caddr geom))
          (f-left (cadddr geom)))
      (setq default-frame-alist
            (append default-frame-alist
                    `((width . ,f-width)
                      (height . ,f-height)
                      (top . ,f-top)
                      (left . ,f-left)))))))

(defun graphene-set-fonts ()
  "Set up default fonts."
  (unless graphene-default-font
    (setq graphene-default-font (face-font 'default)))
  (unless graphene-variable-pitch-font
    (setq graphene-variable-pitch-font (face-font 'variable-pitch)))
  (unless graphene-fixed-pitch-font
    (setq graphene-fixed-pitch-font (face-font 'fixed-pitch))))

(defun graphene-look-startup-after-init ()
  "Load defaults for the overall Graphene look -- to be called after loading the init file so as to pick up custom settings."
  (if window-system
      (progn
        (graphene-set-geometry)
        (add-hook 'kill-emacs-hook 'graphene-save-frame-geometry)
        (setq-default line-spacing 2)
        (graphene-set-fonts)
        (add-to-list 'default-frame-alist `(font . ,graphene-default-font))
        (set-face-font 'default graphene-default-font)
        (set-face-font 'variable-pitch graphene-variable-pitch-font)
        (set-face-font 'fixed-pitch graphene-fixed-pitch-font)
        (add-to-list 'default-frame-alist '(internal-border-width . 0))
        (set-fringe-mode '(8 . 0))
        (require 'graphene-theme)
        (load-theme 'graphene t)
        (defadvice load-theme
          (after load-graphene-theme (theme &optional no-confirm no-enable) activate)
          "Load the graphene theme extensions after loading a theme."
          (when (not (equal theme 'graphene))
            (load-theme 'graphene t))))
    (when (not (eq system-type 'darwin))
      (menu-bar-mode -1))
    ;; Menu bar always off in text mode
    (menu-bar-mode -1)))

(add-hook 'after-init-hook 'graphene-look-startup-after-init)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene Theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar graphene-font-height
  (face-attribute 'default :height)
  "Default font height.")
(defvar graphene-small-font-height
  (floor (* .917 graphene-font-height))
  "Relative size for 'small' fonts.")

(deftheme graphene "The Graphene theme -- some simple additions to any theme to improve the look of speedbar, linum, etc.")

(custom-theme-set-faces
 'graphene
 `(speedbar-directory-face
   ((t (:foreground unspecified
                    :background unspecified
                    :inherit variable-pitch
                    :weight bold
                    :height ,graphene-small-font-height))))
 `(speedbar-file-face
   ((t (:foreground unspecified
                    :inherit speedbar-directory-face
                    :weight normal))))
 `(speedbar-selected-face
   ((t (:background unspecified
                    :foreground unspecified
                    :height unspecified
                    :inherit (speedbar-file-face font-lock-function-name-face)))))
 `(speedbar-highlight-face
   ((t (:background unspecified
                    :inherit region))))
 `(speedbar-button-face
   ((t (:foreground unspecified
                    :background unspecified
                    :inherit file-name-shadow))))
 `(speedbar-tag-face
   ((t (:background unspecified
                    :foreground unspecified
                    :height unspecified
                    :inherit speedbar-file-face))))
 `(speedbar-separator-face
   ((t (:foreground unspecified
                    :background unspecified
                    :inverse-video nil
                    :inherit speedbar-directory-face
                    :overline nil
                    :weight bold))))
 `(linum
   ((t (:height ,graphene-small-font-height
                :foreground unspecified
                :inherit 'shadow
                :slant normal))))
 `(visible-mark-face
   ((t (:foreground unspecified
                    :background unspecified
                    :inverse-video unspecified
                    :inherit 'hl-line))))
 `(hl-sexp-face
   ((t (:bold nil
              :background unspecified
              :inherit 'hl-line))))
 `(fringe
   ((t (:background unspecified))))
 `(vertical-border
   ((t (:foreground unspecified
                    :background unspecified
                    :inherit file-name-shadow))))
 `(font-lock-comment-face
   ((t (:slant normal))))
 `(font-lock-doc-face
   ((t (:slant normal))))
 `(popup-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit linum
                    :height ,graphene-font-height))))
 `(popup-scroll-bar-foreground-face
   ((t (:background unspecified
                    :inherit region))))
 `(popup-scroll-bar-background-face
   ((t (:background unspecified
                    :inherit popup-face))))
 `(ac-completion-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit popup-face))))
 `(ac-candidate-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit linum
                    :height ,graphene-font-height))))
 `(ac-selection-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-variable-name-face
                    :inverse-video t))))
 `(ac-candidate-mouse-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit region))))
 `(ac-dabbrev-menu-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit popup-face))))
 `(ac-dabbrev-selection-face
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit ac-selection-face))))
 `(flymake-warnline
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-preprocessor-face))))
 `(web-mode-symbol-face
   ((t (:foreground unspecified
                    :inherit font-lock-constant-face))))
 `(web-mode-builtin-face
   ((t (:foreground unspecified
                    :inherit default))))
 `(web-mode-doctype-face
   ((t (:foreground unspecified
                    :inherit font-lock-comment-face))))
 `(web-mode-html-tag-face
   ((t (:foreground unspecified
                    :inherit font-lock-function-name-face))))
 `(web-mode-html-attr-name-face
   ((t (:foreground unspecified
                    :inherit font-lock-variable-name-face))))
 `(web-mode-html-param-name-face
   ((t (:foreground unspecified
                    :inherit font-lock-constant-face))))
 `(web-mode-whitespace-face
   ((t (:foreground unspecified
                    :inherit whitespace-space))))
 `(web-mode-block-face
   ((t (:foreground unspecified
                    :inherit highlight))))
 `(sp-show-pair-match-face
   ((t (:foreground unspecified
                    :background unspecified
                    :inherit show-paren-match))))
 `(sp-show-pair-mismatch-face
   ((t (:foreground unspecified
                    :background unspecified
                    :inherit show-paren-mismatch))))
 `(vr/match-0
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-regexp-grouping-construct
                    :inverse-video t))))
 `(vr/match-1
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-regexp-grouping-backslash
                    :inverse-video t))))
 `(vr/group-0
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-keyword-face
                    :inverse-video t))))
 `(vr/group-1
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-function-name-face
                    :inverse-video t))))
 `(vr/group-2
   ((t (:background unspecified
                    :foreground unspecified
                    :inherit font-lock-constant-face
                    :inverse-video t))))
 `(whitespace-space
   ((t (:foreground unspecified
                    :background unspecified
                    :inherit highlight)))))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide 'init-graphene-small)
