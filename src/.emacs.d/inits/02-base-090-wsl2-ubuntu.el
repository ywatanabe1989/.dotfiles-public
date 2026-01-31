;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-04 16:25:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-090-wsl2-ubuntu.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; -*- lexical-binding: t -*-
;; https://emacsredux.com/blog/2021/12/19/using-emacs-on-windows-11-with-wsl2/
;; $ git clone git://git.sv.gnu.org/emacs.git
;; $ sudo apt install build-essential libgtk-3-dev libgnutls28-dev libtiff5-dev libgif-dev libjpeg-dev libpng-dev libxpm-dev libncurses-dev texinfo
;; $ cd emacs
;; $ ./autogen.sh
;; $ ./configure # --with-pgtk
;; $ make -j8
;; $ sudo make install

(pixel-scroll-precision-mode)

(defun copy-selected-text (start end)
  (interactive "r")
  (if (use-region-p)
      (let ((text (buffer-substring-no-properties start end)))
        (shell-command (concat "echo '" text "' | clip.exe")))))

(defun wsl-copy (start end)
  (interactive "r")
  (shell-command-on-region start end "clip.exe")
  (deactivate-mark))

(defun wsl-paste ()
  (interactive)
  (let ((clipboard
         (shell-command-to-string
          "powershell.exe -command 'Get-Clipboard' 2> /dev/null")))
    (when (and clipboard (> (length clipboard) 0))
      (setq clipboard (replace-regexp-in-string "\r" "" clipboard))
      ;; Remove trailing newline if exists
      (when (string-suffix-p "\n" clipboard)
        (setq clipboard (substring clipboard 0 -1)))
      (insert clipboard))))

