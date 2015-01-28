---
layout: post
title: "The umx principle"
date: 2020-12-20 00:00
comments: true
categories: models tutorial
---

<a name="top"></a>

A principle can be a great guide to keep practice aligned with goals.

Our principle in designing `umx` is that it should be the best possible language for expressing causal hypotheses.

That's the answer to "Why this package?": To make modeling easier by giving you a vocabulary that will help you:

1. Express theories in SEM models.
2. Test competing theories.
3. Maintain a reproducible and correct workflow.
4. Get results rapidly and communicate them effectively.

To this end, `umx` provides a compact vocabulary of functions for doing these four things as fast as possible.

OpenMx is a fantastic base - often you'll stick with core OpenMx functions: Using `mxPath` instead of `umxPath`, or `summary` instead of `umxSummary`.

That said, R has too many cases where "*you can do it lots of ways*". We want `umx` to provide just one way that makes your work easier so you do better science.

That's it :-) On to the modeling!