
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

(load-file "~/data/github/rtags/src/rtags.el")

;(add-to-list 'load-path "~/.emacs.d/elpa/helm")
;(require 'helm-config)

;;;; rtags
(defun my-rtags-load-compile-commands-command ()
  "rtags load compile_commands.json command"
  ;; compile_commands.json generate by https://github.com/vincent-picaud/Bazel_and_CompileCommands
  ;; will refer source code from bazel's sandbox, must use "--project-root" to fix it.
  (let ((project-root default-directory)
        (tmp-project-root ""))
    (while (and project-root (not (file-exists-p (concat project-root "compile_commands.json"))))
      (setq tmp-project-root (file-name-directory (directory-file-name project-root)))
      (message "tmp-project-root: %s, project-root: %s" tmp-project-root project-root)
      (if (equal tmp-project-root project-root)
          (setq project-root nil)
        (setq project-root tmp-project-root)))
    (unless project-root
      (message "RTags: compile_commands.json not exists")
      (setq project-root default-directory))
    (message "RTags: %s" (concat project-root "compile_commands.json"))
    (format "rc -J %s --project-root %s" project-root project-root)))

(defun my-rtags-run ()
  "rtags startup with generated compile_commands.json"
  (interactive)
  (rtags-start-process-unless-running)
  (shell-command (my-rtags-load-compile-commands-command)))

(defun my-rtags-build ()
  "rtags startup use compile_commands.json generate from build tool"
  (interactive)
  (cond ((file-exists-p "BUILD") (my-rtags-bazel))
        ((file-exists-p "CMakeLists.txt") (my-rtags-cmake))
        ((file-exists-p "Makefile") (my-rtags-make))
        (t (error "No build tool detected"))))

(defun my-rtags-bazel ()
  "rtags startup use compile_commands.json generate from bazel"
  (interactive)
  (let ((tool_dir "~/Opensource/Bazel_and_CompileCommands")
        (command ""))
    (setq command (format "%s/setup_compile_commands.sh; %s/create_compile_commands.sh //..." tool_dir tool_dir))
    (setq command (read-string "Build bazel compile_commands.json: " command nil nil))
    (unless command
      (error "Build compile_commands.json for bazel failed"))
    (rtags-start-process-unless-running)
    (async-shell-command (concat command " && " (my-rtags-load-compile-commands-command)))))

(defun my-rtags-make ()
  "build compile_commands.json for make"
  (interactive)
  (let ((command (read-string "Build make compile_commands.json: " "bear make" nil nil)))
    (unless command
      (error "Build compile_commands.json for make failed"))
    (rtags-start-process-unless-running)
    (async-shell-command (concat command " && " (my-rtags-load-compile-commands-command)))))

(defun my-rtags-cmake ()
  "build compile_commands.json for cmake"
  (interactive)
  (let ((command (read-string "Build cmake compile_commands.json: " "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ." nil nil)))
    (rtags-start-process-unless-running)
    (async-shell-command (concat command " && " (my-rtags-load-compile-commands-command)))))

(setq rtags-completions-enabled t)
(eval-after-load 'company
  '(add-to-list
    'company-backends 'company-rtags))
(setq rtags-autostart-diagnostics t)
;(rtags-enable-standard-keybindings)
;(require 'helm-rtags)
;(require 'flycheck-rtags)
(define-key c-mode-map (kbd "C-c C-j") 'rtags-find-symbol)
(define-key c++-mode-map (kbd "C-c C-j") 'rtags-find-symbol)

(define-key c-mode-map (kbd "C-c C-k") 'rtags-find-symbol-at-point)
(define-key c++-mode-map (kbd "C-c C-k") 'rtags-find-symbol-at-point)

(define-key c-mode-map (kbd "C-c C-b") 'rtags-location-stack-back)
(define-key c++-mode-map (kbd "C-c C-b") 'rtags-location-stack-back)

(define-key c-mode-map (kbd "C-c C-r") 'rtags-find-references)
(define-key c++-mode-map (kbd "C-c C-r") 'rtags-find-references)
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

;;; jump history back & forword
(defun marker-is-point-p (marker)
  "test if marker is current point"
  (and (eq (marker-buffer marker) (current-buffer))
       (= (marker-position marker) (point))))

(defun push-mark-maybe () 
  "push mark onto `global-mark-ring' if mark head or tail is not current location"
  (if (not global-mark-ring) (error "global-mark-ring empty")
    (unless (or (marker-is-point-p (car global-mark-ring))
                (marker-is-point-p (car (reverse global-mark-ring))))
      (push-mark))))


(defun backward-global-mark () 
  "use `pop-global-mark', pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark))

(defun forward-global-mark ()
  "hack `pop-global-mark' to go in reverse, pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (setq global-mark-ring (nreverse global-mark-ring))
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark)
  (setq global-mark-ring (nreverse global-mark-ring)))

(global-set-key (kbd "M-o") 'backward-global-mark)
(global-set-key (kbd "M-i") 'forward-global-mark)
;(global-set-key [M-left] (quote backward-global-mark))
;(global-set-key [M-right] (quote forward-global-mark))
