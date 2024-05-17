+++
title = "A polyglot quine in BQN + Python"
date = 2024-05-17
tags = ["BQN", "quine"]
+++
{{ bqnfont() }}

I might do a writeup later but just wanted to put this online: a [quine](https://en.wikipedia.org/wiki/Quine_(computing)) that works both in [BQN](https://mlochbaum.github.io/BQN/) and [Python](https://www.python.org/).

```python
""" "⋄""";s="""⋄T‿a‿b‿c←{𝕩-35‿37∊˜𝕩-@}‿"### #⋄###;s=###⋄T‿a‿b‿c←{𝕩-35‿37∊˜𝕩-@}‿#"‿"#
•Out (T a)∾a∾(T c)∾b∾(T c)∾c∾(T b)
###
t='QQQ Q⋄QQQ;s=QQQSQQQNt=q%qNu=t.replace(chr(81),chr(34)).replace(chr(78),chr(10)).replace(chr(113),chr(39)).replace(chr(83),s).replace(chr(36),t)Nprint(u);QQQ⋄Q QQQ'
u=t.replace(chr(81),chr(34)).replace(chr(78),chr(10)).replace(chr(113),chr(39)).replace(chr(83),s).replace(chr(36),t)
print(u);###⋄# ###"‿"#‿#"
•Out (T a)∾a∾(T c)∾b∾(T c)∾c∾(T b)
"""
t='QQQ Q⋄QQQ;s=QQQSQQQNt=q$qNu=t.replace(chr(81),chr(34)).replace(chr(78),chr(10)).replace(chr(113),chr(39)).replace(chr(83),s).replace(chr(36),t)Nprint(u);QQQ⋄Q QQQ'
u=t.replace(chr(81),chr(34)).replace(chr(78),chr(10)).replace(chr(113),chr(39)).replace(chr(83),s).replace(chr(36),t)
print(u);"""⋄" """
```

Syntax highlighting in Python (my highlighter doesn't support BQN, maybe I could do something about it).
