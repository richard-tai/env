;; Enable evil

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq evil-want-C-i-jump t)
(setq evil-want-C-u-scroll t)

(setq evil-toggle-key "")	; remove default evil-toggle-key C-z, manually setup later
(setq evil-want-C-i-jump nil)	; don't bind [tab] to evil-jump-forward
(add-to-list 'load-path "~/.emacs.d/undo-tree")
(require 'undo-tree)
(global-undo-tree-mode)
(add-to-list 'load-path "~/.emacs.d/goto-chg")
(require 'goto-chg)
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; remove all keybindings from insert-state keymap, use emacs-state when editing
(setcdr evil-insert-state-map nil)
    
;; ESC to switch back normal-state
(define-key evil-insert-state-map [escape] 'evil-normal-state)
    
;; TAB to indent in normal-state
(define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)
    
;; Use j/k to move one visual line insted of gj/gk
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

;; using theme
(load-theme 'tsdh-dark t)

;; company
(add-hook 'after-init-hook 'global-company-mode)


;; rtags
(load-file "~/github/rtags/src/rtags.el")
(add-to-list 'load-path "~/.emacs.d/rtags/src")
(require 'rtags)

(define-key c-mode-map (kbd "M-]") 'rtags-find-symbol-at-point)
(define-key c++-mode-map (kbd "M-]") 'rtags-find-symbol-at-point)

(global-set-key (kbd "M-o") 'rtags-location-stack-back)
(global-set-key (kbd "M-i") 'rtags-location-stack-forward)

(define-key c-mode-map (kbd "C-c C-s") 'rtags-find-symbol)
(define-key c++-mode-map (kbd "C-c C-s") 'rtags-find-symbol)

(define-key c-mode-map (kbd "C-c C-t") 'rtags-taglist)
(define-key c++-mode-map (kbd "C-c C-t") 'rtags-taglist)

(define-key c-mode-map (kbd "C-c C-f") 'rtags-find-file)
(define-key c++-mode-map (kbd "C-c C-f") 'rtags-find-file)

(define-key c-mode-map (kbd "C-c C-r") 'rtags-find-references-at-point)
(define-key c++-mode-map (kbd "C-c C-r") 'rtags-find-references-at-point)


;; neotree
(add-to-list 'load-path "~/.emacs.d/neotree")
(require 'neotree)
(global-set-key (kbd "C-c C-m") 'neotree-toggle)

;;; replace-string case-sensitive
(defadvice replace-string (around turn-off-case-fold-search)
  (let ((case-fold-search nil))
    ad-do-it))
(ad-activate 'replace-string)


;; treat "_" as a word character
(modify-syntax-entry ?_ "w")
(add-hook 'c-mode-common-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'c++-mode-common-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; always show line numbers 
(global-linum-mode 1)
;; (setq linum-format 'dynamic)  ;set format
(defadvice linum-update-window (around linum-dynamic activate)
    (let* ((w (length (number-to-string
        (count-lines (point-min) (point-max)))))
     (linum-format (concat "%" (number-to-string w) "d ")))
    ad-do-it))
;; show column
(setq column-number-mode t)

