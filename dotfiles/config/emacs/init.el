;; Base config

;; Disable GUI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable bell
(setq ring-bell-function 'ignore)

;; Enable line numbers
(global-linum-mode t)

;; Enable column indicator
(setq column-number-mode t)

;; Always show mathing parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Backups
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory))) ;
      backup-by-copying t)

;; Packages

;; Add the MELPA package repository
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Set up use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; Theme
(use-package doom-themes
  :ensure t
  :config
{%@@ if colorscheme == "gruvbox-dark" @@%}
  (load-theme 'doom-gruvbox t)
{%@@ else @@%}
  (load-theme 'doom-{{@@ colorscheme @@}} t)
{%@@ endif @@%}
  (doom-themes-neotree-config))

;; Undo Tree
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-diff t
	undo-tree-auto-save-history t
	undo-tree-history-directory-alist
	`(("." . ,(expand-file-name "undo" user-emacs-directory)))))

;; EVIL Mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil) ;; Needed for evil-collection
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; All the Icons
(use-package all-the-icons)

;; Dasboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner
	(expand-file-name "sakamoto.png" user-emacs-directory)
	dashboard-center-content t
	dashboard-set-heading-icons t
	dashboard-set-file-icons t))

;; Doom Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Solaire Mode
(use-package solaire-mode
  :config (solaire-global-mode +1))

;; Neotree
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; Multi Term
(use-package multi-term)
