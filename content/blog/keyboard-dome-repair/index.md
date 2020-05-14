+++
title = "Repairing a stuck rubber dome key"
date = 2018-11-25T11:27:39+03:00
tags = ["maintenance"]
+++

{{ image(path="blog/keyboard-dome-repair/images/washing.jpg", title="This is a story of washing a keyboard. I mean, repairing a keyboard. But I also washed it, so have a photo of my submerged keyboard. No, it's not water-resistant.") }}

I bought a rubber dome gaming keyboard in maybe 2012 thinking keyboards last forever. Millions of keypresses later[^1] the spacebar started getting stuck. But it pains me to throw stuff away because of a single problem, so I set out to repair it.

<!-- more -->

I first took the keyboard apart to see what's wrong.

{{ image(path="blog/keyboard-dome-repair/images/open.jpg", title="The inside of my keyboard.") }}

Well, the dome for spacebar had seen better days. This wouldn't be easy to fix.

{{ image(path="blog/keyboard-dome-repair/images/ripped.jpg", title="The torn silicone dome.") }}

A quick search pretty much told me that people don't repair rubber dome keyboards. The best resource I found was [this question on SuperUser](https://superuser.com/q/1122047/72407) (which I later answered myself).

So someone suggested rubbed cement. Great, I'm quite good at patching bicycle inner tubes. But you really need some patch material for inner tubes--the rubber cement itself doesn't do much. There's no way the key would feel nice if there was a thick patch attached to the dome, though, so I needed to find a different approach. After an hour of trying, it felt like building layer upon layer of dried rubber cement might actually work. If only the cement would stick to the silicon just slightly better.

As it was, though, both rubber cement and glue would start separating from the dome after some keypresses.

I didn't believe I could make the bond hold for tens of thousands of keypresses when it was failing after ten keypresses, so I decided to try a more robust solution.

You know that calculator key? You probably don't, because why would anyone put a dedicated key for a calculator! Anyway, I cut out the rubber dome for my calculator key and put it under the spacebar dome. After some careful trimming, the transplanted dome was ready for action.

{{ image(path="blog/keyboard-dome-repair/images/stacked.jpg", title="Another dome stacked under the original one.") }}

I put the keyboard back together and tried it. The spacebar was slightly stiffer than the other keys and otherwise worked perfectly.

## Three months later

I completed the repair in August but got around to writing this in November. In the meantime, I received my [Ultimate Hacking Keyboard](https://uhk.io) and realized mechanical keyboards actually are much better.

The repaired key has lost its initial stiffness and is working perfectly. I see no reason why it would not last for years. So yes, you can easily repair rubber dome keys by transplanting another similar dome as long as you have a donor keyboard or key.

[^1]: I'm estimating my keypress count by my data in [Code::Stats](https://codestats.net/), a free typing statistics service [I've contributed to and written about](/tags/codestats).
