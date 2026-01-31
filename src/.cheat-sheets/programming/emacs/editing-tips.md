<!-- ---
!-- title: ./.cheat-sheets/programming/emacs/editing-tips.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:54:05
!-- --- -->

# Emacs Editing Tips

## Numbering

### Basic Methods
1. Using `rectangle-number-lines` (built-in)
```
C-x r N    ; Prompts for start number and format
```

2. Using `string-insert-rectangle` 
```
C-x r t    ; Then paste numbers
1
2
3
```

### Replace with Numbers
```elisp
;; Replace XX with 1,2,3...
M-x query-replace-regexp
From: XX
To: \,(number-to-string (1+ \#))

;; Replace XX with 01,02,03...
From: XX
To: \,(format "%02d" (1+ \#))

;; Replace XX with 001,002,003...
From: XX
To: \,(format "%03d" (1+ \#))

;; Replace only specific matches (e.g., AAA) with numbers
From: \(AAA\)
To: \,(format "%03d" (1+ \#))
```

### Macro Methods
```
;; Basic counter
F3
C-x C-k C-i ; Insert counter
C-j
F4
C-u 10 F4   ; For 1,2,3...

;; With padding (01,02,03)
F3
C-u 2 C-x C-k C-i  ; 2-digit padding
C-j
F4
C-u 10 F4
```
