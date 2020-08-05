+++
title = "ansi.hrtk.in – play ANSI art over HTTP or Gemini"
date = 2020-08-05
+++
I've written a bunch of [Gemini](https://gemini.circumlunar.space/) related code this past month. Now I ported one tech demo over to HTTP. It's an ANSI art player that emulates modem download speed and tries its best to look good on modern terminals (ie. charset conversion and clipping to 80 columns).

I recommend trying it with curl in a terminal. Alternatively, click the button to see a "video" (ie. asciinema recording).
```
curl ansi.hrtk.in/ungenannt_motherofsorrows.ans
```

<opt-in-script src="https://asciinema.org/a/351771.js"
               id="asciicast-351771"
               data-autoplay="true" 
               data-size="medium"
               async>
  <button>Show demo with asciinema player</button>
  <small>(this runs a ~150kB script from asciinema.org)</small>
</opt-in-script>

The art is from [https://16colo.rs/](https://16colo.rs/) – all ANSI art files there are mirrored and available by filename. The code is AGPLv3 and available at the `/source` url on the site, and, at the moment, [Github](https://github.com/dancek/ansimirror).

The site is really built with Gemini in mind and the HTTP server is a hacky afterthought. Of course you need a streaming-capable gemini client; my current favorite is [gemget](https://github.com/makeworld-the-better-one/gemget/).

For some yo dawg moments, try my Gemini asciinema player with gemget ;)
```
gemget -o- gemini://asciinema.hrtk.in/351771
```
