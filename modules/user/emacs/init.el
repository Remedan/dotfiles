;;
;; Base config
;;

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

;; Always highlight matching parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Show keyboard shortcut hints
(setq which-key-idle-delay 0.0)
(which-key-mode 1)

;; Use 4 spaces for indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; Always insert the final newline (for posix compliance)
(setq require-final-newline t)

;; Set scratch buffer to Org Mode and disable message
(setq initial-major-mode 'org-mode)
(setq initial-scratch-message nil)

;; Change backup and autosave location
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory)))
      backup-by-copying t)
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "autosave" user-emacs-directory) t)))

;; Separate config for customize
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

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

;;
;; Packages
;;

;; Set up straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Set up use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Themes
;; The theme is set in default.el which is managed by home-manager
(use-package doom-themes)
(use-package catppuccin-theme)
(load-theme (intern
             (pcase colorscheme
               ("selenized-dark" "doom-solarized-dark")
               ("gruvbox-dark" "doom-gruvbox")
               ("dracula" "doom-dracula")
               (_ colorscheme)))
            :no-confirm)

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

;; Icons
(use-package nerd-icons)

;; Dasboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  :init
  (setq dashboard-startup-banner
        (expand-file-name "sakamoto.png" user-emacs-directory)
        dashboard-center-content t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-projects-backend 'projectile
        dashboard-items '((projects . 10)
                          (recents . 10))
        initial-buffer-choice (lambda () (get-buffer "*dashboard*")))) ;; For emacsclient

;; Doom Modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Solaire Mode
(use-package solaire-mode
  :config (solaire-global-mode +1))

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
  :config
  (setq org-appear-trigger 'manual)
  :hook
  (org-mode . org-appear-mode)
  (org-mode . (lambda ()
                (add-hook 'evil-insert-state-entry-hook
                          #'org-appear-manual-start
                          nil
                          t)
                (add-hook 'evil-insert-state-exit-hook
                          #'org-appear-manual-stop
                          nil
                          t))))

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

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

;; Ranger
(use-package ranger
  :config (setq ranger-show-literal nil))

;; direnv
(use-package direnv
  :config (direnv-mode))

;; Nyan Mode
(use-package nyan-mode)

;; Jupyter
(use-package ein)

;; Treemacs
(use-package treemacs
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-c t 1"   . treemacs-delete-other-windows)
        ("C-c t t"   . treemacs)
        ("C-c t p"   . treemacs-add-and-display-current-project-exclusively)
        ("C-c t d"   . treemacs-select-directory)
        ("C-c t B"   . treemacs-bookmark)
        ("C-c t C-t" . treemacs-find-file)
        ("C-c t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-magit
  :after (treemacs magit))

;; EditorConfig
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; LLM Integration
(use-package gptel
  :config
  (setq
   gptel-default-mode #'markdown-mode
   gptel-model "llama3.1:8b"
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '("llama3.1:8b"))))

;;
;; Language-specific
;;

;; LSP
(use-package lsp-mode
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-signature-auto-activate nil
        lsp-ui-doc-enable nil)
  :commands lsp)

(use-package lsp-ui
  :commands ls-ui-mode)

(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)

;; Python
(add-hook 'python-mode-hook #'lsp)
(use-package poetry)

;; SLIME
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

;; Rust
(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package flycheck-rust
  :hook (flycheck-mode . flycheck-rust-setup))

;; Clojure
(use-package clojure-mode
  :hook
  (clojure-mode . lsp)
  (clojurescript-mode . lsp)
  (clojurec-mode . lsp))
(use-package cider)
(use-package flycheck-joker)

;; Haskell
(use-package haskell-mode)
(use-package lsp-haskell
  :hook
  (haskell-mode . lsp)
  (haskell-literate-mode . lsp))

;; YAML
(use-package yaml-mode
  :hook
  (yaml-mode . (lambda ()
                 (setup-prog-mode)
                 (mixed-pitch-mode 0))))

;; Dockerfile
(use-package dockerfile-mode)

;; Terraform
(use-package terraform-mode)

;; HTML/CSS/JS
(add-hook 'mhtml-mode-hook (lambda () (mixed-pitch-mode 0)))

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;; Lua
(use-package lua-mode)
