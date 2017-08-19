;;; Smacs Config

;;;; Basic Initialization
(package-initialize)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;; TODO: Move to private.
(require 'google)

;;;; Some Sane defaults.
(setq delete-old-versions -1 )          ; delete excess backup versions silently
(setq version-control t )               ; use version control
(setq vc-make-backup-files t )          ; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq vc-follow-symlinks t )                                   ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
(setq inhibit-startup-screen t )        ; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore )      ; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8 )   ; use utf-8 by default
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil)    ; sentence SHOULD end with only a point.
(setq default-fill-column 80)           ; toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome to Emacs") ; print a default message in the empty scratch buffer opened at startup
(setq use-package-always-ensure t)      ; Always install packages.


;;;; Install packages

;;;;; Evil and associated packages for vim bindings.

(use-package evil
  :init (evil-mode 1))

(use-package evil-magit
  :defer t)


;;;;; General for spacemacs-like leader shortcuts.
(use-package general
  :config
  (general-evil-setup t)

  ;; bind in motion state (inherited by the normal, visual, and operator states)
  (general-mmap "j" 'evil-next-visual-line
                "k" 'evil-previous-visual-line)

  (general-define-key
   :states '(normal motion emacs)
   :prefix "SPC"
   "SPC" '(counsel-M-x)

   ;; Files
   "f"   '(:ignore t :which-key "Files")
   "ff"  '(counsel-find-file)
   "fr"  '(counsel-recentf)
   "fg"  '(counsel-git)
   "f."  '(smacs/edit-init-file)

   ;; Git
   "g"  '(:ignore t :which-key "Git")
   "gs" '(magit-status :which-key "git status")
   )
)

;;;;; which-key to remember keybindings.
(use-package which-key
  :init (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-side-window-max-width 0.33
        which-key-idle-delay 0.05)
  :diminish which-key-mode)

;;;;; Ivy and Counsel for fuzzy matching things.
(use-package ivy
  :diminish (ivy-mode . "") ; does not display ivy in the modeline
  :init (ivy-mode 1)        ; enable ivy globally at startup
  :bind (:map ivy-mode-map  ; bind in the ivy buffer
              ("C-'" . ivy-avy)
              ("C-j" . ivy-next-line)
              ("C-k" . ivy-previous-line)
              )
  :config
  (setq ivy-use-virtual-buffers t)   ; extend searching to bookmarks and …
  (setq ivy-height 20)               ; set height of the ivy window
  (setq ivy-count-format "(%d/%d) ") ; count format, from the ivy help page
  )

(use-package counsel
  :bind*                           ; load counsel when pressed
  (("M-x"     . counsel-M-x)       ; M-x use counsel
   ("C-x C-f" . counsel-find-file) ; C-x C-f use counsel-find-file
   ("C-x C-r" . counsel-recentf)   ; search recently edited files
   ("C-c f"   . counsel-git)       ; search for files in git repo
   ("C-c s"   . counsel-git-grep)  ; search for regexp in git repo
   ("C-c /"   . counsel-ag)        ; search for regexp in git repo using ag
   ("C-c l"   . counsel-locate))   ; search for files or else using locate
  )


;;;;; Company for auto-complete.

(use-package company
  :diminish ""
  :commands global-company-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq
   company-idle-delay 0.1
   company-selection-wrap-around t
   company-minimum-prefix-length 2
   company-require-match nil
   company-dabbrev-ignore-case nil
   company-dabbrev-downcase nil
   company-show-numbers t)

  :config
  (global-company-mode)

  ;; from https://github.com/syl20bnr/spacemacs/blob/master/layers/auto-completion/packages.el
  (setq hippie-expand-try-functions-list
        '(
          ;; Try to expand word "dynamically", searching the current buffer.
          try-expand-dabbrev
          ;; Try to expand word "dynamically", searching all other buffers.
          try-expand-dabbrev-all-buffers
          ;; Try to expand word "dynamically", searching the kill ring.
          try-expand-dabbrev-from-kill
          ;; Try to complete text as a file name, as many characters as unique.
          try-complete-file-name-partially
          ;; Try to complete text as a file name.
          try-complete-file-name
          ;; Try to expand word before point according to all abbrev tables.
          try-expand-all-abbrevs
          ;; Try to complete the current line to an entire line in the buffer.
          try-expand-list
          ;; Try to complete the current line to an entire line in the buffer.
          try-expand-line
          ;; Try to complete as an Emacs Lisp symbol, as many characters as
          ;; unique.
          try-complete-lisp-symbol-partially
          ;; Try to complete word as an Emacs Lisp symbol.
          try-complete-lisp-symbol))
)


;;;;; Outshine for code folding.
(use-package outshine
  :ensure t
  :diminish outline-minor-mode
  :init
  (add-hook 'outline-minor-mode-hook 'outshine-hook-function)
  (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f89b15728948b1ea5757a09c3fe56882c2478844062e1033a29ffbd2ed0e0275" "12e2aee98f651031d10fd58af76250fa8cab6f28b3e88f03b88b7524c9278549" default)))
 '(org-src-fontify-natively t)
 '(package-selected-packages
   (quote
    (doom-themes use-package-chords which-key use-package evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;; Doom Themes
(use-package doom-themes
  :ensure t
  :defer t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme
  (doom-themes-neotree-config)  ; all-the-icons fonts must be installed!

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;;; Custom Functions

;;;; Edit init file.
(defun smacs/edit-init-file ()
  "Edit the `user-init-file'"
  (interactive)
  (find-file user-init-file))


;;; Setup environment.
(load-theme 'doom-one)
