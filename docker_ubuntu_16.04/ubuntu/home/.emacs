;; Enable evil

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)


(setq evil-toggle-key "")	; remove default evil-toggle-key C-z, manually setup later
(setq evil-want-C-u-scroll t)
;(setq evil-want-C-i-jump nil)	; don't bind [tab] to evil-jump-forward
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
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)

(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)


;; https://www.reddit.com/r/emacs/comments/80yna2/evil_how_to_have_ci_behave_like_in_vim/
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))

(defun my-translate-C-i (_prompt)
  (if (and (= (length (this-single-command-raw-keys)) 1)
           (eql (aref (this-single-command-raw-keys) 0) ?\C-i)
           (bound-and-true-p evil-mode)
           (eq evil-state 'normal))
      (kbd "<C-i>")
    (kbd "TAB")))

(define-key key-translation-map (kbd "TAB") 'my-translate-C-i)

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "<C-i>") 'evil-jump-forward))


;; using theme
(load-theme 'tsdh-dark t)

;; company https://company-mode.github.io/
(add-to-list 'load-path "~/.emacs.d/company")
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-show-numbers t)
(setq company-idle-delay 0.2)
(setq company-minimum-prefix-length 1)

;; readonly default
(add-hook 'find-file-hook (lambda () (setq buffer-read-only t)))

;; rtags
(add-to-list 'load-path "~/.emacs.d/rtags/src")
(require 'rtags)


(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)


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

(define-key c-mode-map (kbd "C-c C-h") 'rtags-print-class-hierarchy)
(define-key c++-mode-map (kbd "C-c C-h") 'rtags-print-class-hierarchy) 

(define-key c-mode-map (kbd "C-c C-v") 'rtags-find-virtuals-at-point)
(define-key c++-mode-map (kbd "C-c C-v") 'rtags-find-virtuals-at-point)


(add-to-list 'load-path "~/.emacs.d/buffer-move")
(require 'buffer-move)
(global-set-key (kbd "C-c <up>")     'buf-move-up)
(global-set-key (kbd "C-c <down>")   'buf-move-down)
(global-set-key (kbd "C-c <left>")   'buf-move-left)
(global-set-key (kbd "C-c <right>")  'buf-move-right) 

;; show full path of current file
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))
(global-set-key (kbd "C-c C-y") 'show-file-name)

;; neotree
(add-to-list 'load-path "~/.emacs.d/neotree")
(require 'neotree)
(global-set-key (kbd "C-c C-m") 'neotree-toggle)

;; replace-string case-sensitive
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


(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)


(defvar my-keys-minor-mode-map (make-sparse-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map (kbd "C-c C-p")   'project-find-file)
(define-key my-keys-minor-mode-map (kbd "C-c C-e")   'project-find-regexp)
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t :lighter "")
(my-keys-minor-mode 1)

(setq-default auto-save-timeout 15) ; 15秒无动作,自动保存
(setq-default auto-save-interval 100) ; 100个字符间隔, 自动保存
(setq make-backup-files nil)

(defun split-right-and-buffer-list ()
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (electric-buffer-list nil))
(global-set-key (kbd "C-x C-b") 'split-right-and-buffer-list)

;; highlight persist
(add-to-list 'load-path "~/.emacs.d/highlight")                                                                                                                                                                     
(add-to-list 'load-path "~/.emacs.d/evil-search-highlight-persist")
(require 'highlight)
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (org helm company-ebdb))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
