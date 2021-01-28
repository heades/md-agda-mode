;;; md-agda-mode.el --- Major mode for working with literate Markdown Agda files
;;; -*- lexical-binding: t

;;; Commentary:

;; A Major mode for editing Agda code embedded in Markdown files (.lagda.md files.)

(require 'polymode)
(require 'agda2-mode)

(defgroup md-agda-mode nil
  "md-agda-mode customisations"
  :group 'languages)

(defcustom use-agda-input t
  "Whether to use Agda input mode in non-Agda parts of the file."
  :group 'md-agda-mode
  :type 'boolean)

(define-hostmode poly-md-agda-hostmode
  :mode 'markdown-mode
  :keep-in-mode 'host)

(define-innermode poly-md-agda-innermode
  :mode 'agda2-mode
  :head-matcher "```agda"
  :tail-matcher "```"
  ;; Keep the code block wrappers in Markdown mode, so they can be folded, etc.
  :head-mode 'markdown-mode
  :tail-mode 'markdown-mode
  ;; Disable font-lock-mode, which interferes with Agda annotations,
  ;; and undo the change to indent-line-function Polymode makes.
  :init-functions '((lambda (_) (font-lock-mode 0))
                    (lambda (_) (setq indent-line-function #'indent-relative))))

(define-polymode md-agda-mode
  :hostmode 'poly-md-agda-hostmode
  :innermodes '(poly-md-agda-innermode)
  (when use-agda-input (set-input-method "Agda")))

(assq-delete-all 'background agda2-highlight-faces)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.lagda.md" . md-agda-mode))

(provide 'md-agda-mode)
;;; md-agda-mode ends here
