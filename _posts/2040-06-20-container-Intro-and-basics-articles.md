---
layout: post
title: "Collected umx Introduction and basics articles"
date: 2040-06-20 00:00
comments: true
categories: container tutorial
---

<a name="top"></a>

Articles on the basic principles and practice of `umx` - suitable for new-comers and beginners.

<ul>
  {% for post in site.categories.basic %}
	{% if post.url %}
		<li><a href="{{ post.url }}">{{ post.title }}</a></li>
	{% endif %}
  {% endfor %}
</ul>
