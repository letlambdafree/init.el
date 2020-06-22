;;; init.el --- initializing -*- lexical-binding: t; coding: utf-8 -*-

;;; Licence:

;;; Commentary:

;; one or three blank line (not two blank lines)
;;
;; comment as detail as possible for me later

;; (package-initialize)로 관리되는 패키지들은
;; 따로 require와 load-path를 지정 할 필요가 없어짐
;; 직접 수동 설치시에는 필요

;;; Code:

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives
               (cons "melpa"
                     (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives
               (cons "melpa-stable"
                     (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives
                 (cons "gnu"
                       (concat proto "://elpa.gnu.org/packages/")))))



(when (< emacs-major-version 27)
  (package-initialize))



;; some personal constant
(defconst pv-erc-user-full-name "Taeseong Ryu")
(defconst pv-erc-nick1 "ryutas")
(defconst pv-erc-nick2 "ryutas_")
(defconst pv-erc-nick3 "ryutas__")
(defconst pv-user-mail-address "formeu2s@gmail.com")



;; load some files
(load-file "~/.emacs.d/.init.d/private.el") ; private data, no public
;; (load-file "~/.emacs.d/.init.d/my_scratch.el")
;; (load-file "~/.emacs.d/.init.d/prelude_functions.el")
;; (load-file "~/.emacs.d/.init.d/run-current-file.el")



;; custom file load
;; (setq custom-file "~/.emacs.d/.init.d/custom.el") ; customizing file
;; (if (file-exists-p custom-file)
;;     (load custom-file))



;; Load theme
(add-hook 'emacs-startup-hook
          (lambda () (load-theme 'wheatgrass)))



;; kbd macro
(if (file-exists-p "~/.emacs.d/kmacro")
    (load-file "~/.emacs.d/kmacro"))



;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
;; (setq use-package-verbose t)
;; (setq use-package-compute-statistics t)
(require 'use-package-ensure)
(setq use-package-always-ensure t)
;; (setq use-package-always-defer t)
(eval-when-compile (require 'use-package))
(require 'diminish) ; if you use :diminish
(require 'bind-key) ; if you use :bind



;; emacs server
(require 'server)
(add-hook 'after-init-hook
          (lambda () (unless (server-running-p)
                       (server-start))))



;; init file
(defun byte-compile-init-file()
  "Auto 'user-init-file' byte compile."
  (when (equal buffer-file-name user-init-file)
    ;; save elc file without failing
    (if (file-exists-p (concat user-init-file "c"))
        (delete-file (concat user-init-file "c")))
    (byte-compile-file user-init-file t) ; t for reload
    (message "Just compiled %s " user-init-file)))

(add-hook 'after-save-hook 'byte-compile-init-file)



;; emacs-startup-hook
(add-hook 'emacs-startup-hook
          (lambda () (message
                      "Time needed to load: %s seconds."
                      (emacs-uptime "%s"))))



;; before-save-hook
(add-hook 'before-save-hook 'time-stamp)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook
          '(lambda () (untabify (point-min) (point-max))))
(add-hook
 'before-save-hook
 '(lambda ()
    (or (file-exists-p (file-name-directory buffer-file-name))
        (make-directory (file-name-directory buffer-file-name) t))))



;; shell
;; (setq binary-process-input t)
;; (setq w32-quote-process-args ?\")
(setq shell-file-name "zsh")
(setenv "SHELL" shell-file-name)



;; exe-path
(if (file-directory-p "~/.local/bin")
    (add-to-list 'exec-path "~/.local/bin"))

;; (setenv "PATH" (format "%s:%s" "~/.local/bin" (getenv "PATH")))



;; Make the dividing line between window splits less bright.
(set-face-attribute 'vertical-border nil :foreground "#000000")



;; (set-frame-parameter nil 'fullscreen 'fullboth)
;; frame
(setq default-frame-alist
      '(
        ;; (foreground-color . "LightCyan")
        ;; (background-color . "black")
        ;; (cursor-type . box)
        ;; (cursor-color . "green")
        (internal-border-width . 0)
        (border-width . 0)))



;; frame-title-format
(setq-default frame-title-format
              '(buffer-file-name
                "%[  %f  %z  %I  %] - Emacs"
                (dired-directory dired-directory
                                 "%[  %b  %z  %I  %] - Emacs")))



;; mode-line
(line-number-mode)
(column-number-mode)
;; (set-face-attribute 'mode-line nil
;;                     :foreground "DarkOrange"
;;                     :background "black"
;;                     :box nil)
(global-set-key (kbd "<mode-line><double-mouse-1>")
                'zygospore-toggle-delete-other-windows)


;; setup-minibuffer
(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode)



;; History variables
(setq history-delete-duplicates t)
(setq history-length 1500) ; default is 30.



;; region color
;; (set-face-foreground 'region "white")
;; (set-face-attribute 'region nil :foreground 'unspecified)
;; (set-face-attribute 'region nil :background 'unspecified)
;; (set-face-background 'region "gray25")
;; (set-face-foreground 'highlight "yellow")
;; (set-face-background 'secondary-selection "black")
;; (set-face-foreground 'secondary-selection "white")



;; whenever you create useless space,
;; the space is highlighted
(add-hook 'prog-mode-hook
          (lambda ()
            (interactive)
            (setq show-trailing-whitespace 1)))



;; bar-mode
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))



;; basic functions
(blink-cursor-mode -1)
(transient-mark-mode)
(global-font-lock-mode)
(global-hl-line-mode -1)
(global-linum-mode -1)
(global-auto-revert-mode)
(save-place-mode 1)
(subword-mode) ; CamelWord Meta-f
(size-indication-mode 1)
(fringe-mode '(1 . 1))
(desktop-save-mode)
(delete-selection-mode)
(auto-fill-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(normal-erase-is-backspace-mode) ; del key deletes at point



;; basic variables
(setq visible-bell t
      ;; mouse-drag-copy-region t ; automatically kill-ring
      save-interprogram-paste-before-kill t
      debug-on-error t ; Launch a debugger with a stactrace
      ;; debug-on-quit t ; quit with C-g for Emacs frozen
      ;; edebug-all-forms t
      ;; view-read-only t
      visible-bell t
      echo-keystrokes 0.1 ; 0 for which-key
      max-mini-window-height 0.25
      insert-default-directory t
      set-mark-command-repeat-pop t
      inhibit-startup-message t
      kill-buffer-query-functions nil
      delete-by-moving-to-trash nil
      tab-width 2
      fill-column 80
      indent-tabs-mode nil
      global-mark-ring-max 5000
      mark-ring-max 5000
      kill-ring-max 5000
      max-lisp-eval-depth 10000 ; default 500
      large-file-warning-threshold 100000000 ; 100M byte
      mode-require-final-newline t
      desktop-restore-eager 5 ; t is all buffer
      register-preview-delay nil)



;; display-buffer
(setq display-buffer-alist
      '((".*" (display-buffer-reuse-window display-buffer-same-window))
        (".*" . (nil . (reusable-frames 1)))))
(setq even-window-sizes nil)



;; temporarily fix
;; Fix slow helm frame popup in emacs-26 helm issue #1976
;; (when (= emacs-major-version 26)
;;   (setq x-wait-for-event-timeout nil))



;; Copy/paste
(setq select-active-regions t
      x-select-enable-clipboard-manager nil
      select-enable-clipboard t
      select-enable-primary nil)



;; mouse scrolling
(setq scroll-margin 0
      scroll-conservatively 100
      scroll-preserve-screen-position 1)
;; (setq mouse-autoselect-window t
;;       focus-follows-mouse t)
(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control))))



;; autosave and backup
(defconst my-backup-directory "~/.emacs.d/backup/")
(make-directory my-backup-directory 1)
(setq backup-directory-alist `((".*" . ,my-backup-directory))
      make-backup-files t
      backup-by-copying t
      delete-old-versions t
      version-control t
      vc-make-backup-files t
      kept-new-versions 1000
      kept-old-versions 1000
      auto-save-default t
      auto-save-interval 100
      auto-save-timeout 10
      auto-save-file-name-transforms `((".*" ,my-backup-directory t)))



;; savehist
(require 'savehist)
(savehist-mode)
(setq savehist-additional-variables
      '(search ring regexp-search-ring)) ; also regexp search queries
(setq savehist-autosave-interval 60) ; save every minute



;; winner-mode
(global-set-key (kbd "C-<left>") 'winner-undo)
(global-set-key (kbd "C-<right>") 'winner-redo)
(global-set-key (kbd "C-<mouse-8>") 'winner-undo)
(global-set-key (kbd "C-<mouse-9>") 'winner-redo)
(winner-mode)




;; key board / input method settings
(prefer-coding-system 'utf-8)
(setq default-input-method "korean-hangul")
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-language-environment "UTF-8") ; prefer utf-8 for language settings
(set-input-method nil) ; no funky input for normal editing;



;; ansi-term
(require 'term)
(defun jnm/term-toggle-mode ()
  "Toggle term between line-mode and char-mode."
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(defadvice ansi-term (before force-zsh activate)
  "Force 'ansi-term' to use zsh without prompt."
  (interactive (list "/usr/bin/zsh")))

(defadvice term-handle-exit
    (after term-kill-buffer-on-exit activate)
  "Killing the useless buffer after exiting."
  (kill-buffer))

(define-key term-mode-map (kbd "s-i") 'jnm/term-toggle-mode)
(define-key term-raw-map (kbd "s-i") 'jnm/term-toggle-mode)



;; fonts
;; noto-fonts-CJK ; not so good
;; adobe-source-han-sans-kr-fonts
;; adobe-source-han-sans-jp-fonts
;; adobe-source-han-sans-cn-fonts
;; adobe-source-han-serif-kr-fonts
;; adobe-source-han-serif-jp-fonts
;; adobe-source-han-serif-cn-fonts
;;
;; L10N="ko ja zh-CN" emerge -pv source-han-sans
;;
;; Menlo-10
;; Bitstream Vera Sans Mono-10
;; consolas-10
;; monospace-10
;; Use Liberation Mono for latin-3 charset.
;; (set-fontset-font "fontset-default" 'iso-8859-3
;;                   "Liberation Mono")
;; Prefer a big5 font for han characters.
;; (set-fontset-font "fontset-default"
;;                   'han (font-spec :registry "big5")
;;                   nil 'prepend)
;; Use DejaVu Sans Mono as a fallback in fontset-startup
;; before resorting to fontset-default.
;; (set-fontset-font "fontset-startup" nil "DejaVu Sans Mono"
;;                   nil 'append)
;; Use MyPrivateFont for the Unicode private use area.
;; (set-fontset-font "fontset-default"  '(#xe000 . #xf8ff)
;;                   "MyPrivateFont")
(add-to-list 'face-ignored-fonts "baekmuk")
;; (setq use-default-font-for-symbols nil)
(set-face-font 'default "menlo-10")



;; w32 input method
;; shift-space is space in terminal
(global-set-key (kbd "S-SPC") 'toggle-input-method) ; EN
(global-set-key (kbd "S-C-SPC") 'hangul-to-hanja-conversion)
(global-set-key (kbd "C-|") 'toggle-the-other-input-method)
(global-set-key (kbd "C-SPC") 'set-mark-command)
(global-set-key (kbd "S-<kana>") 'toggle-input-method) ; KO
(global-set-key (kbd "C-<kanji>") 'set-mark-command)



;; general Key binding
;; (global-set-key (kbd "s-h") 'windmove-left)
;; (global-set-key (kbd "s-j") 'windmove-down)
;; (global-set-key (kbd "s-k") 'windmove-up)
;; (global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; (global-set-key (kbd "M-n") (kbd "C-u 1 C-v")) ; example binding
(global-set-key [remap just-one-space] 'cycle-spacing)
(global-set-key (kbd "C-c C-e") 'execute-extended-command)
(global-set-key (kbd "<f12>") 'menu-bar-mode)
;; (global-set-key [mode-line mouse-1] 'scroll-up-command)
;; (global-set-key (kbd "C-x c") 'command-history)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x C-c C-c C-c C-c C-c") 'save-buffers-kill-emacs)
(global-unset-key (kbd "<ESC><ESC><ESC>"))
(global-set-key (kbd "<ESC><ESC><ESC><ESC><ESC>") 'keyboard-escape-quit)
(global-set-key (kbd "C-z") nil) ; Disable `suspend-frame'
;; (global-set-key (kbd "C-'") nil)
;; (define-key help-mode-map (kbd "C-c C-c") nil) ; conflict with sdcv key
;; (define-key help-mode-map (kbd "C-c C-c C-s") 'help-follow-symbol)

;; C-h to backspace
(define-key key-translation-map [?\C-h] [?\C-?])

;; (push ?\C-h exwm-input-prefix-keys)
;; (exwm-input-set-simulation-keys '(([?\C-?] . backspace)))



;; super key binding
;; (setq w32-pass-lwindow-to-system nil)
;; (setq w32-lwindow-modifier 'super) ; Left Windows key
;; (setq w32-pass-rwindow-to-system nil)
;; (setq w32-rwindow-modifier 'super) ; Right Windows key



;; hyper key binding
;; (setq w32-pass-apps-to-system nil)
;; (setq w32-apps-modifier 'hyper) ; Menu/App key
;; (setq ns-function-modifier nil)
;; (setq ns-function-modifier 'hyper) ; no works
;; (global-set-key (kbd "H-q") 'other-window)



;; switch buffer
;; do not switch to a buffer shown on the frame
(setq switch-to-prev-buffer-skip 'this)

(defvar my-skippable-buffers '("*Messages*" "*Help*" "*Compile-Log*"
                               "*Backtrace*")
  "Buffer names ignored by `my-next-buffer' and `my-previous-buffer'.")

(defun my-change-buffer (change-buffer)
  "Call CHANGE-BUFFER until current buffer is not in `my-skippable-buffers'."
  (let ((initial (current-buffer)))
    (funcall change-buffer)
    (let ((first-change (current-buffer)))
      (catch 'loop
        (while (or (member (buffer-name) my-skippable-buffers)
                   (string= "helm-major-mode" major-mode)
                   (string= "exwm-mode" major-mode))
          (funcall change-buffer)
          (when (eq (current-buffer) first-change)
            (switch-to-buffer initial)
            (throw 'loop t)))))))

(defun my-previous-buffer ()
  "Variant of `previous-buffer' that skips `my-skippable-buffers'."
  (interactive)
  (my-change-buffer 'previous-buffer))

(defun my-next-buffer ()
  "Variant of `next-buffer' that skips `my-skippable-buffers'."
  (interactive)
  (my-change-buffer 'next-buffer))

(global-set-key [remap previous-buffer] 'my-previous-buffer)
(global-set-key [remap next-buffer] 'my-next-buffer)

(global-set-key [mouse-8] 'previous-buffer)
(global-set-key [mouse-9] 'next-buffer)
;; (global-set-key (kbd "<C-tab>") 'next-buffer)
;; (global-set-key (kbd "<S-C-tab>") 'previous-buffer)
;; (global-set-key (kbd "<C-iso-tab>") 'previous-buffer)



;; ido-mode
;; (ido-mode 1)
;; (require 'ido)
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)
;; (setq ido-everywhere t)
;; (setq ido-enable-prefix nil)
;; (setq ido-create-new-buffer 'always)
;; (setq ido-use-filename-at-point 'guess)
;; (setq ido-max-prospects 10)
;; (setq ido-default-file-method 'selected-window)
;; (setq ido-auto-merge-work-directories-length -1)



;; wrap
(setq-default word-wrap nil)
(setq-default truncate-lines nil)
(setq-default global-visual-line-mode nil)



;; go-to-address-mode
(add-hook 'prog-mode-hook 'goto-address-mode)
(add-hook 'text-mode-hook 'goto-address-mode)



;; ispell
(require 'ispell)
(if (executable-find "aspell")
    (progn
      (setq ispell-program-name "aspell")
      (setq ispell-extra-args '("--sug-mode=ultra")))
  (setq ispell-program-name "ispell"))
(setq ispell-dictionary "english") ; aspell-en
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)



;; remember
(define-key global-map (kbd "C-c r") 'remember)
;; (define-key global-map (kbd "C-c C-r") 'remember-region)



;; register
(set-register ?i '(file . "~/.emacs.d/init.el"))
(set-register ?n '(file . "~/.notes"))
(set-register ?d '(file . "~/diary"))
(set-register ?k '(file . "~/.emacs.d/kmacro"))



;; Ediff
(require 'ediff)
(setq ediff-diff-options "-w"
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)
;; exwm workaround
;; if you prefer your *Ediff Control Panel* as a floating frame,
;; rather than as an Emacs window
;; (with-eval-after-load 'ediff-wind
;;   (setq ediff-control-frame-parameters
;;         (cons '(unsplittable . t) ediff-control-frame-parameters)))



;; eldoc
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)



;; Start garbage collection every 100MB to improve Emacs performance
(setq gc-cons-threshold 100000000)


;; hs-minor-mod
(add-hook 'c-mode-common-hook   'hs-minor-mode)



;; calendar
(require 'calendar)
(setq calendar-week-start-day 0)
(setq mark-holidays-in-calendar t)
(defconst calendar-korean-holidays
  '((holiday-fixed 1 1 "신정")
    (holiday-fixed 3 1 "삼일절")
    (holiday-fixed 5 5 "어린이날")
    (holiday-fixed 6 6 "현충일")
    (holiday-fixed 8 15 "광복절")
    (holiday-fixed 10 3 "개천절")
    (holiday-fixed 10 9 "한글날")
    (holiday-fixed 12 4 "내생일")
    (holiday-fixed 12 25 "성탄절"))
  "Pre-define Korean public holidays.")
(setq calendar-holidays
      (append calendar-korean-holidays holiday-local-holidays))
(setq calendar-latitude +37.34)
(setq calendar-longitude +127.59)
(setq calendar-location-name "서울")



;; erc
(require 'erc)
(setq erc-server "irc.freenode.net")
(setq erc-port 6667)
(setq erc-nick pv-erc-nick1)
(setq erc-user-full-name pv-erc-user-full-name)
(setq erc-nickserv-passwords
      `((freenode     ((erc-nick . ,pv-erc-freenode-pass1)
                       ("nick-two" . ,pv-erc-freenode-pass2)))
        (DALnet       (("nickname" . ,pv-erc-dalnet-pass1)))))
(setq erc-public-away-p nil)
(setq erc-prompt-for-password nil)
;; automatically join channels when we start-up
;; (require 'erc-autojoin)
;; (erc-autojoin-mode 1)
;; (erc :server "irc.freenode.net" :port 6667 :nick "ryutas")
(setq erc-autojoin-channels-alist '(("freenode.net" "#emacs")))

;; timestamp the conversations
;; (erc-timestamp-mode 1)

;; highlight occurences of my nick in the emacs modeline
(erc-match-mode 1)
(setq erc-keywords '("\\bemacs\\b"))
(setq erc-current-nick-highlight-type 'nick-or-keyword)

;; don't flood buffer with quit/joins when a netsplit happens
(require 'erc-netsplit)
(erc-netsplit-mode 1)

;; split the window when we get a privmsg
(setq erc-auto-query 'window-noselect)

;; switch to next ERC buffer
(defun switch-to-irc ()
  "Switch to an IRC buffer, or run `erc-select'.
When called repeatedly, cycle through the buffers."
  (interactive)
  (let ((buffers (and (fboundp 'erc-buffer-list)
                      (erc-buffer-list))))
    (when (eq (current-buffer) (car buffers))
      (bury-buffer)
      (setq buffers (cdr buffers)))
    (if buffers
        (switch-to-buffer (car buffers))
      (erc-select))))

(global-set-key (kbd "C-c b") 'switch-to-irc)



;; gnus
;; email sending
;; ~/.authinfo
;; machine smtp.gmail.com login [your name]@gmail.com password \
;; [your actual password]
;; (setq user-mail-address pv-user-mail-address)
;; (setq user-full-name  pv-erc-user-full-name)
;; (setq message-signature (concat
;;                          "------------\n\n"
;;                          "emacs rocks.\n"))
;; (require 'smtpmail)
;; (setq message-send-mail-function 'smtpmail-send-it)
;; (setq starttls-use-gnutls t)
;; (setq smtpmail-stream-type 'starttls)
;; (setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)))
;; (setq smtpmail-auth-credentials (expand-file-name "~/.authinfo"))
;; (setq smtpmail-default-smtp-server "smtp.gmail.com")
;; (setq smtpmail-smtp-server "smtp.gmail.com")
;; (setq smtpmail-smtp-service 587)
;; (setq message-kill-buffer-on-exit t)

;; email retreive
;; (depend : w3m, emacs-w3m)
;; ~/.authinfo
;; machine imap.gmail.com login [your name]@gmail.com password \
;; [your actual password] port 993
;; (require 'gnus)
;; (setq gnus-select-method '((nnimap "gmail")
;;                            (nnimap-address "imap.gmail.com")
;;                            (nnimap-server-port 993)
;;                            (nnimap-stream ssl)))
;; (setq mm-text-html-renderer 'w3m)
;; (setq gnus-thread-sort-functions
;;       '(gnus-thread-sort-by-most-recent-number
;;         (lambda (t1 t2)
;;           (gnus-thread-sort-by-most-recent-date t1 t2))))
;; (setq-default gnus-summary-line-format
;;               "%U%R%z %(%&user-date;  %-15,15f  %B%s%)\n")
;; (setq-default gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M")))
;; (setq-default gnus-summary-thread-gathering-function
;;               'gnus-gather-threads-by-references)
;; (add-hook 'gnus-summary-mode-hook
;;           (function
;;            (lambda ()
;;              (define-key
;;                gnus-summary-mode-map "d" 'gnus-summary-delete-article)
;;              (define-key
;;                gnus-summary-mode-map "g" 'gnus-summary-rescan-group))))

;; (setq gnus-select-method '(nntp "news.xpeed.com"))
;; (setq gnus-read-active-file nil)

;; (setq gnus-secondary-select-methods '((nntp "news.xpeed.com")))
;; (setq gnus-nntp-server "news.xpeed.com")
;; (add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
;; (setq gnus-default-subscribed-newsgroups
;;       '("gmane.linux.nfs"
;;         "gmane.linux.kernel.cifs"
;;         "gmane.linux.kernel.autofs"))



;; mu4e
;; Allow access to Less Secure Apps
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu")
;; (require 'mu4e)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")

(setq mu4e-headers-time-format  "%H:%M:%S")
(setq mu4e-headers-date-format  "%y/%m/%d")
(setq mu4e-headers-auto-update  t)

;; (setq mu4e-index-cleanup nil ; don't do a full cleanup check
;;       mu4e-index-lazy-check t) ; don't consider up-to-date dirs

;; (See the documentation for `mu4e-sent-messages-behavior' if you have
;; additional non-Gmail addresses and want assign them different
;; behavior.)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

(setq mu4e-maildir-shortcuts
      '( (:maildir "/INBOX"              :key ?i)
         (:maildir "/[Gmail].Sent Mail"  :key ?s)
         (:maildir "/[Gmail].Trash"      :key ?t)
         (:maildir "/[Gmail].All Mail"   :key ?a)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")
(setq mu4e-update-interval 3600) ; sec
(setq mu4e-index-update-in-background t)

;; something about ourselves
(setq user-mail-address "formeu2s@gmail.com"
      user-full-name  "TaeSeong Ryu"
      mu4e-compose-signature
      (concat "Emacs Rocks!!\n"
              "https://www.gnu.org/\n"))

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      '(("smtp.gmail.com" 587 "formeu2s@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)



(use-package mu4e-alert
  :disabled
  :config
  ;; 1. notifications
  ;; - Emacs lisp implementation of the Desktop Notifications API
  ;; 2. libnotify
  ;; - Notifications using the `notify-send' program,
  ;;   requires `notify-send' to be in PATH
  (mu4e-alert-set-default-style 'libnotify)
  ;; (setq mu4e-alert-email-notification-types '(count subjects))
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
  (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
  (setq mu4e-alert-interesting-mail-query
        (concat "flag:unread"
                " AND NOT flag:trashed"
                ;; " AND NOT maildir:"
                "\"/[Gmail].All Mail\"")))



;; dired
(require 'dired)
(setq dired-dwim-target t) ; see describe-variable
(setq dired-recursive-copies 'always) ; "always" means no asking
;; "top" means ask once for top level directory
(setq dired-recursive-deletes 'top)
(setq dired-listing-switches "-alh --group-directories-first")
(setq mouse-1-click-follows-link 450)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'dired-mode-hook 'auto-revert-mode)

(defun my-dired-mode-hook ()
  "Custom behaviours for `dired-mode'."
  ;; `truncate-lines' is automatically buffer-local.
  (setq truncate-lines t))

(add-hook 'dired-mode-hook #'my-dired-mode-hook)

;; KEY BINDINGS
;; (define-key ctl-x-map "\C-j" 'dired-jump)
;; (define-key ctl-x-4-map "\C-j" 'dired-jump-other-window))
;; (define-key dired-mode-map "\C-x\M-o" 'dired-omit-mode)
;; (define-key dired-mode-map "*O" 'dired-mark-omitted)
;; (define-key dired-mode-map "\M-(" 'dired-mark-sexp)
;; (define-key dired-mode-map "*(" 'dired-mark-sexp)
;; (define-key dired-mode-map "*." 'dired-mark-extension)
;; (define-key dired-mode-map "\M-!" 'dired-smart-shell-command)
;; (define-key dired-mode-map "\M-G" 'dired-goto-subdir)
;; (define-key dired-mode-map "F" 'dired-do-find-marked-files)
;; (define-key dired-mode-map "Y"  'dired-do-relsymlink)
;; (define-key dired-mode-map "%Y" 'dired-do-relsymlink-regexp)
;; (define-key dired-mode-map "V" 'dired-do-run-mail)

(require 'dired-x) ; provide extra commands for Dired
(setq dired-guess-shell-alist-user '(("\\.mp4\\'" "mpv")
                                     ("\\.mkv\\'" "mpv")
                                     ("\\.mpe?g\\'\\|\\.avi\\'" "mpv")
                                     ("\\.wmv\\'" "mpv")
                                     ("\\.mp3\\'" "mpv")
                                     ("\\.ogg\\'" "mpv")
                                     ("\\.wav\\'" "mpv")
                                     ("\\[.*\\.zip\\'" "mcomix")
                                     ("\\[.*\\.rar\\'" "mcomix")
                                     ("\\[.*\\.7z\\'" "mcomix")
                                     ;; ("\\.pdf\\'" "evince")
                                     ;; ("\\.doc\\'" "libreoffice")
                                     ;; ("\\.docx\\'" "libreoffice")
                                     ;; ("\\.ppt\\'" "libreoffice")
                                     ;; ("\\.pptx\\'" "libreoffice")
                                     ;; ("\\.xls\\'" "libreoffice")
                                     ;; ("\\.xlsx\\'" "libreoffice")
                                     ;; ("\\.jpg\\'" "pinta")
                                     ;; ("\\.png\\'" "pinta")
                                     ;; ("\\.java\\'" "idea")
                                     ))

(defun ryutas/open-in-dired ()
  "Open file in Dired.
Video file plays on a fit window with original aspect raitio in exwm."
  (interactive)
  (let ((f (dired-get-filename nil t)))
    (cond
     ;; directory include "." ".."
     ((not (dired-nondirectory-p f)) (dired-find-file))
     ;; video file
     ((member (file-name-extension f)
              '("mkv" "avi" "mp4" "mpeg" "mpg" "wmv" "flv"
                "webm" "ogg" "asf" "mov"))
      (progn
        (let*
            ((f (s-replace-regexp "[][() ]" "\\\\\\&" f))
             (a (shell-command-to-string
                 (format
                  "ffprobe -v error \
                                  -select_streams v:0 \
                                  -show_entries \
                                   stream=display_aspect_ratio,width,height \
                                  -of csv=s=x:p=0 \
                                   %s"
                  f)))
             (b (split-string (substring a 0 -1) "[x:]"))
             ;; ffprobe results
             ;; N/A
             ;; 1920x1080
             ;; 1920x1080xN/A
             ;; 720x480x853:480
             (b (cond ((eq (length b) 2) b)
                      ((eq (length b) 3) (delete "N/A" b))
                      ((eq (length b) 4) (nthcdr 2 b))))
             (c (/ (string-to-number (nth 0 b))
                   (float (string-to-number
                           (if (nth 1 b) (nth 1 b) 1)))))
             ;; 1.77777777777777 -> 1.78
             (c (string-to-number (format "%0.2f" c))))
          (if (> c 2)
              (ryutas/aspect-ratio-h c)
            (ryutas/aspect-ratio-w c)))
        (start-process "dired-mpv" nil "mpv" f)))
     ;; default open with xdg-open
     (t (start-process "dired-xdg" nil "xdg-open" f)))))

(define-key dired-mode-map (kbd "C-<return>") #'ryutas/open-in-dired)
;; (define-key dired-mode-map (kbd "<mouse-1>") #'dired-find-file)
;; (define-key
;;   dired-mode-map (kbd "C-<return>") #'dired-do-async-shell-command)



;; wdired allows you to edit a Dired buffer and write changes to disk
;; - Switch to Wdired by C-x C-q
;; - Edit the Dired buffer, i.e. change filenames
;; - Commit by C-c C-c, abort by C-c C-k
(require 'wdired)
(setq wdired-allow-to-change-permissions t) ; allow to edit permission bits
(setq wdired-allow-to-redirect-links t) ; allow to edit symlinks



;; dired execute for win32
;; (defun dired-custom-execute-file (&optional arg)
;;   (interactive "P")
;;   (mapcar #'(lambda (file)
;;               (w32-shell-execute "open" (convert-standard-filename file)))
;;           (dired-get-marked-files nil arg)))

;; (defun dired-custom-dired-mode-hook ()
;;   (define-key dired-mode-map (kbd "C-<return>") 'dired-custom-execute-file)
;;   (define-key dired-mode-map (kbd "<return>") 'dired-find-alternate-file)
;;   ;; 동작이 이상함
;;   (define-key dired-mode-map (kbd "<mouse-1>") 'dired-custom-execute-file)
;;   (define-key dired-mode-map (kbd "<mouse-2>") 'dired-find-alternate-file))

;; (add-hook 'dired-mode-hook 'dired-custom-dired-mode-hook)
;; (add-hook 'dired-mode-hook 'dired-hide-details-mode)
;; (put 'dired-find-alternate-file 'disabled nil)



;; recentf
(require 'recentf)
(setq recentf-max-menu-items 30)
(setq recentf-max-saved-items 5000)
(recentf-mode)



;; prettify-symbols-mode
;; 폰트 영향을 받음, 폰트 바꿔가면서 테스트 요망
;; (defun my-pretty-symbols ()
;;   "Make some word or string show as pretty Unicode symbols."
;;   (setq prettify-symbols-alist '(("lambda" . 955) ; λ
;;                                  ("concat" . 8721)))) ;; ??
;; (when window-system
;;   (add-hook 'scheme-mode-hook 'my-pretty-symbols)
;;   (global-prettify-symbols-mode 1))

;; (define-abbrev-table 'global-abbrev-table '(("alpha" "α")
;;                                             ("inf" "∞")))
;; (abbrev-mode 1) ; turn on abbrev mode



;; windmove - easier window navigation
(require 'windmove)
;; (windmove-default-keybindings)
(setq windmove-wrap-around t)



;; org-mode
(require 'org)
;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)
;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((perl . t)
   (R . t)
   (ditaa . t)
   (gnuplot t)
   (ruby . t)
   (shell . t) ; from emacs 26.1, sh -> shell
   (python . t)
   (emacs-lisp . t)))
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files '("~/.emacs.d/todo.org"))
;;set priority range from A to C with default A
(setq org-highest-priority ?A)
(setq org-lowest-priority ?C)
(setq org-default-priority ?A)
;;set colours for priorities
(setq org-priority-faces
      '((?A . (:foreground "#F0DFAF" :weight bold))
        (?B . (:foreground "LightSteelBlue"))
        (?C . (:foreground "OliveDrab"))))
(setq org-agenda-window-setup 'current-window)
(define-key global-map (kbd "C-c c") 'org-capture)
;; (setq org-export-in-background t) ; free variable
(setq org-capture-templates
      `(("t" "todo" entry
         (file+headline "~/.emacs.d/todo.org" "Tasks")
         ,(concat "* TODO [#A] %?\n"
                  "SCHEDULED: %(org-insert-time-stamp"
                  "(org-read-date nil t \"+0d\"))\n%a\n"))))
;;warn me of any deadlines in next 7 days
(setq org-deadline-warning-days 7)
;;show me tasks scheduled or due in next fortnight
(setq org-agenda-span 'fortnight)
;;don't show tasks as scheduled if they are already shown as a deadline
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
;;don't give awarning colour to tasks with impending deadlines
;;if they are scheduled to be done
(setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
;;don't show tasks that are scheduled or have deadlines in the
;;normal todo list
(setq org-agenda-todo-ignore-deadlines 'all)
(setq org-agenda-todo-ignore-scheduled 'all)
;;sort tasks in order of when they are due and then by priority
(setq org-agenda-sorting-strategy
      '((agenda deadline-up priority-down)
        (todo priority-down category-keep)
        (tags priority-down category-keep)
        (search category-keep)))



;; eshell
(require 'em-term)
(defun eshell/goterm (prog &rest args)
  "Execute PROG with ARGS to term from eshell."
  (switch-to-buffer
   (apply #'make-term (format "in-term %s %s" prog args) prog nil args))
  (term-mode)
  (term-char-mode))

(defun jlp/add-to-list-multiple (list to-add)
  "Add TO-ADD to LIST.
Allows for adding a sequence of items to the same list, rather
than having to call `add-to-list' multiple times."
  (interactive)
  (dolist (item to-add)
    (add-to-list list item)))

(jlp/add-to-list-multiple 'eshell-visual-commands
                          '("vim" "rtorrent" "mpv"))
(add-to-list 'eshell-visual-options
             '("git" "--help" "--paginate"))
(add-to-list 'eshell-visual-subcommands
             '("git" "log" "diff" "show"))

;; (setq eshell-destroy-buffer-when-process-dies t)



;; eww
(require 'eww)

(defun mpv-url-at-point ()
  "Open links with mpv at the point."
  (interactive)
  (start-process "mpv" nil "mpv"
                 (get-text-property (point) 'shr-url)))

(define-key eww-mode-map (kbd "m") 'mpv-url-at-point)
(define-key eww-mode-map (kbd "<mouse-3>") 'mpv-url-at-point)
(define-key eww-mode-map (kbd "<header-line> <mouse-3>") 'mpv-url-at-point)

(defun mpv-play-url (url)
  "Open youtube URL links with mpv."
  (interactive)
  (start-process "mpv" nil "mpv" url))

(setq browse-url-browser-function '(("youtube" . mpv-play-url)
                                    ("." . eww-browse-url)))
(setq eww-download-directory "/mnt/data/Downloads/")
(setq shr-use-fonts nil) ; proportional fonts for text
(setq shr-use-colors t) ; respect color specifications in the HTML
(setq eww-history-limit 1000) ; default 50, nil indefinitely
;; Images that have URLs matching this regexp will be blocked
;; (setq shr-blocked-images nil) ; "" all block
(setq shr-max-image-proportion 0.7)
(setq eww-desktop-remove-duplicates 'auto)
(setq eww-restore-desktop nil) ; t might take too long time to finish




(defun xah-rename-eww-buffer ()
  "Rename `eww-mode' buffer so sites open in new page.
  URL `http://ergoemacs.org/emacs/emacs_eww_web_browser.html'
  Version 2017-11-10"
  (let (($title (plist-get eww-data :title)))
    (when (eq major-mode 'eww-mode )
      (if $title
          (rename-buffer (concat "*eww* - " $title ) t)
        (rename-buffer "*eww*" t)))))

(add-hook 'eww-after-render-hook 'xah-rename-eww-buffer)



;;  Packages from package-archives(melpa, elpa)

(use-package diminish
  :demand
  :config
  (eval-after-load "flyspell" '(diminish 'flyspell-mode))
  (eval-after-load "subword" '(diminish 'subword-mode)))



(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))



(use-package edit-server
  :hook
  (edit-server-done . (lambda ()
                        (kill-ring-save (point-min) (point-max))))
  :config
  (when (and (daemonp) (require 'edit-server nil :noerror))
    (setq edit-server-new-frame nil) ; nil for window
    (edit-server-start)))



(use-package google-this
  :diminish
  :bind ; prefix: C-c /
  ("C-' g" . google-this-noconfirm)
  :config
  (google-this-mode))



(use-package sdcv
  :bind
  ("C-' d" . sdcv-search-pointer)
  ("C-' C-d" . sdcv-search-input)
  :config
  (setq sdcv-say-word-p t)
  (setq sdcv-dictionary-simple-list
        '("Collins5"
          "Korean-Dic"
          "jmdict-ja-en"))
  (setq sdcv-dictionary-complete-list
        '("Collins5"
          "Korean-Dic"
          "jmdict-ja-en")))
;; override for unicode and color
(add-to-list 'load-path "~/.emacs.d/mylisp/sdcv")



(use-package key-chord
  :disabled
  :demand
  :diminish
  :config
  ;; sub-map
  (let ((key-chord-key-sub-map (make-sparse-keymap)))
    (define-key key-chord-key-sub-map " " 'avy-goto-char-timer)
    (define-key key-chord-key-sub-map "l" 'avy-goto-line)
    (define-key key-chord-key-sub-map "f" 'ace-window)
    (define-key key-chord-key-sub-map "d" 'sdcv-search-pointer)
    (define-key key-chord-key-sub-map (kbd "C-d") 'sdcv-search-input)
    (define-key key-chord-key-sub-map "g" 'google-this-noconfirm)
    (key-chord-define-global "  "  key-chord-key-sub-map))
  (setq key-chord-two-keys-delay 0.01 ; 0.05 or 0.1
        key-chord-one-key-delay 0.15) ; 0.2(0.16) or 0.3
  (key-chord-mode 1)
  ;; disable it in the minibuffer
  (defun disable-key-chord-mode ()
    (set (make-local-variable 'input-method-function) nil))
  (add-hook 'minibuffer-setup-hook #'disable-key-chord-mode))



(use-package projectile
  :disabled
  :diminish ; '(:eval (concat " " (projectile-project-name)))
  :defer
  :config
  (projectile-mode)
  (setq projectile-enable-caching t))



(use-package helm-projectile
  :disabled
  :defer
  :config
  (helm-projectile-on)
  (setq projectile-completion-system 'helm))



(use-package elpy
  :defer
  :bind
  (:map elpy-mode-map
        ("M-." . elpy-goto-assignment))
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  ;; Use IPython for REPL
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt"))



(use-package company
  :bind
  (:map prog-mode-map
        ("C-i" . company-indent-or-complete-common)
        ("C-M-i" . completion-at-point))
  (:map company-active-map
        ("<tab>" . company-select-next)
        ("S-<tab>" . company-select-previous)
        ("C-i" . company-select-next)
        ("S-C-i" . company-select-previous)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :config
  (setq company-backends '((company-files
                            company-yasnippet
                            ;; company-dabbrev
                            company-keywords
                            company-capf)))
  (setq company-idle-delay nil ; default 0.5
        company-echo-delay 0
        company-dabbrev-downcase nil
        company-dabbrev-code-everywhere t
        company-dabbrev-code-modes t
        company-dabbrev-code-ignore-case t
        company-tooltip-align-annotations t
        company-minimum-prefix-length 1
        company-selection-wrap-around t
        company-transformers '(company-sort-by-occurrence
                               company-sort-by-backend-importance))
  ;; (defun company-ac-setup ()
  ;;   "Sets up ‘company-mode’ to behave similarly to ‘auto-complete-mode’."
  ;;   (setq company-require-match nil)
  ;;   (setq company-auto-complete
  ;;         #’my-company-visible-and-explicit-action-p)
  ;;   (setq company-frontends
  ;;         ’(company-echo-metadata-frontend
  ;;           company-pseudo-tooltip-unless-just-one-frontend-with-delay
  ;;           company-preview-frontend))
  ;;   (define-key company-active-map [tab]
  ;;     ’company-select-next-if-tooltip-visible-or-complete-selection)
  ;;   (define-key company-active-map (kbd "TAB")
  ;;     ’company-select-next-if-tooltip-visible-or-complete-selection))
  ;; (company-ac-setup)
  (global-company-mode))



(use-package company-quickhelp
  :config
  (setq company-quickhelp-delay 0)
  (company-quickhelp-mode))



(use-package aggressive-indent
  :diminish
  :config
  ;; (global-aggressive-indent-mode 1)
  ;; (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'css-mode-hook #'aggressive-indent-mode))



(use-package auto-complete
  :disabled
  :init
  (require 'auto-complete-config)
  (require 'showtip)
  :config
  (ac-config-default)
  (global-auto-complete-mode)
  (ac-flyspell-workaround) ;; important
  ;; (add-to-list 'ac-dictionary-directories
  ;;              "~/.emacs.d/mylisp/auto-complete/dict")
  (setq ac-auto-show-menu 0.2)
  (setq ac-delay 0.1)
  (setq ac-menu-height 20)
  (setq ac-auto-start 2)
  (setq ac-show-menu-immediately-on-auto-complete t))



(use-package comment-dwim-2
  :bind
  ("M-;" . comment-dwim-2)
  :config
  (setq comment-dwim-2--inline-comment-behavior 'reindent-comment))



(use-package discover-my-major
  :bind
  (:map help-map
        ("h m" . discover-my-major)
        ("h o" . discover-my-mode))
  :init
  ;; original "C-h h" displays "hello world" in different languages
  (global-unset-key (kbd "C-h h")))



(use-package emms
  :disabled
  :config
  (require 'emms-setup)
  ;; load functions that will talk to emms-print-metadata which
  ;; in turn talks to libtag and gets metadata
  ;; (require 'emms-info-libtag)
  (require 'emms-mode-line)
  (require 'emms-playing-time)
  (setq emms-source-file-default-directory "/mnt/data/Music/")
  (setq emms-playlist-buffer-name "*Music*")
  (setq emms-info-asynchronously t)
  ;; make sure libtag is the only thing delivering metadata
  ;; (setq emms-info-functions '(emms-info-libtag))
  ;; mpg123 can not play wma file, can not pause
  ;; (setq emms-player-mpg321-command-name "/usr/bin/mpg123.exe")
  (setq emms-player-mpv-command-name "/usr/bin/mpv")
  (setq emms-player-list '(emms-player-mpv))
  (emms-all)
  ;; (emms-default-players)
  (emms-add-directory-tree emms-source-file-default-directory)
  (emms-mode-line 1)
  (emms-playing-time 1))



(use-package expand-region
  :bind
  ("C-=" . er/expand-region)) ; - to contract, 0 to reset



(use-package flycheck
  ;; :bind
  ;; ("C-c C-n" . flycheck-tip-cycle)
  ;; :hook
  ;; (after-init . global-flycheck-mode)
  :config
  ;; (setq flycheck-display-errors-function 'ignore)
  ;; (setq error-tip-notify-keep-messages t) ;;with D-Bus option
  (global-flycheck-mode))



(use-package function-args
  :disabled
  :config
  (fa-config-default))



;; Melpa Package: ggtags
;; (require 'ggtags)
;; (add-hook 'c-mode-common-hook
;;           (lambda () (when (derived-mode-p 'c-mode
;;                                            'c++-mode
;;                                            'java-mode
;;                                            'asm-mode)
;;                        (ggtags-mode 1))))
;; (add-hook 'dired-mode-hook 'ggtags-mode)
;; (define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
;; (define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
;; (define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
;; (define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
;; (define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
;; (define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

;; (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)



(use-package helm
  :demand
  :diminish
  :bind
  ;; C-x c : prefix
  ;; C-o : jump to other source in helm session
  ("M-x" . helm-M-x)
  ("C-x b" . helm-mini)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-kill-ring)
  (:map helm-map
        ("<tab>" . helm-execute-persistent-action)
        ("C-i" . helm-execute-persistent-action)
        ("C-z" . helm-select-action))
  (:map shell-mode-map
        ("C-c C-l" . helm-comint-input-ring))
  (:map minibuffer-local-map
        ("C-c C-l" . helm-minibuffer-history))
  :config
  (require 'helm-config)
  (setq helm-split-window-inside-p t ; nil for whole window
        helm-move-to-line-cycle-in-source t
        ;; search for library in `require' and `declare-function' sexp
        helm-ff-search-library-in-sexp t
        ;; scroll 8 lines other window using M-<next>/M-<prior>
        helm-scroll-amount 8
        helm-ff-file-name-history-use-recentf t
        helm-echo-input-in-header-line t
        helm-locate-create-db-command "updatedb" ; "updatedb -l 0 -o %s -U %s"
        helm-autoresize-max-height 25
        helm-autoresize-min-height 0
        helm-ff-skip-boring-files t
        helm-M-x-fuzzy-match t ; optional fuzzy matching for helm-M-x
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-semantic-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-locate-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-lisp-fuzzy-completion t)
  (when (executable-find "curl")
    (setq helm-net-prefer-curl t))
  (when (executable-find "ack-grep")
    (setq helm-grep-default-command
          "ack-grep -Hn --no-group --no-color %e %p %f"
          helm-grep-default-recurse-command
          "ack-grep -H --no-group --no-color %e %p %f"))

  (defun spacemacs//helm-hide-minibuffer-maybe ()
    "Hide minibuffer in Helm session if we use the header line as input field."
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face
                     (let ((bg-color (face-background 'default nil)))
                       `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))

  (add-hook 'helm-minibuffer-set-up-hook 'spacemacs//helm-hide-minibuffer-maybe)
  (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
  (require 'helm-eshell)
  ;; (add-hook 'eshell-mode-hook
  ;;           #'(lambda ()
  ;;               (define-key eshell-mode-map  (kbd "C-c C-l")  'helm-eshell-history)))
  (helm-mode 1)
  (semantic-mode 1)
  (helm-descbinds-mode 1)
  (helm-autoresize-mode 1))



;; Melpa Package: helm-gtags-mode
;; (require 'helm-gtags)
;; (add-hook 'dired-mode-hook 'helm-gtags-mode)
;; (add-hook 'eshell-mode-hook 'helm-gtags-mode)
;; (add-hook 'c-mode-hook 'helm-gtags-mode)
;; (add-hook 'c++-mode-hook 'helm-gtags-mode)
;; (add-hook 'asm-mode-hook 'helm-gtags-mode)

;; (setq
;;  helm-gtags-ignore-case t
;;  helm-gtags-auto-update t
;;  helm-gtags-use-input-at-cursor t
;;  helm-gtags-pulse-at-cursor t
;;  helm-gtags-prefix-key "\C-cg"
;;  helm-gtags-suggested-key-mapping t
;;  )
;; (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
;; (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
;; (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
;; (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
;; (define-key helm-gtags-mode-map
;;   (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;; (define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
;; (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;; (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;; (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;; (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)



(use-package helm-swoop
  :bind
  ("M-i" . helm-swoop)
  ("M-I" . helm-swoop-back-to-last-point)
  ("C-c M-i" . helm-multi-swoop)
  ("C-x M-i" . helm-multi-swoop-all)
  (:map isearch-mode-map
        ("M-i" . helm-swoop-from-isearch))
  (:map helm-swoop-map
        ("M-i" . helm-multi-swoop-all-from-helm-swoop)
        ("M-m" . helm-multi-swoop-current-mode-from-helm-swoop)
        ("C-r" . helm-previous-line)
        ("C-s" . helm-next-line))
  (:map helm-multi-swoop-map
        ("C-r" . helm-previous-line)
        ("C-s" . helm-next-line))
  :config
  (setq helm-multi-swoop-edit-save t
        helm-swoop-split-with-multiple-windows t
        helm-swoop-split-direction 'split-window-vertically
        helm-swoop-speed-or-color nil
        helm-swoop-move-to-line-cycle t
        helm-swoop-use-line-number-face t
        helm-swoop-use-fuzzy-match t)
  ;; If a symbol or phrase is selected, use it as the initial query.
  (setq helm-swoop-pre-input-function
        (lambda ()
          (if mark-active
              (buffer-substring-no-properties (mark) (point))
            "")))
  ;; (helm-migemo-mode 1)
  )



(use-package ivy
  :disabled
  :diminish
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  )



(use-package swiper ; helm-swoop is better
  :disabled
  :bind
  ("C-s" . swiper)
  (:map ivy-minibuffer-map
        ("C-w" . ivy-yank-word))
  :config
  (setq ivy-display-style 'fancy)
  (advice-add 'swiper :after #'recenter))



(use-package counsel
  :disabled
  :diminish
  (counsel-mode))



(use-package highlight-numbers
  :hook
  (prog-mode . highlight-numbers-mode)
  :config
  (highlight-numbers-mode))



(use-package highlight-symbol
  :diminish
  :hook
  ((prog-mode org-mode) .  highlight-symbol-mode)
  :bind
  (("M-n" . highlight-symbol-next)
   ("M-p" . highlight-symbol-prev))
  :config
  (highlight-symbol-nav-mode)
  (setq highlight-symbol-idle-delay 0.2
        highlight-symbol-on-navigation-p t)
  (global-set-key [(control shift mouse-1)]
                  (lambda (event)
                    (interactive "e")
                    (goto-char (posn-point (event-start event)))
                    (highlight-symbol-at-point))))



(use-package doom-modeline
  :disabled
  :init
  (doom-modeline-mode)
  :config
  (setq doom-modeline-height 20)
  (setq doom-modeline-bar-width 3)
  (setq doom-modeline-buffer-file-name-style 'auto)
  (setq doom-modeline-icon (display-graphic-p))
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)
  (setq doom-modeline-unicode-fallback nil)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-enable-word-count nil)
  (setq doom-modeline-buffer-encoding t)
  (setq doom-modeline-indent-info nil)
  (setq doom-modeline-checker-simple-format t)
  (setq doom-modeline-number-limit 99)
  (setq doom-modeline-vcs-max-length 12)
  (setq doom-modeline-persp-name t)
  (setq doom-modeline-display-default-persp-name nil)
  (setq doom-modeline-persp-icon t)
  (setq doom-modeline-lsp t)
  (setq doom-modeline-github-interval (* 30 60))
  (setq doom-modeline-modal-icon t)
  (setq doom-modeline-mu4e t)
  (setq doom-modeline-irc t)
  (setq doom-modeline-irc-stylize 'identity)
  (setq doom-modeline-env-version t)
  ;; Change the executables to use for the language version string
  (setq doom-modeline-env-python-executable "python")
  (setq doom-modeline-env-ruby-executable "ruby")
  (setq doom-modeline-env-perl-executable "perl")
  (setq doom-modeline-env-go-executable "go")
  (setq doom-modeline-env-elixir-executable "iex")
  (setq doom-modeline-env-rust-executable "rustc")
  ;; What to dispaly as the version while a new one is being loaded
  (setq doom-modeline-env-load-string "...")
  ;; Hooks that run before/after the modeline version string is updated
  (setq doom-modeline-before-update-env-hook nil)
  (setq doom-modeline-after-update-env-hook nil))



(use-package spaceline
  :demand ; 0.5s loading time
  :config
  (require 'spaceline-config)
  ;; need to compile with spaceline-compile
  (setq spaceline-separator-dir-left '(left . left)
        spaceline-separator-dir-right '(right . right)
        powerline-default-separator 'arrow ; arrow box
        spaceline-highlight-face-func 'spaceline-highlight-face-modified
        anzu-cons-mode-line-p nil
        spaceline-minor-modes-separator ","
        powerline-height 22) ; do not match emacs and exwm
  (face-spec-set 'mu4e-modeline-face '((t :bold t
                                          :foreground "#3E3D31"
                                          :inherit 'mode-line)))
  (face-spec-set 'spaceline-highlight-face '((t :foreground "#3E3D31"
                                                :background "DarkGoldenrod2"
                                                :inherit 'mode-line)))
  (face-spec-set 'spaceline-read-only '((t :foreground "#3E3D31"
                                           :background "SpringGreen1")))
  (face-spec-set 'spaceline-unmodified '((t :foreground "#3E3D31"
                                            :inherit 'mode-line)))
  (face-spec-set 'spaceline-modified '((t :foreground "#3E3D31"
                                          :background "OrangeRed"
                                          :inherit 'mode-line)))
  (spaceline-toggle-buffer-position-off) ; n%
  (spaceline-toggle-line-column-on)
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-flycheck-error-on)
  (spaceline-toggle-flycheck-warning-on)
  (spaceline-toggle-flycheck-info-on)
  (spaceline-toggle-hud-off) ; the currently visible part of the buffer
  (spaceline-toggle-buffer-encoding-abbrev-off) ; unix, dos or mac
  (spaceline-toggle-minor-modes-off) ; can be tweaked with diminish
  (spaceline-toggle-selection-info-off) ; the currently active selection
  ;; (spaceline-spacemacs-theme) ; buggy for gnu-emacs
  (spaceline-emacs-theme)
  (spaceline-helm-mode)
  (spaceline-info-mode))



(use-package spaceline-all-the-icons
  :disabled ; 4s loading time
  :after spaceline
  :config
  (spaceline-all-the-icons-theme))



(use-package all-the-icons
  :disabled)



(use-package nyan-mode
  :disabled
  :config
  (nyan-mode 1)
  (nyan-start-animation))



(use-package nyan-prompt
  :disabled
  :config
  (add-hook 'eshell-load-hook 'nyan-prompt-enable))



(use-package rainbow-delimiters
  :diminish
  :demand
  :hook
  ((prog-mode ppro-mode ahk-mode) . rainbow-delimiters-mode))



(use-package rainbow-mode
  :diminish
  :config
  (rainbow-mode 1))



(use-package smartparens
  :diminish
  :init
  (require 'smartparens-config)
  :config
  (setq sp-show-pair-from-inside t)
  (setq sp-highlight-pair-overlay nil)
  (smartparens-global-mode) ; annoying
  (show-smartparens-global-mode)
  ;; when you press RET, the curly braces automatically
  ;; add another newline
  (sp-with-modes '(c-mode c++-mode)
    (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
    (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                              ("* ||\n[i]" "RET")))))



(use-package sr-speedbar
  :bind
  ("C-c C-v ss" . sr-speedbar-toggle))



(use-package volatile-highlights
  :diminish
  :config
  (volatile-highlights-mode 1))



(use-package pcomplete-extension)



(use-package zoom ; better than golden ratio.
  :disabled
  :diminish
  :config
  (zoom-mode)
  (custom-set-variables
   '(zoom-size '(0.64 . 0.64)) ; 1> % , 1< abs
   '(zoom-ignored-major-modes '(ediff-mode
                                markdown-mode))
   '(zoom-ignored-buffer-names '("zoom.el"))
   '(zoom-ignored-buffer-name-regexps '("^*calc"))))



(use-package which-key
  :diminish
  :config
  (setq which-key-idle-delay 1
        which-key-idle-secondary-delay 0.05
        which-key-max-description-length 50 ; default 27
        which-key-add-column-padding 0
        which-key-max-display-columns nil
        which-key-separator " "
        which-key-unicode-correction 3
        which-key-prefix-prefix " "
        which-key-special-keys nil
        which-key-show-prefix nil
        which-key-show-remaining-keys t
        which-key-popup-type 'side-window ; minibuffer for zoom package
        which-key-side-window-location 'bottom
        which-key-side-window-max-width 0.33
        which-key-side-window-max-height 0.25
        ;; single characters are sorted alphabetically
        ;; which-key-sort-order 'which-key-key-order-alpha
        ;; all prefix keys are grouped together at the end
        ;; which-key-sort-order 'which-key-prefix-then-key-order
        ;; all keys from local maps shown first
        ;; which-key-sort-order 'which-key-local-then-key-order
        ;; sort based on the key description ignoring case
        ;; which-key-sort-order 'which-key-description-order
        which-key-sort-order 'which-key-key-order)
  ;; (which-key-show-major-mode)
  (which-key-mode))



(use-package guide-key
  :disabled
  :diminish
  :config
  (guide-key-mode)
  (setq  guide-key/popup-window-position 'bottom
         guide-key/text-scale-amount 0 ; less: -0.5 enlarge: 0.5
         guide-key/guide-key-sequence t ; '("C-x r" "C-x 4")
         guide-key/recursive-key-sequence-flag t
         guide-key/idle-delay 0.1 ; search your delay time
         guide-key/highlight-command-regexp
         '("helm"
           ("register" . font-lock-type-face)
           ("bookmark" . "hot pink")
           ("org" . "magenta")
           ("macro" . "tomato")))
  ;; (defun guide-key/my-hook-function-for-org-mode ()
  ;;   (guide-key/add-local-guide-key-sequence "C-c")
  ;;   (guide-key/add-local-guide-key-sequence "C-c C-x")
  ;;   (guide-key/add-local-highlight-command-regexp "org-"))
  ;; (add-hook 'org-mode-hook 'guide-key/my-hook-function-for-org-mode)
  ;;
  ;; (setq guide-key/guide-key-sequence
  ;;       '("C-x r" "C-x 4"
  ;;         (org-mode "C-c C-x")
  ;;         (outline-minor-mode "C-c @")))
  ;;
  ;; (guide-key/key-chord-hack-on)
  ;; (setq guide-key/guide-key-sequence '("<key-chord>"))
  )



(use-package magit
  :defer t)



(use-package pdf-tools
  :defer t)



(use-package workgroups2
  :disabled
  :bind
  ;; <prefix> c    - create workgroup
  ;; <prefix> A    - rename workgroup
  ;; <prefix> k    - kill workgroup
  ;; <prefix> v    - switch to workgroup
  ;; <prefix> C-s  - save session
  ;; <prefix> C-f  - load session
  ;; <prefix> ?  - help
  ("<pause>" . wg-reload-session)
  ("C-S-<pause>" . wg-save-session)
  ("s-z" . wg-switch-to-workgroup)
  ("s-/" . wg-switch-to-previous-workgroup)
  :config
  (setq wg-prefix-key (kbd "C-c w"))
  (setq wg-session-file "~/.emacs.d/.workgroups")
  ;; What to do on Emacs exit / workgroups-mode exit?
  (setq wg-emacs-exit-save-behavior nil) ; Options: 'save 'ask nil
  (setq wg-workgroups-mode-exit-save-behavior nil) ; Options: 'save 'ask nil
  ;; Mode Line changes
  ;; Display workgroups in Mode Line?
  (setq wg-mode-line-display-on t) ; Default: (not (featurep 'powerline))
  (setq wg-flag-modified t) ; Display modified flags as well
  (setq wg-mode-line-decor-left-brace "["
        wg-mode-line-decor-right-brace "]" ; how to surround it
        wg-mode-line-decor-divider ":")
  ;; hook
  ;; workgroups-mode-hook ; when `workgroups-mode' is turned on
  ;; workgroups-mode-exit-hook ; `workgroups-mode' is turned off
  ;; wg-before-switch-to-workgroup-hook
  ;; wg-after-switch-to-workgroup-hook
  (workgroups-mode 1))



(use-package perspective
  :disabled
  ;; :bind
  ;; (("C-x b" . persp-switch-to-buffer*)
  ;;  ("C-x k" . persp-kill-buffer*))
  :config
  (setq persp-state-default-file "~/.emacs.d/.perspective")
  ;; (flycheck-info 'name)
  (setq persp-mode-prefix-key "\C-x x")
  (add-hook 'kill-emacs-hook #'persp-state-save)
  (persp-mode))



(use-package yasnippet
  :init
  ;; (require 'dropdown-list)
  ;; (setq yas-prompt-functions '(yas-dropdown-prompt
  ;;                              yas-ido-prompt
  ;;                              yas-completing-prompt))
  :config
  (yas-global-mode))



(use-package zygospore
  :bind
  ("C-x 1" . zygospore-toggle-delete-other-windows))



(use-package zoom-window ; better than zygospore
  :bind
  ("C-c x" . ryutas/zoom-window-zoom)
  :config
  (custom-set-variables '(zoom-window-mode-line-color "red4"))

  (defun ryutas/zoom-window-zoom()
    "Test."
    (interactive)
    (zoom-window-zoom)
    (force-mode-line-update)))



(use-package eyebrowse
  :disabled ; useless for me
  ;; Switch between window configurations
  :diminish eyebrowse-mode
  :bind
  ;; (:map eyebrowse-mode-map
  ;;       ("M-1" . eyebrowse-switch-to-window-config-1)
  ;;       ("M-2" . eyebrowse-switch-to-window-config-2)
  ;;       ("M-3" . eyebrowse-switch-to-window-config-3)
  ;;       ("M-4" . eyebrowse-switch-to-window-config-4))
  :config
  (eyebrowse-mod)
  (setq eyebrowse-new-workspace t))



(use-package multiple-cursors
  :bind
  ("C-c C-c C-e" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this)
  ("C-M-<mouse-1>" . mc/add-cursor-on-click))



(use-package bm
  :bind
  ("C-c C-b C-m" . bm-toggle)
  ("C-c C-b C-p" . bm-previous)
  ("C-c C-b C-n" . bm-next)
  ("<left-fringe> <mouse-1>" . bm-toggle-mouse)
  ("<left-fringe> <mouse-4>" . bm-previous-mouse)
  ("<left-fringe> <mouse-5>" . bm-next-mouse)
  ("<right-fringe> <mouse-1>" . bm-toggle-mouse)
  ("<right-fringe> <mouse-4>" . bm-previous-mouse)
  ("<right-fringe> <mouse-5>" . bm-next-mouse)
  :hook
  ;; Loading the repository from file when on start up.
  (after-init . bm-repository-load)
  :init
  ;; restore on load (even before you require bm)
  ;; (setq bm-restore-repository-on-load t)
  :config
  (setq bm-cycle-all-buffers t)
  ;; where to store persistant files
  (setq bm-repository-file "~/.emacs.d/bm-repository")
  ;; save bookmarks
  (setq-default bm-buffer-persistence t)
  ;; Saving bookmarks
  (add-hook 'kill-buffer-hook #'bm-buffer-save)
  ;; Saving the repository to file when on exit.
  ;; kill-buffer-hook is not called when Emacs is killed, so we
  ;; must save all bookmarks first.
  (add-hook 'kill-emacs-hook #'(lambda nil
                                 (bm-buffer-save-all)
                                 (bm-repository-save)))
  ;; The `after-save-hook' is not necessary to use to achieve persistence,
  ;; but it makes the bookmark data in repository more in sync with the file
  ;; state.
  (add-hook 'after-save-hook #'bm-buffer-save)
  ;; Restoring bookmarks
  (add-hook 'find-file-hook   #'bm-buffer-restore)
  (add-hook 'after-revert-hook #'bm-buffer-restore)
  ;; The `after-revert-hook' is not necessary to use to achieve persistence,
  ;; but it makes the bookmark data in repository more in sync with the file
  ;; state. This hook might cause trouble when using packages
  ;; that automatically reverts the buffer (like vc after a check-in).
  ;; This can easily be avoided if the package provides a hook that is
  ;; called before the buffer is reverted (like `vc-before-checkin-hook').
  ;; Then new bookmarks can be saved before the buffer is reverted.
  ;; Make sure bookmarks is saved before check-in (and revert-buffer)
  (add-hook 'vc-before-checkin-hook #'bm-buffer-save))



(use-package goto-chg
  :bind
  ("C-' '" . goto-last-change)
  ;; ("C-' \"". goto-last-change-reverse) ; error
  )



(use-package avy
  ;; jumping to visible text using a char-based
  :bind
  ("C-' l" . avy-goto-line)
  ("C-' <SPC>"  . ryutas/avy-goto-char-timer)
  (:map isearch-mode-map
        ("C-'" . avy-isearch))
  :config
  ;; (setq avy-orders-alist
  ;;       '((avy-goto-char . avy-order-closest)
  ;;         (avy-goto-char-timer . avy-order-closest)
  ;;         (avy-goto-word-0 . avy-order-closest)))
  (setq avy-style 'at ; pre, at, at-full, post
        avy-timeout-seconds 0.8 ; 0.5s by default
        avy-background t
        avy-case-fold-search nil
        avy-highlight-first t
        avy-all-windows t ; nil, t, all-frames
        avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

  (defun ryutas/avy-goto-char-timer()
    "After avy-goto-char-time, apply some commands.
If dired-mode, open the file"
    (interactive)
    (let ((x (prin1-to-string (avy-goto-char-timer))))
      ;; zero candidates or quit
      (if (and (not (string-match-p "^t$\\|^nil$" x))
               (string= "dired-mode" major-mode))
          (ryutas/open-in-dired)))))



(use-package avy-flycheck
  :bind
  ("C-c ! g" . avy-flycheck-goto-error)
  :config
  (setq avy-flycheck-style 'pre)
  (avy-flycheck-setup))



(use-package scratch
  :config
  (add-hook 'org-mode-hook
            (lambda ()
              (when scratch-buffer
                (save-excursion
                  (goto-char (point-min))
                  (insert "#+TITLE: Scratch\n\n"))))))



(use-package visible-mark
  :disabled
  :init
  (defface visible-mark-active
    '((((type tty) (class mono)))
      (t (:background "magenta")))
    "Face for visible-mark"
    :group 'visible-mark-move)
  :config
  (global-visible-mark-mode 1)
  (setq visible-mark-max 2)
  (setq visible-mark-faces `(visible-mark-face1 visible-mark-face2)))




(use-package peep-dired
  :disabled
  :bind
  (:map dired-mode-map
        ("P" . peep-dired))
  :config
  (setq peep-dired-ignored-extensions '("mkv" "iso" "mp4")))



(use-package dired-narrow
  :bind
  (:map dired-mode-map
        ;; dired-narrow, dired-narrow-regexp, dired-narrow-fuzzy
        ("'" . dired-narrow-fuzzy))
  :config
  (setq dired-narrow-exit-action 'ryutas/open-in-dired)
  (setq dired-narrow-blink-time 1)
  (setq dired-narrow-enable-blinking t)
  (setq dired-narrow-exit-when-one-left t))



(use-package dired-rainbow
  :config
  (dired-rainbow-define-chmod directory "red4" "d.*")
  (dired-rainbow-define html "#eb5286"
                        ("css" "less" "sass" "scss" "htm"
                         "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024"
                        ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json"
                         "msg" "pgn" "rss" "yaml" "yml" "rdata"))
  (dired-rainbow-define document "#9561e2"
                        ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf"
                         "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define markdown "#ffffff"
                        ("org" "etx" "info" "markdown" "md" "mkd"
                         "nfo" "pod" "rst" "tex" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd"
                        ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#0074d9"
                        ("mkv" "mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg"
                         "flv" "asf" "ogg" "mov" "mid" "midi" "wav" "aiff"
                         "flac" "webm"))
  (dired-rainbow-define image "#f66d9b"
                        ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg"
                         "png" "psd" "eps" "svg" "bmp"))
  (dired-rainbow-define log "#c17d11" ("log"))
  (dired-rainbow-define shell "#f6993f"
                        ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172"
                        ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql"
                         "sql" "r" "clj" "cljs" "scala" "js"))
  (dired-rainbow-define compiled "#4dc0b5"
                        ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++"
                         "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f"
                         "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs"
                         "hi" "hs" "pyc" ".java"))
  (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
  (dired-rainbow-define compressed "#de751f"
                        ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar"
                         "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
  (dired-rainbow-define packaged "#faad63"
                        ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3"
                         "vdf" "vpk" "bsp"))
  (dired-rainbow-define encrypted "#ffed4a"
                        ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig"
                         "p12" "pem"))
  (dired-rainbow-define fonts "#6cb2eb"
                        ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
  (dired-rainbow-define partition "#e3342f"
                        ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd"
                         "vmdk" "bak"))
  (dired-rainbow-define vc "#51d88a"
                        ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))



(use-package dired-ranger
  :disabled)



(use-package dired-subtree
  :disabled
  ;; command
  ;; dired-subtree-insert
  ;; dired-subtree-remove
  ;; dired-subtree-toggle
  ;; dired-subtree-cycle
  ;; dired-subtree-revert
  ;; dired-subtree-narrow
  ;; dired-subtree-up
  ;; dired-subtree-down
  ;; dired-subtree-next-sibling
  ;; dired-subtree-previous-sibling
  ;; dired-subtree-beginning
  ;; dired-subtree-end
  ;; dired-subtree-mark-subtree
  ;; dired-subtree-unmark-subtree
  ;; dired-subtree-only-this-file
  ;; dired-subtree-only-this-directory
  ;; dired-subtree-apply-filter
  )



(use-package dired-open
  :disabled
  ;; By default, two additional methods are enabled,
  ;; dired-open-by-extension and dired-open-subdir.
  ;; This package also provides other convenient hooks:
  ;; dired-open-xdg - try to open the file using xdg-open
  ;; dired-open-guess-shell-alist - try to open the file
  ;; by launching applications from dired-guess-shell-alist-user
  ;; dired-open-call-function-by-extension
  ;; - call an elisp function based on extension.
  ;; dired-open-functions
  ;; you can provide the prefix argument (usually C-u)
  ;; to the dired-open-file function.
  )



(use-package dired-filter
  ;; dired-filter-by-name
  ;; dired-filter-by-regexp
  ;; dired-filter-by-extension
  ;; dired-filter-by-dot-files
  ;; dired-filter-by-omit
  ;; dired-filter-by-garbage
  ;; dired-filter-by-predicate
  ;; dired-filter-by-file
  ;; dired-filter-by-directory
  ;; dired-filter-by-mode
  ;; dired-filter-by-symlink
  ;; dired-filter-by-executable
  ;;
  ;; dired-filter-save-filters
  )

(use-package deft
  :bind
  ("C-c d" . deft)
  :config
  (setq deft-directory "~/.emacs.d/.deft"
        deft-extensions '("org" "tex" "txt")
        deft-default-extension "org"
        deft-recursive t
        deft-use-filename-as-title t
        deft-use-filter-string-for-filename t
        deft-auto-save-interval 0))



(use-package undo-tree
  :diminish
  :bind
  ("C-z z" . undo)
  ("C-z x" . redo)
  ("C-z v" . undo-tree-visualize)
  :init
  (global-unset-key (kbd "C-z"))
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (defalias 'redo 'undo-tree-redo))



(use-package anzu
  :diminish
  :bind
  ("M-%" . anzu-query-replace)
  ("C-M-%" . anzu-query-replace-regexp)
  :custom-face
  (anzu-mode-line ((t :bold t
                      :foreground "red"
                      :inherit 'mode-line)))
  (anzu-mode-line-no-match ((t :bold t
                               :foreground "blue"
                               :inherit 'mode-line)))
  :config
  ;; (global-set-key [remap query-replace] 'anzu-query-replace)
  ;; (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-anzu-mode))



(use-package htmlize)



(use-package ace-window
  :defer 1
  :bind
  ("C-' f" . ace-window)
  :config
  (set-face-attribute 'aw-leading-char-face nil
                      :foreground "red"
                      :weight 'bold
                      :height 1.0)
  (set-face-attribute 'aw-mode-line-face nil
                      :inherit 'mode-line-buffer-id
                      :foreground "lawn green")
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-scope 'frame
        aw-dispatch-always t
        aw-dispatch-alist
        '((?x aw-delete-window "Delete Window")
          (?s aw-swap-window "Swap Window")
          (?c aw-copy-window "Copy Window")
          (?n aw-flip-window)
          (?v aw-split-window-vert "Split Vert Window")
          (?h aw-split-window-horz "Split Horz Window")
          (?m aw-move-window "Move Window")
          (?g delete-other-windows)
          (?b balance-windows)
          (?u (lambda ()
                (progn
                  (winner-undo)
                  (setq this-command 'winner-undo))))
          (?r winner-redo)
          (?? aw-show-dispatch-help)))
  ;; (ace-window-display-mode)
  )



(use-package ace-link
  :config
  (ace-link-setup-default))



(use-package fzf
  :bind
  ("C-c f" . fzf))



(use-package xkcd
  :bind
  (:map xkcd-mode-map
        ("C-p" . xkcd-prev)
        ("C-n" . xkcd-next)
        ("p" . xkcd-prev)
        ("n" . xkcd-next)
        ("j" . xkcd-prev)
        ("k" . xkcd-next)
        ("r"   . xkcd-rand)
        ("t"   . xkcd-alt-text)
        ("q"   . xkcd-kill-buffer)
        ("o"   . xkcd-open-browser)
        ("e"   . xkcd-open-explanation-browser))
  :config
  (setq xkcd-dir (concat user-emacs-directory "xkcd/")) ; must end with /
  (unless (file-exists-p xkcd-dir)
    (make-directory xkcd-dir)))



(use-package wttrin
  :config
  (setq wttrin-default-cities '("Changwon"
                                "Masan"))
  (defun ryutas/wttrin ()
    "Open ‘wttrin’ without prompting.
    Using first city in ‘wttrin-default-cities’."
    (interactive)
    (delete-other-windows)
    (wttrin-query (car wttrin-default-cities))
    (advice-add 'wttrin-exit :after #'winner-undo)))



(use-package vterm ; for stable rendering
  ;; require CMAKE for compile
  :config
  (setq vterm-buffer-name-string "vterm %s")
  (setq vterm-min-window-width 59) ; for tmux date
  (setq vterm-kill-buffer-on-exit t))



(use-package eshell-toggle
  :bind
  ("s-'" . eshell-toggle)
  :config
  ;; (eshell-toggle-size-fraction 3)
  ;; (eshell-toggle-use-projectile-root t)
  ;; (eshell-toggle-run-command nil)
  ;; (eshell-toggle-init-function #'eshell-toggle-init-ansi-term)
  )



(use-package eshell-git-prompt
  :config
  ;; (setq eshell-prompt-function (lambda () "A simple prompt." "$ ")
  ;;       eshell-prompt-regexp    "^$ ")
  (eshell-git-prompt-use-theme 'powerline))



(use-package eshell-z
  :config
  (add-hook 'eshell-mode-hook
            (defun my-eshell-mode-hook ()
              (require 'eshell-z))))



(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode))



(use-package pcmpl-args)



(use-package shell-pop
  :disabled
  :bind
  ("C-t" . shell-pop)
  :config
  (setq shell-pop-shell-type
        '("ansi-term" "*ansi-term*"
          (lambda () (ansi-term shell-pop-term-shell))))
  (setq shell-pop-term-shell "/bin/zsh")
  ;; need to do this manually or not picked up by `shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))




(use-package buffer-expose
  :demand
  :bind
  ;; default key
  ;;
  ;; (defvar buffer-expose-mode-map
  ;;   (let ((map (make-sparse-keymap)))
  ;;     (define-key map (kbd "<s-tab>") 'buffer-expose)
  ;;     (define-key map (kbd "<C-tab>") 'buffer-expose-no-stars)
  ;;     (define-key map (kbd "C-c <C-tab>") 'buffer-expose-current-mode)
  ;;     (define-key map (kbd "C-c C-m") 'buffer-expose-major-mode)
  ;;     (define-key map (kbd "C-c C-d") 'buffer-expose-dired-buffers)
  ;;     (define-key map (kbd "C-c C-*") 'buffer-expose-stars)
  ;;     map)
  ;;   "Mode map for command `buffer-expose-mode'.")

  ;; (defvar buffer-expose-grid-map
  ;;   (let ((map (make-sparse-keymap)))
  ;;     (define-key map (kbd "<left>") 'buffer-expose-left-window)
  ;;     (define-key map (kbd "b") 'buffer-expose-left-window)
  ;;     (define-key map (kbd "<right>") 'buffer-expose-right-window)
  ;;     (define-key map (kbd "f") 'buffer-expose-right-window)
  ;;     (define-key map (kbd "p") 'buffer-expose-up-window)
  ;;     (define-key map (kbd "<up>") 'buffer-expose-up-window)
  ;;     (define-key map (kbd "<down>") 'buffer-expose-down-window)
  ;;     (define-key map (kbd "n") 'buffer-expose-down-window)
  ;;     (define-key map (kbd "a") 'buffer-expose-first-window-in-row)
  ;;     (define-key map (kbd "e") 'buffer-expose-last-window-in-row)
  ;;     (define-key map (kbd "s") 'buffer-expose-switch-to-buffer)
  ;;     (define-key map (kbd "<") 'buffer-expose-first-window)
  ;;     (define-key map (kbd ">") 'buffer-expose-last-window)
  ;;     (define-key map (kbd "SPC") 'buffer-expose-ace-window)
  ;;     (define-key map (kbd ",") 'buffer-expose-ace-window)
  ;;     (define-key map (kbd "TAB") 'buffer-expose-next-window)
  ;;     (define-key map (kbd "<tab>") 'buffer-expose-next-window)
  ;;     (define-key map (kbd "<S-iso-lefttab>") 'buffer-expose-prev-window)
  ;;     (define-key map (kbd "]") 'buffer-expose-next-page)
  ;;     (define-key map (kbd "[") 'buffer-expose-prev-page)
  ;;     (define-key map "k" 'buffer-expose-kill-buffer)
  ;;     map)
  ;;   "Transient keymap used for the overview.")

  ;; (defvar buffer-expose-exit-map
  ;;   (let ((map (make-sparse-keymap)))
  ;;     (define-key map [mouse-1] 'buffer-expose-handle-mouse)
  ;;     (define-key map [mouse-2] 'buffer-expose-handle-mouse)
  ;;     (define-key map [mouse-3] 'buffer-expose-handle-mouse)
  ;;     (define-key map (kbd "RET") 'buffer-expose-choose)
  ;;     (define-key map (kbd "<return>") 'buffer-expose-choose)
  ;;     (define-key map (kbd "C-g") 'buffer-expose-reset)
  ;;     (define-key map (kbd "q") 'buffer-expose-reset)
  ;;     (define-key map [t] 'ignore)
  ;;     map)
  ;;   "Map to handle exit commands of the overview.")
  (:map buffer-expose-mode-map
        ("<s-tab>" . nil) ; conflict with exwm mode keymap
        ("<C-tab>" . nil))
  (:map buffer-expose-grid-map
        ;; ("h". buffer-expose-left-window)
        ;; ("j" . buffer-expose-down-window)
        ;; ("k" . buffer-expose-up-window)
        ;; ("l" . buffer-expose-right-window)
        ("<mouse-3>" . buffer-expose-mode)
        ("TAB" . ryutas/buffer-expose-toggle-page)
        ("<tab>" . ryutas/buffer-expose-toggle-page)
        ("<backtab>". buffer-expose-prev-page))
  :config
  (setq  buffer-expose-highlight-selected nil ; bg some buggy
         buffer-expose-wrap-vertically nil
         buffer-expose-show-current-buffer t ; temp solution
         buffer-expose-max-num-windows 64 ; default 12
         buffer-expose-rescale-factor 1.0 ; default 0.3
         buffer-expose-auto-init-aw t)
  (setq buffer-expose-key-hint
        (concat "Navigate with TAB, Shift-TAB, n, p, f, b, [, ]. h, j, k, l. "
                "Press RET or click to choose a buffer, q to abort. "))
  (setq window-divider-default-bottom-width 0
        window-divider-default-right-width 0)

  ;; user options to customize which buffers are shown
  ;; (defun my-expose-command (&optional max)
  ;;   (interactive "P")
  ;;   (buffer-expose-show-buffers
  ;;    <your-buffer-list> max [<hide-regexes> <filter-func>]))

  (defun ryutas/buffer-expose-exwm-buffers (&optional max)
    "Expose exwm buffers of `buffer-list'.
    If MAX is given it determines the maximum number of windows to
    show per page, which defaults to `buffer-expose-max-num-windows'."
    (interactive "P")
    (buffer-expose-show-buffers
     ;; get last buried first
     (nreverse (buffer-list)) max nil
     (lambda (buf)
       (eq (buffer-local-value 'major-mode buf)
           'exwm-mode))))

  (defun ryutas/buffer-expose-no-stars-no-exwm (&optional max)
    "Expose buffers of `buffer-list' omitting *special* ones and EXWM.
    If MAX is given it determines the maximum number of windows to
    show per page, which defaults to
    `buffer-expose-max-num-windows'."
    (interactive "P")
    (buffer-expose-show-buffers
     (buffer-list) max '("\\`\\*")
     (lambda (buf)
       (not (eq (buffer-local-value 'major-mode buf)
                'exwm-mode)))))

  (defun ryutas/buffer-expose-toggle-page()
    "For toggle next, previous page with one key."
    (interactive)
    (if (or buffer-expose--prev-stack
            buffer-expose--buffer-list)
        (buffer-expose-next-page)
      (if buffer-expose--next-stack
          (buffer-expose-prev-page))))

  (face-spec-set 'buffer-expose-ace-char-face ; red
                 '((t :inherit eww-invalid-certificate)))
  (buffer-expose-mode))



(use-package exwm
  :demand
  :config
  (require 'exwm-config)
  ;; https://github.com/ch11ng/exwm/wiki
  ;; Rename buffer to window title.
  (defun ambrevar/exwm-rename-buffer-to-title ()
    (exwm-workspace-rename-buffer exwm-title))

  (add-hook 'exwm-update-title-hook 'ambrevar/exwm-rename-buffer-to-title)
  (add-hook 'exwm-floating-setup-hook 'exwm-layout-hide-mode-line)
  (add-hook 'exwm-floating-exit-hook 'exwm-layout-show-mode-line)

  (setq exwm-workspace-number 1)
  (setq exwm-manage-force-tiling t)
  (setq exwm-workspace-show-all-buffers nil)
  (setq exwm-layout-show-all-buffers nil)
  (setq exwm-workspace-switch-create-limit 10)
  (setq exwm-workspace-display-echo-area-timeout 5) ; seconds
  ;; Per-application configurations
  (setq exwm-manage-configurations
        '(((string= "Gxmessage" exwm-class-name) floating t)))

  ;; All buffers created in EXWM mode are named "*EXWM*". You may want to
  ;; change it in `exwm-update-class-hook' and `exwm-update-title-hook', which
  ;; are run when a new X window class name or title is available.  Here's
  ;; some advice on this topic:
  ;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
  ;; + For applications with multiple windows (e.g. GIMP), the class names of
  ;;   all windows are probably the same.  Using window titles for them makes
  ;;   more sense.
  ;; In the following example, we use class names for all windows except for
  ;; Java applications and GIMP.
  ;; (add-hook 'exwm-update-class-hook
  ;;           (lambda ()
  ;;             (unless
  ;;                 (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
  ;;                     (string= "gimp" exwm-instance-name))
  ;;               (exwm-workspace-rename-buffer exwm-class-name))))
  ;; (add-hook 'exwm-update-title-hook
  ;;           (lambda ()
  ;;             (when (or (not exwm-instance-name)
  ;;                       (string-prefix-p "sun-awt-X11-" exwm-instance-name)
  ;;                       (string= "gimp" exwm-instance-name))
  ;;               (exwm-workspace-rename-buffer exwm-title))))

  ;; To add a key binding only available in line-mode, simply define it
  ;; `exwm-mode-map'.  The following example shortens 'C-c q' to 'C-q'.
  (exwm-input-set-key (kbd "s-h") #'windmove-left)
  (exwm-input-set-key (kbd "s-j") #'windmove-down)
  (exwm-input-set-key (kbd "s-k") #'windmove-up)
  (exwm-input-set-key (kbd "s-l") #'windmove-right)
  (exwm-input-set-key (kbd "C-q") #'exwm-input-send-next-key)
  (exwm-input-set-key (kbd "<s-tab>") #'ryutas/buffer-expose-exwm-buffers)
  (exwm-input-set-key (kbd "<M-tab>") #'ryutas/buffer-expose-no-stars-no-exwm)
  (exwm-input-set-key (kbd "<M-s-tab>") #'buffer-expose)
  (exwm-input-set-key (kbd "<C-M-tab>") #'buffer-expose-stars)
  (exwm-input-set-key (kbd "C-c <s-tab>") 'buffer-expose-current-mode)
  (exwm-input-set-key (kbd "C-c <M-tab>") 'buffer-expose-dired-buffers)
  (exwm-input-set-key (kbd "C-c <M-s-tab>") 'buffer-expose-major-mode)
  ;; (exwm-input-set-key (kbd "C-x k") nil)  ; selecting deleted buffer
  (exwm-input-set-key (kbd "C-c 2") 'ryutas/aspect-ratio-w)
  (exwm-input-set-key (kbd "C-c 3") 'ryutas/aspect-ratio-h)
  (exwm-input-set-key (kbd "C-' '") 'goto-last-change)
  (exwm-input-set-key (kbd "C-' f") 'ace-window)
  (exwm-input-set-key (kbd "C-' <SPC>") 'ryutas/avy-goto-char-timer)
  (exwm-input-set-key (kbd "C-' l") 'avy-goto-line)
  (exwm-input-set-key (kbd "C-' d") 'sdcv-search-pointer)
  (exwm-input-set-key (kbd "C-' C-d") 'sdcv-search-input)
  (exwm-input-set-key (kbd "C-' g") 'google-this-noconfirm)

  ;; Global keybindings can be defined with `exwm-input-global-keys'.
  ;; Here are a few examples:
  (setq exwm-input-global-keys
        `(
          ;; Bind "s-r" to exit char-mode and fullscreen mode.
          ([?\s-r] . exwm-reset)
          ([?\s-f] . exwm-layout-toggle-fullscreen)
          ([?\s-v] . exwm-floating-toggle-floating)
          ([?\s-x] . helm-run-external-command)
          ([?\s-v] . exwm-floating-toggle-floating)
          ;;  Bind "s-escape" to switch workspace in loop.
          ([s-escape] .
           (lambda ()
             (interactive)
             (if (eq (1+ exwm-workspace-current-index)
                     (length exwm-workspace--list))
                 (exwm-workspace-switch 0)
               (exwm-workspace-switch (1+ exwm-workspace-current-index)))))
          ;; Bind "s-w" to switch workspace interactively.
          ([?\s-w] . exwm-workspace-switch)
          ;; Bind "s-1" to "s-9" to switch to a workspace by its index.
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch, i))))
                    (number-sequence 0 9))

          ;; Bind "s-&" to launch applications ('M-&' also works if the output
          ;; buffer does not bother you).

          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Bind "s-<f2>" to "slock", a simple X display locker.
          ;; ([s-f2] . (lambda ()
          ;;             (interactive)
          ;;             (start-process "" nil "/usr/bin/slock")))
          ))

  ;; for C-h to backspace
  (push ?\C-h exwm-input-prefix-keys)

  ;; The following example demonstrates how to use simulation keys to mimic
  ;; the behavior of Emacs.  The value of `exwm-input-simulation-keys` is a
  ;; list of cons cells (SRC . DEST), where SRC is the key sequence you press
  ;; and DEST is what EXWM actually sends to application.  Note that both SRC
  ;; and DEST should be key sequences (vector or string).
  ;; (exwm-input-set-simulation-keys '(([?\C-c ?\C-c] . ?\C-c)
  ;;                                   ([?\C-x ?\C-x] . ?\C-x)))
  (setq exwm-input-simulation-keys
        '(
          ;; movement
          ([?\C-b] . [left])
          ([?\M-b] . [C-left])
          ([?\C-f] . [right])
          ([?\M-f] . [C-right])
          ([?\C-p] . [up])
          ([?\C-n] . [down])
          ([?\C-a] . [home])
          ([?\C-e] . [end])
          ([?\M-v] . [prior])
          ([?\C-v] . [next])
          ([?\C-m] . [return])
          ([?\C-i] . [tab])
          ;; delete
          ([?\C-d] . [delete])
          ([?\C-?] . [backspace])
          ([?\C-k] . [S-end ?\C-x])
          ;; ([?\C-k] . [S-end delete])
          ([?\M-d] . [C-S-right delete])
          ;; cut/paste.
          ([?\C-w] . [?\C-x])
          ([?\M-w] . [?\C-c]) ; the reson I move to linux
          ([?\C-y] . [?\C-v])
          ;; redo
          ([?\C-/] . [?\C-z])
          ([?\C-g] . [escape])
          ;; search
          ([?\C-s] . [?\C-f])))

  ;; resize window by aspect ratio
  ;; 1.78 - 16:9 1920 x 1080, 1280 x 720, 858 x 480, 640 x 360, 426 x 240
  ;; 1.33 - 4:3 800 x 600
  ;; 1.50 - 3:2 720 x 480
  ;; 2.35 - 1920 x 800 (wide)
  ;; 2.67 - 1920 x 720
  (defvar ar-index 0)

  (defun ryutas/aspect-ratio-w(&optional ar)
    "Fixed width."
    (interactive)
    (let* ((l '(1.33 1.50 1.78 2.35 2.4 2.67))
           (i (cond ((nth (1+ ar-index) l) (1+ ar-index))
                    (t 0)))
           (r (cond (ar ar)
                    (t (nth i l))))
           (h (+ (round (/ (window-pixel-width) r))
                 (window-mode-line-height))))
      (if (not ar)
          (setq ar-index i))
      (window-resize nil (- h (window-pixel-height)) nil nil t)
      (message "aspect ratio(%s): %s"
               (propertize
                "W" 'face '(:foreground "green"))
               (propertize
                (number-to-string r) 'face '(:foreground "red")))))

  (defun ryutas/aspect-ratio-h(&optional ar)
    "Fixed height."
    (interactive)
    (let* ((l '(1.33 1.5 1.78 2.35 2.4 2.67))
           (i (cond ((nth (1+ ar-index) l) (1+ ar-index))
                    (t 0)))
           (r (cond (ar ar)
                    (t (nth i l))))
           (w (round (* (- (window-pixel-height)
                           (window-mode-line-height))
                        r))))
      (if (not ar)
          (setq ar-index i))
      (window-resize nil (- w (window-pixel-width)) t nil t)
      (message "aspect ratio(%s): %s"
               (propertize
                "H" 'face '(:foreground "green"))
               (propertize
                (number-to-string r) 'face '(:foreground "red")))))

  (add-hook 'exwm-manage-finish-hook
            (lambda ()
              (when (or (and (string= "mpv" exwm-class-name)
                             (not (get-process "dired-mpv")))
                        (string= "Picture-in-Picture" exwm-title))
                (ryutas/aspect-ratio-w 1.78))))

  ;; You can hide the minibuffer and echo area when they're not used
  ;; but it works with additional frame ; error for me
  ;; (setq exwm-workspace-minibuffer-position 'bottom)

  (defun fhd/exwm-input-line-mode ()
    "Set exwm window to line-mode and show mode line"
    (call-interactively #'exwm-input-grab-keyboard)
    ;; (exwm-layout-show-mode-line)
    )

  (defun fhd/exwm-input-char-mode ()
    "Set exwm window to char-mode and hide mode line"
    (call-interactively #'exwm-input-release-keyboard)
    ;; (exwm-layout-hide-mode-line)
    )

  (defun fhd/exwm-input-toggle-mode ()
    "Toggle between line- and char-mode"
    (interactive)
    (with-current-buffer (window-buffer)
      (when (eq major-mode 'exwm-mode)
        (if (equal (second (second mode-line-process)) "line")
            (fhd/exwm-input-char-mode)
          (fhd/exwm-input-line-mode)))))
  (exwm-input-set-key (kbd "s-i") #'fhd/exwm-input-toggle-mode)

  (defun fhd/toggle-exwm-input-line-mode-passthrough ()
    (interactive)
    (if exwm-input-line-mode-passthrough
        (progn
          (setq exwm-input-line-mode-passthrough nil)
          (message "App receives all the keys now (with some simulation)"))
      (progn
        (setq exwm-input-line-mode-passthrough t)
        (message "emacs receives all the keys now")))
    (force-mode-line-update))
  (exwm-input-set-key (kbd "s-p") 'fhd/toggle-exwm-input-line-mode-passthrough)

  ;; Logging out with LXDE
  (defun exwm-logout ()
    (interactive)
    (bookmark-save)
    (recentf-save-list)
    (save-some-buffers)
    ;; (start-process-shell-command "logout" nil "lxsession-logout")
    )

  ;; (add-hook 'exwm-manage-finish-hook
  ;;           (lambda () (call-interactively #'exwm-input-release-keyboard)
  ;;             (exwm-layout-hide-mode-line)))

  ;; System tray
  ;; (require 'exwm-systemtray)
  ;; (exwm-systemtray-enable)
  ;; (setq exwm-systemtray-height 20)
  ;; Do not forget to enable EXWM. It will start by itself when things are
  ;; ready.  You can put it _anywhere_ in your configuration.
  ;; (exwm-enable)
  )


(use-package exwm-edit
  ;; :hook
  ;; (exwm-edit-compose . ag-exwm/on-exwm-edit-compose)
  :config
  ;; C-c '​ or C-c C-'​ - edit
  ;; C-c '​ or C-c C-c - finish editing
  ;; C-c C-k - cancel editing
  ;; (defun ag-exwm/on-exwm-edit-compose ()
  ;;   (funcall 'markdown-mode))
  )

;; Packages manually modified-installed

;; autohotkey
(add-to-list 'load-path "~/.emacs.d/mylisp/my-ahk-mode")
(defvar ahk-syntax-directory "~/.emacs.d/mylisp/ahk-org-mode/syntax")
(add-to-list 'auto-mode-alist '("\\.ahk$" . ahk-mode))
(autoload 'ahk-mode "ahk-mode")



;; powerpro
;; (add-to-list 'load-path "~/.emacs.d/mylisp/my-ppro-mode")
;; (add-to-list 'auto-mode-alist '("\\.powerpro$" . ppro-mode))
;; (autoload 'ppro-mode "ppro-mode")



;; rofime
(add-to-list 'load-path "~/.emacs.d/mylisp/rofime")



;; sese
(add-to-list 'load-path "~/.emacs.d/mylisp/sese-mode")
(autoload 'sese-mode "sese" "Subtitle Editor major mode" t)
(setq auto-mode-alist (cons '("\\.sese\\'" . sese-mode) auto-mode-alist))



;; Manually added functions

(defun insert-todays-date (arg)
  (interactive "P")
  (insert (if arg
              (format-time-string "%d-%m-%Y")
            (format-time-string "%Y-%m-%d"))))

(defun switch-to-recent-buffer ()
  "Switch to most recent buffer.
    Repeated calls toggle back and forth between the most recent two buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd "<ESC><tab>") 'switch-to-recent-buffer)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input."
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (forward-line (- (read-number "Goto line: ")
                         (line-number-at-pos)))
        (linum-mode -1))))

(defalias 'gl 'goto-line)

(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun swap-buffers-in-windows ()
  "Put the buffer from the selected window in next window, and vice versa."
  (interactive)
  (let* ((this (selected-window))
         (other (next-window))
         (this-buffer (window-buffer this))
         (other-buffer (window-buffer other)))
    (set-window-buffer other this-buffer)
    (set-window-buffer this other-buffer)))

(global-set-key (kbd "C-c s") 'swap-buffers-in-windows)

(defun switch-to-previous-buffer ()
  "Switch recent window."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(global-set-key (kbd "C-c o") 'switch-to-previous-buffer)

(defun vsplit-last-buffer ()
  "Split window vertically split."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))

(defun hsplit-last-buffer ()
  "Split window horizontally split."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))

(global-set-key (kbd "C-x 2") 'vsplit-last-buffer) ;; override default key
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)

(defun dos2unix ()
  "Replace DOS eolns CR LF with Unix eolns CR."
  (interactive)
  (goto-char (point-min))
  (while (search-forward (string ?\C-m) nil t)
    (replace-match "")))

(defun do-not-show-dos-eol ()
  "Do not M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(add-hook 'sdcv-mode-hook 'do-not-show-dos-eol) ;;  ^M 제거하고 보여줌



;; (defun sccmode ()
;;   "Change cursor color according to some minor modes."
;;   ;; sccmode is somewhat costly, so we only call it when needed.
;;   (let (scccolor
;;         sccbuffer
;;         (color (if buffer-read-only "white"
;;                  (if overwrite-mode "red" "green"))))
;;     (unless (and (string= color scccolor)
;;                  (string= (buffer-name) sccbuffer))
;;       (set-cursor-color (setq scccolor color))
;;       (setq sccbuffer (buffer-name)))))

;; (add-hook 'post-command-hook 'sccmode)


;; scratch
(defvar scratch-filename "~/.emacs.d/.scratch"
  "Location of scratch file contents for scratch.")

(defvar scratch-buffername "*scratch*"
  "Name of buffer for scratch.")

(defun my-save-scratch ()
  "Write the contents excluding fortune cookie."
  (if (get-buffer scratch-buffername)
      (with-current-buffer scratch-buffername
        (goto-char (point-min))
        (while
            (looking-at "^[;\n]")
                           (forward-line 1))
    (newline)
    (forward-line -1)
    (write-region (point) (point-max) scratch-filename))))

(defun my-fortune2scratch ()
  "Return a comment-padded fortune cookie."
  (let ((cookie (shell-command-to-string "fortune -a -c -s")))
    (concat (replace-regexp-in-string
             "^\\(.+\\)" ";; \\1" cookie)
            (shell-command-to-string
             (format "cat %s" scratch-filename)))))

(setq initial-scratch-message (my-fortune2scratch))
(push #'my-save-scratch kill-emacs-hook)



;; run-current-file
(defun run-current-file ()
  "Execute the current file.
For example, if the current buffer is the file xx.py,
then it'll call python xx.py in a shell.
File suffix is used to determine what program to run.
If the file is modified, ask if you want to save first.
If the file is Emacs Lisp, run the byte compiled version if exist."
  (interactive)
  (let* ((suffixMap
          `(("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("py3" . "python3")
            ("rb" . "ruby")
            ("js" . "node")
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")))
         (fooc (concat "gcc " (buffer-name) " && ./a.out"))
         (fName (buffer-file-name))
         (fSuffix (file-name-extension fName))
         (progName (cdr (assoc fSuffix suffixMap)))
         (cmdStr (concat progName " \""   fName "\"")))
    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified.  Do you want to save first? ")
        (save-buffer)))
    (if (string-equal fSuffix "el") ; for emacs lisp
        (load (file-name-sans-extension fName))
      (if (string-equal fSuffix "c") ; c compile
          (shell-command fooc)
        (if progName
            (progn (message "Running...")
                   (save-window-excursion
                     (let ((buf (generate-new-buffer "async")))
                       (async-shell-command cmdStr buf)
                       (run-with-timer 15 nil
                                       (lambda (x) (kill-buffer x)) buf))))
          (message "No recognized program file suffix for this file.")))))
  (if (string-equal (file-name-extension (buffer-file-name)) "c")
      (pop-to-buffer "*Shell Command Output*")
    (pop-to-buffer "async")))

(global-set-key (kbd "C-c e") 'run-current-file)



;; some prelude functions
(defun prelude-colorize-compilation-buffer ()
  "Colorize a compilation mode buffer."
  (interactive)
  ;; we don't want to mess with child modes such as grep-mode, ack, ag, etc
  (when (eq major-mode 'compilation-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max)))))

;; setup compilation-mode used by `compile' command
(require 'compile)
(setq compilation-ask-about-save nil ; Just save before compiling
      ;; Just kill old compile processes before starting the new one
      compilation-always-kill t
      compilation-scroll-output 'first-error) ; Automatically scroll to first
;; (global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

(defun prelude-makefile-mode-defaults ()
  (whitespace-toggle-options '(tabs))
  (setq indent-tabs-mode t))

(setq prelude-makefile-mode-hook 'prelude-makefile-mode-defaults)

(add-hook 'makefile-mode-hook (lambda ()
                                (run-hooks 'prelude-makefile-mode-hook)))

(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and-
the beginning of the line.
If ARG is not nil or 1, move forward ARG - 1 lines first.
If point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))
  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key (kbd "C-a") 'prelude-move-beginning-of-line)

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region,
copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region,
kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-line (before check-position activate)
  "Kill a line, including whitespace characters
until next non-whiepsace character of next line."
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

;; automatically indenting yanked text if in programming-modes
(defvar yank-indent-modes
  '(LaTeX-mode TeX-mode)
  "Modes in which to indent regions that are yanked (or yank-popped).
Only modes that don't derive from `prog-mode' should be listed here.")

(defvar yank-indent-blacklisted-modes
  '(python-mode slim-mode haml-mode)
  "Modes for which auto-indenting is suppressed.")

(defvar yank-advised-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur.")

(defun yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large."
  (if (<= (- end beg) yank-advised-indent-threshold)
      (indent-region beg end nil)))

(defadvice yank (after yank-indent activate)
  "If current mode is one of 'yank-indent-modes,
indent yanked text (with prefix arg don't indent)."
  (if (and (not (ad-get-arg 0))
           (not (member major-mode yank-indent-blacklisted-modes))
           (or (derived-mode-p 'prog-mode)
               (member major-mode yank-indent-modes)))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end)))))

(defadvice yank-pop (after yank-pop-indent activate)
  "If current mode is one of `yank-indent-modes',
indent yanked text (with prefix arg don't indent)."
  (when (and (not (ad-get-arg 0))
             (not (member major-mode yank-indent-blacklisted-modes))
             (or (derived-mode-p 'prog-mode)
                 (member major-mode yank-indent-modes)))
    (let ((transient-mark-mode nil))
      (yank-advised-indent-function (region-beginning) (region-end)))))

(defun prelude-duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated.
However, if there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (pcase-let* ((origin (point))
               (`(,beg . ,end) (prelude-get-positions-of-line-or-region))
               (region (buffer-substring-no-properties beg end)))
    (-dotimes arg
      (lambda ()
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point))))
    (goto-char (+ origin (* (length region) arg) arg))))

(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defvar prelude-indent-sensitive-modes
  '(coffee-mode python-mode slim-mode haml-mode yaml-mode)
  "Modes for which auto-indenting is suppressed.")

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (unless (member major-mode prelude-indent-sensitive-modes)
    (save-excursion
      (if (region-active-p)
          (progn
            (indent-region (region-beginning) (region-end))
            (message "Indented selected region."))
        (progn
          (indent-buffer)
          (message "Indented buffer.")))
      (whitespace-cleanup))))

(global-set-key (kbd "C-c i") 'indent-region-or-buffer)

;; add duplicate line function from Prelude
(defun prelude-get-positions-of-line-or-region ()
  "Return positions (beg . end) of the current line or region."
  (let (beg end)
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (cons beg end)))

(defun ryutas/kill-buffer () ; require: more test
  "Kill the currently active buffer.
After killing the buffer, avoid skippable-buffers, helm and exwm."
  (interactive)
  (kill-buffer (current-buffer))
  (let ((initial (current-buffer)))
    (catch 'loop
      (while (or (member (buffer-name) my-skippable-buffers)
                 (string= "helm-major-mode" major-mode)
                 (string= "exwm-mode" major-mode))
        (previous-buffer)
        ;; prevent infinite loop
        (when (eq (current-buffer) initial)
          (throw 'loop t))))))

(global-set-key (kbd "C-x k") 'ryutas/kill-buffer)

;; smart openline
(defun prelude-smart-open-line (arg)
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode.
With a prefix ARG open line above the current line."
  (interactive "P")
  (if arg
      (prelude-smart-open-line-above)
    (progn
      (move-end-of-line nil)
      (newline-and-indent))))

(defun prelude-smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "C-o") 'prelude-smart-open-line)
(global-set-key (kbd "M-o") 'open-line)



;; customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "605a6d159ddbdc6613f3b4fb90c79d3efececb1d0befc474b97a74646e7bd698" "54449a089fc2f95f99ebc9b9b6067c802532fd50097cf44c46a53b4437d5c6cc" "25da85b0d62fd69b825e931e27079ceeb9fd041d14676337ea1ce1919ce4ab17" "43b219a31db8fddfdc8fdbfdbd97e3d64c09c1c9fdd5dff83f3ffc2ddb8f0ba0" "ebc35c8e71983b8401562900abb28feedf4d8fcdfcdea35b3da8449d78ebecc6" "54d091c28661aa25516d4f58044412e745eddb50c8e04e3a0788a77941981bb0" "2eb1f5551310e99101f0f9426485ab73aa5386054da877aacd15d438382bb72e" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" default))
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#424242")
 '(helm-completion-style 'emacs)
 '(ibuffer-saved-filter-groups
   '(("test"
      ("helm"
       (used-mode . helm-major-mode))
      ("dired"
       (used-mode . dired-mode))
      ("powerpro"
       (used-mode . ppro-mode))
      ("cmode"
       (used-mode . c-mode))
      ("lisp"
       (used-mode . emacs-lisp-mode)))
     ("test1"
      ("dired"
       (used-mode . dired-mode))
      ("powerpro"
       (used-mode . ppro-mode))
      ("cmode"
       (used-mode . c-mode))
      ("lisp"
       (used-mode . emacs-lisp-mode)))))
 '(ibuffer-saved-filters
   '(("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode))))))
 '(package-selected-packages
   '(moonshot dired-filter dired-open dired-subtree dired-ranger dired-rainbow aggressive-indent perspective esh-autosuggest eshell-git-prompt eshell-prompt-extras eshell-toggle exwm-edit pcmpl-args ace-window magit company-quickhelp helm-themes highlight eval-sexp-fu auto-compile helm-mode-manager ace-jump-helm-line emms-player-mpv-jp-radios helm-w3m w3m pdf-tools multi-term helm-eww eyeliner goto-chg avy-flycheck ace-link helm-swoop vterm ace-mc fzf pcomplete-extension naquadah-theme buffer-expose which-key golen-ratio zoom-window zoom sdcv helm-exwm exwm-config exwm mu4e-alert htmlize anzu xkcd deft undo-tree visible-mark visual-mark scratch swipe use-package-chords dired-narrow peep-dired avy wttrin bm multiple-cursors spaceline-all-the-icons spaceline guide-key shell-pop google-this diminish auto-package-update use-package key-chord edit-server blacken vimrc-mode live-py-mode ein jedi elpy poe-lootfilter-mode yasnippet comment-dwim-2 zygospore sr-speedbar helm-projectile helm-descbinds helm help-mode+ help-fns+ help+ discover-my-major info+ showtip highlight-symbol highlight-numbers nyan-prompt nyan-mode smartparens flycheck ztree expand-region volatile-highlights auto-complete emms rainbow-mode rainbow-delimiters js2-mode))
 '(temp-buffer-resize-mode nil)
 '(time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#d54e53")
     (40 . "#e78c45")
     (60 . "#e7c547")
     (80 . "#b9ca4a")
     (100 . "#70c0b1")
     (120 . "#7aa6da")
     (140 . "#c397d8")
     (160 . "#d54e53")
     (180 . "#e78c45")
     (200 . "#e7c547")
     (220 . "#b9ca4a")
     (240 . "#70c0b1")
     (260 . "#7aa6da")
     (280 . "#c397d8")
     (300 . "#d54e53")
     (320 . "#e78c45")
     (340 . "#e7c547")
     (360 . "#b9ca4a")))
 '(vc-annotate-very-old-color nil)
 '(zoom-ignore-predicates
   '((lambda nil
       (>
        (count-lines
         (point-min)
         (point-max))
        20))))
 '(zoom-ignored-buffer-name-regexps '("^*calc"))
 '(zoom-ignored-buffer-names '("zoom.el"))
 '(zoom-ignored-major-modes '(ediff-mode markdown-mode))
 '(zoom-minibuffer-preserve-layout nil)
 '(zoom-size '(0.75 . 0.75))
 '(zoom-window-mode-line-color "red4"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-mode-line ((t :bold t :foreground "red" :inherit 'mode-line)))
 '(anzu-mode-line-no-match ((t :bold t :foreground "blue" :inherit 'mode-line)))
 '(calendar-today ((t (:underline (:color "SlateBlue1" :style wave)))))
 '(mu4e-modeline-face ((t :bold t :foreground "#3E3D31" :inherit 'mode-line)) t)
 '(rainbow-delimiters-depth-1-face ((t :foreground "white")))
 '(rainbow-delimiters-depth-2-face ((t :foreground "chocolate1")))
 '(rainbow-delimiters-depth-3-face ((t :foreground "aquamarine")))
 '(rainbow-delimiters-depth-4-face ((t :foreground "LimeGreen")))
 '(rainbow-delimiters-depth-5-face ((t :foreground "maroon1")))
 '(rainbow-delimiters-depth-6-face ((t :foreground "DodgerBlue1")))
 '(rainbow-delimiters-depth-7-face ((t :foreground "orange red")))
 '(rainbow-delimiters-depth-8-face ((((class color) (min-colors 89)) (:bold t :foreground "MediumSpringGreen"))))
 '(rainbow-delimiters-depth-9-face ((((class color) (min-colors 89)) (:bold t :foreground "goldenrod"))))
 '(rainbow-delimiters-unmatched-face ((t :foreground "#DF8C8C" :background "#5c9958cc6000"))))



(provide 'init)
;;; init.el ends here

;;  LocalWords:  rofime scccolor sccbuffer
