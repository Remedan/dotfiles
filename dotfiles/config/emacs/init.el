;; Base config

;; Disable GUI
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Disable bell
(setq ring-bell-function 'ignore)

;; Enable line numbers and showing trailing whitespace in prog mode
(defun setup-prog-mode ()
  (display-line-numbers-mode 1)
  (setq show-trailing-whitespace t))
(add-hook 'prog-mode-hook 'setup-prog-mode)

;; Enable column indicator
(setq column-number-mode t)

;; Always show mathing parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Use 4 spaces for indentation
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 120 4))
(setq tab-width 4)

;; Set scratch buffer to Org Mode and disable message
(setq initial-major-mode 'org-mode)
(setq initial-scratch-message nil)

;; Backups
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory)))
      backup-by-copying t)

;; Autosave
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "autosave" user-emacs-directory) t)))

;; Separate config for customize
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Extra config
(let ((extra-file (expand-file-name "extra.el" user-emacs-directory)))
  (when (file-exists-p extra-file)
    (load extra-file)))

;; Org
(setq org-agenda-files (list "~/Documents/Org")
      org-startup-indented t
      org-pretty-entities t
      org-hide-emphasis-markers t
      org-startup-with-inline-images t
      org-image-actual-width '(300))

;; Flyspell
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

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
  (evil-set-undo-system 'undo-tree)
  (evil-set-initial-state 'term-mode 'emacs))

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
                          (recents . 10))
        initial-buffer-choice (lambda () (get-buffer "*dashboard*")))) ;; For emacsclient

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
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)
        neo-window-fixed-size nil))

;; Helm
(use-package helm
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode 1))

;; Projectile
(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; Helm-Projectile integration
(use-package helm-projectile)

;; Ripgrep
(use-package ripgrep)

;; Magit
(use-package magit)

;; GitGutter
(use-package git-gutter
  :config (global-git-gutter-mode +1))

;; Company
(use-package company
  :config (global-company-mode))

;; Company-Posframe
(use-package company-posframe
  :after company
  :init (company-posframe-mode))

;; Flycheck
(use-package flycheck
  :init (global-flycheck-mode))

;; Which Key
(use-package which-key
  :config (which-key-mode))

;; Tree-sitter
(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; Mixed Pitch
(use-package mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode)
  :config
  (set-face-attribute 'default nil :family "Source Code Pro" :height 110)
  (set-face-attribute 'fixed-pitch nil :family "Source Code Pro")
  (set-face-attribute 'variable-pitch nil :family "Source Sans Pro"))

;; Org Appear
(use-package org-appear
  :hook (org-mode . org-appear-mode))

;; Org Superstar
(use-package org-superstar
  :config
  (setq org-superstar-special-todo-items t)
  (add-hook 'org-mode-hook (lambda ()
                             (org-superstar-mode 1))))

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; Vterm
(use-package vterm)

;; Kubernetes
(use-package kubel
  :after vterm
  :config (kubel-vterm-setup))
(use-package kubel-evil
  :after kubel)

;; Vdiff
(use-package vdiff
  :config
  (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map))

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

;; SLIME
(use-package slime
  :config
  (setq inferior-lisp-program "clisp"))

;; Rust
(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package flycheck-rust
  :hook (flycheck-mode . flycheck-rust-setup))

{%@@ if profile == "atuin" @@%}
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

;; Haskell
(use-package haskell-mode)
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)
(add-to-list 'exec-path "~/.ghcup/bin")

;; YAML
(use-package yaml-mode
  :hook (yaml-mode . (lambda ()
                       (setup-prog-mode)
                       (mixed-pitch-mode 0))))

;; Dockerfile
(use-package dockerfile-mode)

;; Terraform
(use-package terraform-mode)

;; TypeScript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (typescript-mode . setup-tide-mode)))

;; HTML/CSS/JS
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.ts[x]?\\'" . web-mode))
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                (setup-tide-mode))))
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "jsx" (file-name-extension buffer-file-name))
                (setup-tide-mode))))
  (flycheck-add-mode 'javascript-eslint 'web-mode))

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")
