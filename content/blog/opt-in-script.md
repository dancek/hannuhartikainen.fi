+++
title = "opt-in-script: letting visitors choose"
date = 2020-05-19
+++

I used to have [utteranc.es](https://utteranc.es) for comments in my blog. I think it's a nice, lightweight, usable system (it's basically Github issues).

But it's a third party script. I may have read the source and I may trust the maintainers, but some of my visitors might not. So forcing it on everyone feels a bit immoral. And after switching my blog to [Zola](https://getzola.org) I didn't add *any* JS on my blog -- until now.

I've thought about *opt-in analytics* before: I'd like to have analytics on my site, but I don't want to track my visitors without consent or give their data to third parties[^1]. The solution might be a *please track my visit* button. Perhaps not that many people would click, but maybe I'll try it someday.

The general idea seems more suited for comments, though: maybe you want to read comments or write one, and one click isn't a big annoyance. Meanwhile the visitors that don't care about comments (ie. most, I guess) avoid some unnecessary traffic and content.

So I wrote [opt-in-script](https://github.com/dancek/opt-in-script) which takes something like this

```html
<opt-in-script src="analytics.js"
               some-attr="123-456-7">
  <button>Enable analytics!</button>
  Note: this will log foo, bar and baz to my server.
</opt-in-script>
```

and only after the button is clicked, turns it into a real `<script>` tag that the browser will load and run:

```html
<script src="analytics.js" some-attr="123-456-7"></script>
```

You may see it in action in my blog post footers, wrapping the comments section. Check what happens in the browser devtools network tab when you click!

I'm hoping to see more websites that respect their visitors. Maybe you could consider something similar on your site?

[^1]: Note that you should not trust me. I probably will start tracking visitors if I ever see a significant benefit in doing so. Such is human nature.
