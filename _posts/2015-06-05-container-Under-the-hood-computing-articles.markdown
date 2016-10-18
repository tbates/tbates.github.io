---
layout: post
title: "Collected technical articles (parallel, speed, matrix-algebra)"

comments: true
categories: container
---

<a name="top"></a>
Articles on working with clusters, remote reporting, parallel, multi-core etc. are collected here


<ul>
{% for post in site.categories.technical %}
{% if post.url %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
{% endif %}
{% endfor %}
</ul>
