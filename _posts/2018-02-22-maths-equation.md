---
layout: post
title:  "Maths equation example"
date:   2018-02-22
tags: [jekyll, maths]
---

Add this in the _layout/page.hmtm:
~~~~~~
<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
~~~~~~

Then, add this in the _layout/post.html:
~~~~~~
<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
~~~~~~

That's it. Now we can use Mathjax as follow:

1) Example
$$ 5 + 5 $$

2) Example
\$$ 5 + 5 $$

3) Example
$$ a^2 + b^2 = c^2 $$

4) Example
$$
\begin{align*}
  & \phi(x,y) = \phi \left(\sum_{i=1}^n x_ie_i, \sum_{j=1}^n y_je_j \right)
  = \sum_{i=1}^n \sum_{j=1}^n x_i y_j \phi(e_i, e_j) = \\
  & (x_1, \ldots, x_n) \left( \begin{array}{ccc}
      \phi(e_1, e_1) & \cdots & \phi(e_1, e_n) \\
      \vdots & \ddots & \vdots \\
      \phi(e_n, e_1) & \cdots & \phi(e_n, e_n)
    \end{array} \right)
  \left( \begin{array}{c}
      y_1 \\
      \vdots \\
      y_n
    \end{array} \right)
\end{align*}
$$

5) Example
\$$\frac{a}{b} = 1$$

6) Example:
\$$\frac{(n^2+n)(2n+1)}{6}$$