(defun wsl-clipboard-debug ()
  "Debug what's in the Windows clipboard."
  (interactive)
  (let* ((ps-script "
Add-Type -AssemblyName System.Windows.Forms
$data = [Windows.Forms.Clipboard]::GetDataObject()
if ($data) {
    Write-Host 'Clipboard formats:'
    $data.GetFormats() | ForEach-Object { Write-Host \"  - $_\" }
    Write-Host ''
    Write-Host \"ContainsImage: $([Windows.Forms.Clipboard]::ContainsImage())\"
    Write-Host \"ContainsText: $([Windows.Forms.Clipboard]::ContainsText())\"
    Write-Host \"ContainsFileDropList: $([Windows.Forms.Clipboard]::ContainsFileDropList())\"
    if ([Windows.Forms.Clipboard]::ContainsFileDropList()) {
        Write-Host 'Files:'
        [Windows.Forms.Clipboard]::GetFileDropList() | ForEach-Object { Write-Host \"  - $_\" }
    }
} else {
    Write-Host 'Clipboard is empty or inaccessible'
}
")
         (output (shell-command-to-string
                  (format "powershell.exe -NoProfile -Command %s"
                          (shell-quote-argument ps-script)))))
    (with-output-to-temp-buffer "*WSL Clipboard Debug*"
      (princ "Windows Clipboard Contents:\n")
      (princ "===========================\n\n")
      (princ output))))

(defvar wsl-yank-image-max-retries 5
  "Maximum number of retries for WSL clipboard operations.")

(defvar wsl-yank-image-retry-delay 1.0
  "Delay in seconds between retry attempts.")

(defun wsl--call-powershell-with-retry (ps-file &optional retries)
  "Call PowerShell script PS-FILE with retry logic.
RETRIES defaults to `wsl-yank-image-max-retries'."
  (let ((max-retries (or retries wsl-yank-image-max-retries))
        (attempt 0)
        (windows-ps-file (string-trim
                          (shell-command-to-string
                           (format "wslpath -w '%s' 2>/dev/null"
                                   ps-file))))
        exit-code)
    (while (and (< attempt max-retries)
                (or (null exit-code) (not (= 0 exit-code))))
      (when (> attempt 0)
        (message "WSL clipboard retry %d/%d..." attempt max-retries)
        (sleep-for wsl-yank-image-retry-delay))
      (setq exit-code
            (call-process "powershell.exe" nil nil nil
                          "-ExecutionPolicy" "Bypass"
                          "-File" windows-ps-file))
      (setq attempt (1+ attempt)))
    exit-code))

(defun wsl-yank-image ()
  "Yank image from Windows clipboard history and insert into buffer.
Searches clipboard history for the most recent image, not just current clipboard.
In vterm, prompts for host selection (localhost or remote) like ecc-vterm-yank-as-file.
In other buffers, inserts as image or file link.
Saves to /tmp for compatibility with remote hosts."
  (interactive)
  (let* ((timestamp (format-time-string "%Y%m%d-%H%M%S"))
         (filename (format "clipboard-image-%s.png" timestamp))
         ;; Final destination in Linux /tmp (works for remote transfer)
         (linux-temp-file (format "/tmp/%s" filename))
         ;; Intermediate Windows temp location for PowerShell
         (windows-temp-file (format "C:\\Temp\\%s" filename))
         (wsl-windows-temp-file (format "/mnt/c/Temp/%s" filename))
         ps-file ps-exit-code)
    ;; Ensure C:\Temp exists
    (unless (file-directory-p "/mnt/c/Temp")
      (make-directory "/mnt/c/Temp" t))
    ;; Create PowerShell script in Windows temp (avoids wslpath issues)
    (setq ps-file (format "/mnt/c/Temp/clipboard-%s.ps1" timestamp))
    (let* ((ps-script (format "
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$outputPath = '%s'

function Save-ImageFromClipboard {
    $img = [Windows.Forms.Clipboard]::GetImage()
    if ($img) {
        $img.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $img.Dispose()
        return $true
    }
    return $false
}

function Get-ClipboardHistoryImage {
    param([int]$MaxItems = 10)

    # Load WinRT clipboard type
    [void][Windows.ApplicationModel.DataTransfer.Clipboard, Windows, ContentType=WindowsRuntime]

    # Use reflection to call AsTask extension method
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
    $asTaskMethod = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
        $_.Name -eq 'AsTask' -and
        $_.GetParameters().Count -eq 1 -and
        $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
    } | Select-Object -First 1

    $asyncOp = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()
    $resultType = [Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult]

    $genericMethod = $asTaskMethod.MakeGenericMethod($resultType)
    $task = $genericMethod.Invoke($null, @($asyncOp))
    $task.Wait()
    $historyResult = $task.Result

    Write-Host \"[DEBUG] History status: $($historyResult.Status)\"

    if (\"$($historyResult.Status)\" -ne 'Success') {
        return $false
    }

    $items = $historyResult.Items
    $itemCount = 0
    foreach ($i in $items) { $itemCount++ }
    Write-Host \"[DEBUG] Found $itemCount items in history\"

    $idx = 0
    foreach ($item in $items) {
        if ($idx -ge $MaxItems) { break }

        $content = $item.Content
        $formatList = @()
        foreach ($f in $content.AvailableFormats) { $formatList += $f }
        $formats = $formatList -join ', '
        Write-Host \"[DEBUG] Item $idx formats: $formats\"

        if ($content.Contains('Bitmap')) {
            Write-Host \"[DEBUG] Item $idx has Bitmap, setting to current clipboard...\"
            $setResult = [Windows.ApplicationModel.DataTransfer.Clipboard]::SetHistoryItemAsContent($item)
            Write-Host \"[DEBUG] SetHistoryItemAsContent result: $setResult\"

            if (\"$setResult\" -eq 'Success') {
                Start-Sleep -Milliseconds 300
                if (Save-ImageFromClipboard) {
                    Write-Host \"[DEBUG] Successfully saved image from history item $idx\"
                    return $true
                }
            }
        }
        $idx++
    }
    return $false
}

# First try current clipboard
Write-Host '[DEBUG] Checking current clipboard...'
if (Save-ImageFromClipboard) {
    Write-Host '[DEBUG] Image saved from current clipboard'
    exit 0
}

Write-Host '[DEBUG] No image in current clipboard, checking history...'

# Try clipboard history
try {
    if (Get-ClipboardHistoryImage) {
        exit 0
    }
} catch {
    Write-Host \"[DEBUG] Clipboard history error: $($_.Exception.Message)\"
    Write-Host \"[DEBUG] Stack trace: $($_.ScriptStackTrace)\"
}

Write-Host '[DEBUG] No image found'
exit 1
"
                              windows-temp-file)))
      ;; Write PowerShell script to file
      (with-temp-file ps-file
        (insert ps-script))
      (unwind-protect
          (progn
            ;; Use Windows path directly for PowerShell
            (setq ps-exit-code
                  (wsl--call-powershell-with-retry-windows
                   (format "C:\\Temp\\clipboard-%s.ps1" timestamp)))
            (cond
             ((not (= 0 ps-exit-code))
              (message
               "No image in Windows clipboard (exit code: %d after %d retries)"
               ps-exit-code wsl-yank-image-max-retries))
             ((not (file-exists-p wsl-windows-temp-file))
              (message
               "PowerShell succeeded but image file not found: %s"
               wsl-windows-temp-file))
             ;; Success - copy to Linux /tmp then handle based on mode
             (t
              ;; Move from Windows temp to Linux /tmp
              (copy-file wsl-windows-temp-file linux-temp-file t)
              (delete-file wsl-windows-temp-file)
              (cond
               ((eq major-mode 'vterm-mode)
                (wsl--yank-image-to-vterm linux-temp-file))
               ((eq major-mode 'org-mode)
                (insert (format "[[file:%s]]\n" linux-temp-file))
                (org-display-inline-images)
                (message "Image inserted: %s" linux-temp-file))
               ((display-graphic-p)
                (insert-image (create-image linux-temp-file))
                (insert "\n")
                (message "Image inserted: %s" linux-temp-file))
               (t
                (insert linux-temp-file)
                (message "Image saved to: %s" linux-temp-file))))))
        ;; Clean up PowerShell script file
        (when (file-exists-p ps-file)
          (delete-file ps-file))))))

(defun wsl--call-powershell-with-retry-windows
    (windows-ps-path &optional retries)
  "Call PowerShell script at WINDOWS-PS-PATH (Windows path format) with retry.
RETRIES defaults to `wsl-yank-image-max-retries'.
Handles intermittent WSL2 connection errors (accept4 failed 110)."
  (let ((max-retries (or retries wsl-yank-image-max-retries))
        (attempt 0)
        (output-buffer (get-buffer-create "*WSL PowerShell Output*"))
        exit-code
        last-output)
    (with-current-buffer output-buffer
      (erase-buffer))
    (while (and (< attempt max-retries)
                (or (null exit-code) (not (= 0 exit-code))))
      (when (> attempt 0)
        (message "WSL clipboard retry %d/%d (previous exit: %d)..."
                 attempt max-retries (or exit-code -1))
        (sleep-for wsl-yank-image-retry-delay))
      (with-current-buffer output-buffer
        (erase-buffer))
      (setq exit-code
            (call-process "powershell.exe" nil output-buffer nil
                          "-ExecutionPolicy" "Bypass"
                          "-File" windows-ps-path))
      (with-current-buffer output-buffer
        (setq last-output (buffer-string)))
      (setq attempt (1+ attempt)))
    ;; Show debug output if failed
    (when (not (= 0 exit-code))
      (with-current-buffer output-buffer
        (goto-char (point-min))
        (insert (format "Exit code: %d\nScript: %s\nAttempts: %d\n\n"
                        exit-code windows-ps-path attempt)))
      (display-buffer output-buffer))
    exit-code))

(defun wsl--yank-image-to-vterm (local-file)
  "Send image LOCAL-FILE to vterm, with option to transfer to remote server.
Prompts for host selection like ecc-vterm-yank-as-file."
  (if (require 'ecc-remote nil t)
      (let ((ssh-info (--ecc-get-ssh-info-from-selection)))
        (if ssh-info
            ;; Remote host selected - transfer file
            (let* ((target-host (cdr (assq 'host ssh-info)))
                   (target-dir (if (fboundp '--ecc-get-yank-directory)
                                   (--ecc-get-yank-directory t)
                                 "/tmp/emacs-claude-code/"))
                   (remote-local-path
                    (concat target-dir
                            (file-name-nondirectory local-file))))
              (if
                  (--ecc-transfer-file-to-remote local-file ssh-info
                                                 target-dir)
                  (progn
                    (wsl--send-read-image-command remote-local-path
						  target-host)
                    (message "Image transferred to remote: %s"
                             remote-local-path))
                (message "Failed to transfer image to remote server")))
          ;; localhost selected - use local file
          (wsl--send-read-image-command local-file)
          (message "Image saved locally: %s" local-file)))
    ;; ecc-remote not available - use local file
    (wsl--send-read-image-command local-file)
    (message "Image saved to: %s" local-file)))

(defun wsl--send-read-image-command (filepath &optional target-host)
  "Send a Read command with image FILEPATH to the vterm buffer.
TARGET-HOST is the name of the host where the file resides."
  (let* ((host-display (or target-host "localhost"))
         (command
          (format
           "\n\n1. Read or view (%s)\n%s\n2. Understand user's intent.\n3. Move to action."
           host-display
           filepath)))
    (if (fboundp 'vterm-send-string)
        (vterm-send-string command)
      (message "vterm not available, command would be: %s" command))))

(defun wsl-yank-image-to-file (directory)
  "Save image from Windows clipboard to a file in DIRECTORY.
Prompts for directory if called interactively."
  (interactive "DSave image to directory: ")
  (let* ((timestamp (format-time-string "%Y%m%d-%H%M%S"))
         (filename (format "clipboard-image-%s.png" timestamp))
         (output-file (expand-file-name filename directory))
         ;; Ensure directory exists
         (_ (unless (file-directory-p directory)
              (make-directory directory t)))
         ;; Convert WSL path to Windows path
         (wslpath-result (shell-command-to-string
                          (format "wslpath -w '%s' 2>&1" output-file)))
         (windows-path (string-trim wslpath-result))
         ps-file ps-exit-code)
    ;; Check wslpath succeeded
    (when (or (string-match-p "Invalid" windows-path)
              (string-match-p "error" windows-path)
              (string= "" windows-path))
      (error "wslpath failed for %s: %s" output-file windows-path))
    ;; Create PowerShell script
    (setq ps-file (make-temp-file "clipboard-" nil ".ps1"))
    (let* ((windows-ps-file (string-trim
                             (shell-command-to-string
                              (format "wslpath -w '%s'" ps-file))))
           (ps-script (format "Add-Type -AssemblyName System.Windows.Forms
$img = [Windows.Forms.Clipboard]::GetImage()
if ($img) {
    $img.Save('%s', [System.Drawing.Imaging.ImageFormat]::Png)
    exit 0
} else {
    exit 1
}"
                              windows-path)))
      ;; Write PowerShell script to file
      (with-temp-file ps-file
        (insert ps-script))
      (unwind-protect
          (progn
            (setq ps-exit-code
                  (call-process "powershell.exe" nil nil nil
                                "-ExecutionPolicy" "Bypass"
                                "-File" windows-ps-file))
            (cond
             ((not (= 0 ps-exit-code))
              (message "No image in Windows clipboard (exit code: %d)"
                       ps-exit-code)
              nil)
             ((not (file-exists-p output-file))
              (message
               "PowerShell succeeded but image file not found: %s"
               output-file)
              nil)
             (t
              (message "Image saved to: %s" output-file)
              output-file)))
        ;; Clean up PowerShell script file
        (when (file-exists-p ps-file)
          (delete-file ps-file))))))

(defun dired-open-in-windows-explorer ()
  "Open current directory in Windows Explorer from WSL."
  (interactive)
  (let* ((path (shell-command-to-string "pwd"))
         (wsl-path (my/path-get-dir))
         ;; (wsl-path (replace-regexp-in-string "\n$" "" path))
         (windows-path
          (shell-command-to-string (concat "wslpath -w " wsl-path))))
    (start-process "" nil "/mnt/c/Windows/explorer.exe"
                   (replace-regexp-in-string "\n$" "" windows-path))))

(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "C-c e")
              'dired-open-in-windows-explorer))

(setq create-lockfiles nil)

(global-set-key (kbd "C-c C-w") 'wsl-copy)

(global-set-key (kbd "C-c C-i") 'wsl-yank-image)

(global-set-key (kbd "C-c C-S-i") 'wsl-yank-image-to-file)

(provide '02-base-090-wsl2-ubuntu)

(when
    (not load-file-name)
  (message "02-base-090-wsl2-ubuntu.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
