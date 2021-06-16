;; Base config

;; Disable GUI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable bell
(setq ring-bell-function 'ignore)

;; Enable line numbers
(global-linum-mode t)

;; Always show mathing parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Backups
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "/backup")))
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
{%@@ if colorscheme == "gruvbox-dark" @@%}
(use-package gruvbox-theme
  :config (load-theme 'gruvbox-dark-medium t))
{%@@ elif colorscheme == "dracula" @@%}
(use-package dracula-theme
  :config (load-theme 'dracula t))
{%@@ elif colorscheme == "nord" @@%}
(use-package nord-theme
  :config (load-theme 'nord t))
{%@@ else @@%}
(use-package solarized-theme
  :config (load-theme 'solarized-dark t))
{%@@ endif @@%}

;; Undo Tree
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-diff t
	undo-tree-auto-save-history t
	undo-tree-history-directory-alist
	`(("." . ,(concat user-emacs-directory "/undo")))))

;; EVIL Mode
(use-package evil
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

;; Dasboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner
	(concat user-emacs-directory "/sakamoto.png")))
