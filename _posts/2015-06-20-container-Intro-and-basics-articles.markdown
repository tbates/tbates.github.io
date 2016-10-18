---
layout: post
title: "Collected introductory umx articles"

comments: true
categories: container
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
