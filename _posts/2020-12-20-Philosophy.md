---
layout: post
title: "The principles guiding umx"
date: 2020-12-20 00:00
comments: true
categories: models tutorial
---

<a name="top"></a>

A principle can be a great guide to keeping practice aligned with some specific goals that you will appreciate. 

Our principle in designing `umx` is that it should function as a *domain specific language for expressing causal hypotheses*.

That's the answer to "Why this package?": To make modeling easier.

`umx` will help you:

1. Express theories of causes and effects in SEM models.
2. Contrast competing theories.
3. Maintain a reproducible and correct workflow.
4. Get results rapidly and communicate them effectively.

To this end, `umx` provides a compact vocabulary of functions for doing these four things as fast as possible.

Of course, OpenMx is a fantastic base, and there are, therefore, often cases where you'll stick with core OpenMx functions: Using mxPath instead of umxPath, or summary instead of umxSummary.

That said, R has too many cases where "you can do it lots of ways". We want `umx` to provide just one way that makes your work easier so you do better science.

That's it :-) On to the modeling!