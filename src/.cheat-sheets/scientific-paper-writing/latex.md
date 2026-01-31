# LaTeX Cheat Sheet

## Basic Document Structure
```tex
\documentclass{article}
\usepackage{packages}

\begin{document}
    Your content here
\end{document}
```

## Text Formatting and Basic Notations
| Formatting | LaTeX Code | Basic Notation | LaTeX Code |
|------------|------------|----------------|------------|
| Bold | `\textbf{text}` | Line break | `\\` |
| Italic | `\textit{text}` | Indent | `\indent` |
| Underline | `\underline{text}` | Page break | `\pagebreak` |
| Space | `\ ` | New paragraph | `\par` |
| Non-breaking space | `~` | Left quote | `` ` `` |
| Horizontal space | `\hspace{1cm}` | Right quote | `'` |
| Vertical space | `\vspace{1cm}` | Em dash | `---` |
| Superscript | `$x^2$` | En dash | `--` |
| Subscript | `$x_2$` | Ellipsis | `\ldots` |
| | | Degree symbol | `$^\circ$` |

## Sections
- `\section{Title}`
- `\subsection{Subtitle}`
- `\subsubsection{Subsubtitle}`

## Lists
### Unordered List
```tex
\begin{itemize}
    \item First item
    \item Second item
\end{itemize}
```

### Ordered List
```tex
\begin{enumerate}
    \item First item
    \item Second item
\end{enumerate}
```

## Math Mode
- Inline math: `$equation$`
- Display math: 
```tex
\[
    equation
\]
```

### Common Mathematical Symbols and Notations

| Symbol | LaTeX Code | Label | Symbol | LaTeX Code | Label |
|--------|------------|------|--------|------------|------|
| ≤      | `$\leq$`   | Less than or equal | ≥      | `$\geq$`   | Greater than or equal |
| ≠      | `$\neq$`   | Not equal | ≈      | `$\approx$`| Approximately equal |
| ±      | `$\pm$`    | Plus-minus | ×      | `$\times$` | Times |
| ÷      | `$\div$`   | Division | ∑      | `$\sum$`   | Summation |
| ∏      | `$\prod$`  | Product | ∫      | `$\int$`   | Integral |
| ∞      | `$\infty$` | Infinity | √      | `$\sqrt{}$`| Square root |
| ∂      | `$\partial$`| Partial derivative | ⊂     | `$\subset$`| Subset |
| ∈      | `$\in$`    | Element of | ∪      | `$\cup$`   | Union |
| ∩      | `$\cap$`   | Intersection | α      | `$\alpha$` | Alpha |
| β      | `$\beta$`  | Beta | γ      | `$\gamma$` | Gamma |
| δ      | `$\delta$` | Delta | ε      | `$\epsilon$`| Epsilon |
| π      | `$\pi$`    | Pi | $\vec{a}$ | `$\vec{a}$` | Vector |
| $\hat{a}$ | `$\hat{a}$` | Hat | $\overrightarrow{AB}$ | `$\overrightarrow{AB}$` | Arrow |
| $\cdot$ | `$\cdot$` | Dot product | $\nabla$ | `$\nabla$` | Nabla |
| $x^2$  | `$x^2$`    | Superscript | $x_i$  | `$x_i$`    | Subscript |
| $x^{y+z}$ | `$x^{y+z}$` | Complex superscript | $x_{i,j}$ | `$x_{i,j}$` | Complex subscript |
| ∇      | `$\nabla$` | Nabla | ∆      | `$\Delta$` | Delta |
| ∅      | `$\emptyset$` | Empty set | ∀   | `$\forall$`| For all |
| ∃      | `$\exists$`| Exists | ¬      | `$\neg$`   | Negation |
| ∧      | `$\wedge$` | Logical AND | ∨      | `$\vee$`   | Logical OR |
| ⇒      | `$\Rightarrow$` | Implies | ⇔ | `$\Leftrightarrow$` | If and only if |
| ℝ      | `$\mathbb{R}$` | Real numbers | ℕ  | `$\mathbb{N}$` | Natural numbers |
| ℤ      | `$\mathbb{Z}$` | Integers | ℚ  | `$\mathbb{Q}$` | Rational numbers |
| ∘      | `$\circ$`  | Composition | ⊕      | `$\oplus$` | Direct sum |
| ⊗      | `$\otimes$`| Tensor product | ⊥      | `$\perp$`  | Perpendicular |
| ∥      | `$\parallel$` | Parallel | ≡   | `$\equiv$` | Equivalent |
| ∝      | `$\propto$`| Proportional to | ∠      | `$\angle$` | Angle |

## Tables
```tex
\begin{table}
    \centering
    \begin{tabular}{|c|c|}
        \hline
        Cell 1 & Cell 2 \\
        \hline
        Cell 3 & Cell 4 \\
        \hline
    \end{tabular}
    \caption{Table caption}
    \label{tab:mytable}
```

## Figures
```tex
\begin{figure}
    \centering
    \includegraphics[width=0.8\textwidth]{image.png}
    \caption{Figure caption}
    \label{fig:myfigure}
\end{figure}
```

## References
- Cite: `\cite{key}`
- Label: `\label{sec:section}`
- Reference: `\ref{sec:section}`

## Bibliography
```tex
\bibliographystyle{plain}
\bibliography{references}
```
