;; Disable GUI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

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
(use-package solarized-theme
  :config (load-theme 'solarized-dark t))

;; EVIL Mode
(use-package evil
  :config (evil-mode 1))
