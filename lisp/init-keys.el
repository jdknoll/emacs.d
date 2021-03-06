;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphene Keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x k")
                'kill-default-buffer)
(global-set-key (kbd "C-x C-k")
                'kill-buffer-and-window)
(global-set-key (kbd "C-c n")
                'create-new-buffer)
(global-set-key (kbd "C-c N")
                'new-emacs-instance)
(global-set-key (kbd "C-;")
                'insert-semicolon-at-end-of-line)
(global-set-key (kbd "M-RET")
                'newline-anywhere)
(global-set-key (kbd "C-M-;")
                'comment-current-line-dwim)
(global-set-key (kbd "C->")
                'increase-window-height)
(global-set-key (kbd "C-<")
                'decrease-window-height)
(global-set-key (kbd "C-,")
                'decrease-window-width)
(global-set-key (kbd "C-.")
                'increase-window-width)
(global-set-key (kbd "M-x")
                'smex)
(global-set-key (kbd "M-X")
                'smex-major-mode-commands)
(global-set-key (kbd "C-c s")
                'sr-speedbar-select-window)
(provide 'init-keys)
