+++
title = "A quine in sed"
date = 2019-04-01T21:41:01+03:00
tags = ["quine", "sed", "shell"]
+++

Yesterday someone on IRC corrected their typos with classic sed-like replaces[^1], and for some reason that got me wondering if you can write a [quine](https://en.wikipedia.org/wiki/Quine_(computing)) in [sed](https://en.wikipedia.org/wiki/Sed).

Of course you can.
<!--more-->

```sh
echo "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/" | sed "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/"
```

When run in `dash` or `zsh` (but not `bash`[^2]), the output is that same line. That's what quines are: self-replicating programs. For a thorough review, see [David Madore's excellent page about quines](http://www.madore.org/~david/computers/quine.html).

## Dissection

Like many quines, this one consists of a data part and a stream manipulation part. That's necessary to use sed in the first place. However, the escaping mechanism of the shell also plays a large part, so strictly speaking this is a POSIX shell quine that uses `echo` and `sed`.

The data part is what is echoed and piped to sed. The sed command run on the input is this:

```sh
sed "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/"
```

This combines three regex replace commands:

1. `s/\\\\/&&&&/g`
2. `s/\"/\\\\&/g`
3. `s/.*/echo \"&\" | sed \"&\"/`

The third one is really the only interesting part: take the input, and basically print `echo <input> | sed <input>`. Figuring out that part is easy; finding a way to work with character escaping such that the input data can be crafted properly is a bit more time-consuming.

I tried finding a smart way of combining `'`, `"`, `\x22` and such, but that turned out to be difficult. Working with the shell escaping mechanism instead of avoiding it was a better idea. Just find a way to escape special characters before printing. Then write the program as data. Voila, the quine is ready.

```sh
$ echo "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/" | sed "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/"
echo "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/" | sed "s/\\\\/&&&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/"
```

[^1]: Example: `I canot spell` -> `s/n/nn/`

[^2]: I tried with bash, too. It works with `echo "s/\\\\/&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/" | sed "s/\\\\/&&/g;s/\"/\\\\&/g;s/.*/echo \"&\" | sed \"&\"/"`. There's probably some escaping setting that affects this but I didn't take the time to find it.
