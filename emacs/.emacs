
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(global-linum-mode 1) ; always show line numbers 
(setq linum-format "%d| ")  ;set format
(define-key global-map "\C-c\C-g" "goto-line")

;(require 'window-numbering)
;(window-numbering-mode 1)

(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(load-file "~/data/github/rtags/src/rtags.el")


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


;;git clone https://github.com/jaypei/emacs-neotree.git ~/.emacs.d/neotree
(load-file "~/.emacs.d/neotree/neotree.el")
(global-set-key (kbd "C-c C-m") 'neotree-toggle)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)

;;; replace-string case-sensitive
(defadvice replace-string (around turn-off-case-fold-search)
  (let ((case-fold-search nil))
    ad-do-it))
(ad-activate 'replace-string)
