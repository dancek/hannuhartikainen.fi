+++
title = "(Working on) switching to Zola"
date = 2020-05-12T23:23:54+03:00
+++

**EDIT 2020-05-16:**  
I implemented the most important stuff (content conversion, templates, styles, shortcodes) and am switching the site to Zola today. The site is much better now. There's no JS at all except on pages that actually use it (in the [Piilosanat](@/piilosanat/_index.md) section, hints and the web crossword). The CSS weighs some 1.5KB yet the site looks better now IMHO, supports dark mode, and is completely responsive.

---

Last week, I read [0x10 rules by Fabien Sanglard](https://fabiensanglard.net/ilike/index.html) and it reminded me of a bunch of things I dislike about my website.

First, the Hugo template syntax is completely nonintuitive to me. I've repeatedly had to write it, and every time I have to relearn it.

Second, I'm not in control of my theme. Not the way I'd like to be. I picked a theme that looks quite nice and minimal, and that's somewhat lightweight. But I'm pushing a lot of unnecessary JS and CSS to people.

I've contemplated writing my own theme for a long time, but it always felt like a chore because of Hugo (or perhaps Go).

Third, my RSS feed doesn't provide full article content. Yet another chore to fix.

---

Now, my experience with Hugo has been good. I would recommend it to someone looking for a static site generator with a nice ecosystem (themes, support). But I like trying new stuff and [Zola](https://getzola.org/) looked better. And it's based on markdown, too, so I'd basically just need to write my templates and reimplement my custom Hugo stuff.

So behold the upcoming incarnation of my website at [EDIT: this page is now built with Zola] (that isn't much to behold)!

The basics are there. I'll probably continue to work on the missing stuff and eventually switch the main site over. Who knows. I've had false starts before.

But I've got a good feeling. I like editing my site once again.
