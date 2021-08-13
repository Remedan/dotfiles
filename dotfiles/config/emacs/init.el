;; Base config

;; Disable GUI
(tool-bar-mode -1)
;; (menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable bell
(setq ring-bell-function 'ignore)

;; Font
(add-to-list 'default-frame-alist
             '(font . "Iosevka Term-11"))

;; Enable line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Enable column indicator
(setq column-number-mode t)

;; Always show mathing parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; Use 4 spaces for indentation
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 120 4))
(setq tab-width 2)

;; Set scratch buffer to Org Mode and disable message
(setq initial-major-mode 'org-mode)
(setq initial-scratch-message nil)

;; Backups
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory))) ;
      backup-by-copying t)

;; Separate config for customize
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Key mapping
(global-set-key "\C-c\C-j" 'previous-buffer)
(global-set-key "\C-c\C-k" 'next-buffer)

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
  :init
  (setq evil-want-keybinding nil ;; Needed for evil-collection
        evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; All the Icons
(use-package all-the-icons)

;; Dasboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner
        (expand-file-name "sakamoto.png" user-emacs-directory)
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((projects . 10)
                          (recents . 10))))

;; Doom Modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Solaire Mode
(use-package solaire-mode
  :config (solaire-global-mode +1))

;; Neotree
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; Helm
(use-package helm
  :config
  (helm-mode 1))

;; Projectile
(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; Helm-Projectile integration
(use-package helm-projectile)

;; Magit
(use-package magit)

;; GitGutter
(use-package git-gutter
  :config (global-git-gutter-mode +1))

;; Multi Term
(use-package multi-term)

;; Company
(use-package company
  :config (global-company-mode))

;; Flycheck
(use-package flycheck
  :init (global-flycheck-mode))

;; Which Key
(use-package which-key
  :config (which-key-mode))

;; Language-specific

;; LSP
(setq lsp-keymap-prefix "C-c l")
(use-package lsp-mode
  :hook (python-mode . lsp)
  :config
  (setq lsp-signature-auto-activate nil
        lsp-ui-doc-enable nil)

  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)))
  :commands lsp)

(use-package lsp-ui
  :commands ls-ui-mode)

(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)

;; Rust
(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package flycheck-rust
  :hook (flycheck-mode . flycheck-rust-setup))

{%@@ if profile == "dev-pc-28" @@%}
;; Python
(add-hook 'python-mode-hook
          (lambda()
            (setq indent-tabs-mode t
                  tab-width 4
                  python-indent-guess-indent-offset nil)))
{%@@ endif @@%}

;; Clojure
(use-package clojure-mode
  :hook ((clojure-mode . lsp)
         (clojurescript-mode . lsp)
         (clojurec-mode . lsp)))
(use-package cider)
(use-package flycheck-joker)
