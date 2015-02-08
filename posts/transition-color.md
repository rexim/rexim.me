title: Transition Color
author: rexim
date: Sat, 19 Apr 2014 20:20:06 +0700
description: A post about transition color effect.

The reason to write this post was a simple desire to code something
and write about it :)

So, the task is to implement transition color effect. We have to make
an object smoothly change its color from some initial color to some
target color during fixed time. We will use RGB color space.

In RGB space a color is a 3D point. The first coordinate is red
component of the color, the second one is green and the third one is
blue. On the input of our transition color algorithm we have the
initial color $S(R_S, G_S, B_S)$, the target color $T(R_T, G_T, B_T)$
and duration of the transition $D$.

We are going to reach the target color from the initial color in $N$
steps. Let's name them as _transition steps_.

Let $d_i$ be the duration of $i$-th transition step. Here are some
properties of $d_i$:
$$
\\begin{array}{c}
d_i \leq D; \\\\
\sum\limits_{i = 1}^N d_i = D;
\\end{array}
$$

Thus, $\frac{d_i}{D}$ is a part of the whole way from the initial
color to the target color contributed by $i$-th transition step. After
$i$ transition steps we have walked $F_i$ of the whole path where

$$
F_i = \sum\limits_{j = 1}^i \frac{d_i}{D};
$$

Let $W_i$ be the color on the $i$-th transition step, then

$$
\\begin{array}{c}
W_i = (R_i, G_i, B_i); \\\\
R_i = R_S + F_i \cdot (R_T - R_S); \\\\
G_i = G_S + F_i \cdot (G_T - G_S); \\\\
B_i = B_S + F_i \cdot (B_T - B_S);
\\end{array}
$$

To make the transition color effect we are just walking through the
$N$ transition steps until $W_i = T$. This can be easily implemented
as a computer
algorithm. [Here](https://github.com/rexim/transition-color) is my
implementation. Let's take a look at the screenshot of the UI:

![Transition Color Implementation](/images/transition-color-implementation.png)

The big rectangle shows the current color, the small one shows the
target color. We can change the target color with the sliders. After
pressing the "Go" button, the big rectangle will smoothly change its
color according to the given target color.

That's it!
