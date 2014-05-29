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

It should help you:

1. Formulate models expressing theories of causes and effects.
2. Contrast competing theories
3. Have reproducible and correct implementation and workflow.
4. Get results rapidly and communicate them effectively.

Do this end, we provide a compact active vocabulary of functions for doing these four things as fast as possible.

There are things you are better off doing in core OpenMx functions: Using mxPath instead of umxPath, or summary instead of umxSummary. But that's an explicit goal. 

R has too many cases where "you can do it lots of ways". We want to provide one way, that makes your work easier so you do more.

That's it :-) On to the modeling!