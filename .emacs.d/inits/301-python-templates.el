(defvar argparse-template
"    import argparse
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('--var', '-v', type=int, choices=None, default=1, help='(default: %(default)s)')
    parser.add_argument('--flag', '-f', action='store_true', choices=None, default=False, help='(default: %(default)s)')
    args = parser.parse_args()
    mngs.gen.print_block(args, c='yellow')
"
  "Python template for mngs projects.")

(defvar plot-template
"fig, ax = mngs.plt.subplots()
fig, axes = mngs.plt.subplots()
axes_flat = axes.flatten()
"
  "Python template for mngs projects.")

(defvar warnings-template
"with warnings.catch_warnings():
    warnings.simplefilter(\"ignore\", UserWarning)
"
  "Python template for mngs projects.")
    
;; # Time-stamp: %s (ywatanabe)  
(defvar python-template
"#!./env/bin/python3
# -*- coding: utf-8 -*-
# Time-stamp: \"%s (%s)\"
# %s


\"\"\"
This script does XYZ.
\"\"\"


\"\"\"
Imports
\"\"\"
import os
import re
import sys

import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import mngs
mngs.gen.reload(mngs)
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.nn.functional as F
from icecream import ic
from natsort import natsorted
from glob import glob
from pprint import pprint
import warnings
from tqdm import tqdm
import xarray as xr

# sys.path = [\".\"] + sys.path
# from scripts import utils, load

\"\"\"
Warnings
\"\"\"
# warnings.simplefilter(\"ignore\", UserWarning)


\"\"\"
Config
\"\"\"
# CONFIG = mngs.gen.load_configs()


\"\"\"
Functions & Classes
\"\"\"
def main():
    pass

if __name__ == '__main__':
    # # Argument Parser
    # import argparse
    # parser = argparse.ArgumentParser(description='')
    # parser.add_argument('--var', '-v', type=int, default=1, help='')
    # parser.add_argument('--flag', '-f', action='store_true', default=False, help='')
    # args = parser.parse_args()

    # Main
    CONFIG, sys.stdout, sys.stderr, plt, CC = mngs.gen.start(sys, plt, verbose=False)
    main()
    mngs.gen.close(CONFIG, verbose=False, notify=False)

# EOF
"
  "Python template for mngs projects.")

;; (defun py/insert-template ()
;;   "Inserts the Python template and replaces placeholders."
;;   (interactive)
;;   (let ((filename (buffer-file-name)))
;;     (if filename
;;         (progn
;;           (insert (format python-template
;;                           (format-time-string "%Y-%m-%d %H:%M:%S")
;;                           (user-login-name)
;;                           (file-name-nondirectory filename)))
;;           (message "Template inserted with filename."))
;;       (message "Buffer is not associated with a file."))))


(defun py/insert-template ()
 "Inserts the Python template and replaces placeholders."
 (interactive)
 (let ((filename (buffer-file-name)))
   (if filename
       (progn
         (message "Debug: Time - %s" (format-time-string "%Y-%m-%d %H:%M:%S"))
         (message "Debug: User - %s" (user-login-name))
         (message "Debug: File - %s" (file-name-nondirectory filename))
         (insert (format python-template
                         (format-time-string "%Y-%m-%d %H:%M:%S")
                         (user-login-name)
                         (file-name-nondirectory filename)))
         (message "Template inserted with filename."))
     (message "Buffer is not associated with a file."))))

;; (defun py/insert-template ()
;;   (interactive)  
;;   "Inserts the predefined Python template at the current point."
;;   (unless (eq major-mode 'python-mode)
;;     (error "Not in Python mode"))
;;   (insert python-template))

(defun py/insert-argparse-template ()
  (interactive)  
  "Inserts the predefined Python template at the current point."
  (unless (eq major-mode 'python-mode)
    (error "Not in Python mode"))
  (insert argparse-template))

(defun py/insert-plot-template ()
  (interactive)  
  "Inserts the predefined Python template at the current point."
  (unless (eq major-mode 'python-mode)
    (error "Not in Python mode"))
  (insert plot-template))

(defun py/insert-warnings-template ()
  (interactive)  
  "Inserts the predefined Python template at the current point."
  (unless (eq major-mode 'python-mode)
    (error "Not in Python mode"))
  (insert warnings-template))

(defun py/insert-if-name-main ()
  (interactive)  
  (insert "if __name__ == '__main__':")
  (newline-and-indent)
  )

(defun py/insert-ipdb ()
  (interactive)
  ;; (insert "#fmt: off \nimport ipdb; ipdb.set_trace()\n#fmt: on")
  (insert "__import__(\"ipdb\").set_trace()")
  )
    
