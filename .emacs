;;  ____    _____   ______      ____             ______  ____     ____
;; /\  _`\ /\  __`\/\__  _\    /\  _`\   /'\_/`\/\  _  \/\  _`\  /\  _`\
;; \ \ \/\ \ \ \/\ \/_/\ \/    \ \ \L\_\/\      \ \ \L\ \ \ \/\_\\ \,\L\_\
;;  \ \ \ \ \ \ \ \ \ \ \ \     \ \  _\L\ \ \__\ \ \  __ \ \ \/_/_\/_\__ \
;;   \ \ \_\ \ \ \_\ \ \ \ \     \ \ \L\ \ \ \_/\ \ \ \/\ \ \ \L\ \ /\ \L\ \
;;    \ \____/\ \_____\ \ \_\     \ \____/\ \_\\ \_\ \_\ \_\ \____/ \ `\____\
;;     \/___/  \/_____/  \/_/      \/___/  \/_/ \/_/\/_/\/_/\/___/   \/_____/

;;Alright bitches the date is 2-8-17
;;This is a revised version of my old .emacs and .emacs.d
;;Company and irony mode WORK!
;;I removed alot of clutter and shit I didnt need (ie old windows shit from my original emacs setup)
;; also removed some old code in here I never use

;;Load theme
(load "/home/shenty/.emacs.d/solarized.el")

;;important stuff
(global-set-key (kbd "<f5>") 'compile)
(setq debug-on-error t) ;;was important? not sure what it does anymore
(setq auto-save-default nil) ;;dont want them pesky ~
(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(ido-mode 1)
(global-linum-mode t)
(setq visible-bell 0) ;;sounds suck
(setq frame-title-format "emacs - <(-^.^-)>.")
(display-battery-mode)
(display-time-mode)
(column-number-mode)
(defalias 'qrr 'query-replace-regexp) ;;qrr is nice tool
(set-face-attribute 'default nil :height 105) ;;small text is nice but not too small
(global-hl-line-mode) ;;where my cursor at
(desktop-save-mode 1) ;;save muh desktop
;;(global-company-mode)


;;theme
(require 'solarized)
(deftheme solarized-dark "The dark variant of the Solarized colour theme")
(create-solarized-theme 'dark 'solarized-dark)
(provide-theme 'solarized-dark)


;;java hook
(add-hook 'java-mode-hook (lambda ()
                            (setq c-default-style "bsd")
                            (setq c-basic-offset 2)
                            (setq tab-width 2)
                            (auto-fill-mode))
          (local-set-key [f6] 'javadoc-method-comment))




;;IRONY DO NOT TOUCH
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (yasnippet popup company-irony))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;print lines take too long
(defun println ()
  (interactive)
  (insert "System.out.println(\"\");")
  (backward-char 3))

(defun cout ()
  (interactive)
  (insert "cout << \"\" << endl;")
  (backward-char 10))
(defun printf()
  (interactive)
  (insert "printf(\"\");")
  (backward-char 3))

;;stole this from somewhere we dont uses mouses around here
(define-minor-mode disable-mouse-mode
  "A minor-mode that disables all mouse keybinds."
  :global t
  :lighter " 🐭"
  :keymap (make-sparse-keymap))

(dolist (type '(mouse down-mouse drag-mouse
                      double-mouse triple-mouse))
  (dolist (prefix '("" C- M- S- M-S- C-M- C-S- C-M-S-))
    ;; Yes, I actually HAD to go up to 7 here.
    (dotimes (n 7)
      (let ((k (format "%s%s-%s" prefix type n)))
        (define-key disable-mouse-mode-map
          (vector (intern k)) #'ignore)))))
(disable-mouse-mode 1)

;;update: honestly the best piece of code ever written
(defun iwb () ;;greatest invention since betty white
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun cmake ()
  (interactive)

  (shell-command "cd cmake && cmake -H. -Bbuild && cmake --build build -- -j3"))

(defun generate-cmake ()
  (interactive)
  (if (not (file-directory-p "cmake"))
      (shell-command "mkdir cmake && cd cmake"))

  (find-file "cmake/CMakeLists.txt")
  (if (not (file-exists-p "cmake/CMakeLists.txt"))
      (insert "# Specify the minimum version for CMake
cmake_minimum_required(VERSION 2.8)

# Project's name

project(hello)
# Set the output folder where your program will be created
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# The following folder will be included
include_directories(\"${PROJECT_SOURCE_DIR}\")

#add_executable(exifviewer ${PROJECT_SOURCE_DIR}/../file.c)")
    (save-buffer))
  (message "Please add all files and objects, modify this file"))


(defun cmake-add-executable
    (interactive)
  ;;implement
  )
(defun cmake-add-library
    (interactive)
  ;;implement
  )
(defun cmake-add-header
    (interactive)
  ;;implement
  )
(defun cmake-add-obj
    (interactive)
  ;;implement
  )





