---
title: "Code::Stats plugins for Zsh and Vim"
date: 2018-04-05T14:30:34+03:00
tags: ["FLOSS", "Code::Stats", "vim", "zsh", "shell"]
---

*To get this blog started, I'm writing about some code I've put online. The most interesting are probably the two Code::Stats plugins I've created.*

[Code::Stats](https://codestats.net/) is a free service for collecting stats about writing code. It's a for-fun side project of a colleague. Basically the server exposes an API that receives character counts per language along with a timestamp. The data is gathered by editor plugins.

##  [Zsh plugin for Code::Stats](https://gitlab.com/code-stats/code-stats-zsh)

I thought it would be fun to see how much I type in the terminal, so I created a [Zsh](https://www.zsh.org/) plugin for that. It wraps some Zsh widgets to be able to capture keystrokes and sends them using a background [curl](https://curl.haxx.se/) process after any process completes or the shell exits, throttled down to at most once every ten seconds.

The plugin reports Code::Stats XP as language *Terminal (Zsh)*.

## [Vim plugin for Code::Stats](https://gitlab.com/code-stats/code-stats-vim)

After I realized it's not too hard to write a plugin and knowing there was some demand for a Vim plugin, I asked the local Vim guru at work for some help to get started.

The Vim plugin was a bit difficult to get working realiably as I wanted to support all the platforms I humanly could:

- Both [Vim](https://www.vim.org/) and [NeoVim](https://neovim.io/)
- As old Vim versions as possible *(The limiting factor became support for the `InsertCharPre` event, needed for counting keystrokes: Vim 7.3.196)*
- All operating systems that could conceivably work (looking at you, Windows)
- Both Python 2 and Python 3

Plain Vimscript couldn't make HTTP requests so it was obvious a script language was needed, and probably Python has the broadest coverage of installations. I also wouldn't rely on async support as that would rule Vim 7.x out, so I needed to handle asynchonous behaviour by creating a background worker process using Python `multiprocessing`. Eventually I got the obvious glitches ironed out and made a release.

Afterwards I sprinkled some unit tests for the Python code and some end-to-end tests that run a mock server and a Vim instance. The end-to-end tests were surprisingly difficult to get working properly. I set up [Gitlab CI for the tests](https://gitlab.com/code-stats/code-stats-vim/pipelines) and even added (Python) coverage reporting so I get nice icons like this: ![Code coverage status icon for code-stats-vim](https://gitlab.com/code-stats/code-stats-vim/badges/master/coverage.svg)

Below is an animation I created for the Gitlab page. It's not perfect by any means but it should convey the idea.

![Animation of code-stats-vim](https://thumbs.gfycat.com/HastyAnxiousBlackfootedferret-size_restricted.gif)

## My thoughts

The plugins were a lot of fun to write, and I had to learn a lot of new stuff for both:

- **Zsh specifics**. I usually prefer POSIX-compatible shell scripts, but that wouldn't be idiomatic or good for performance.
- **Quality control for a shell script**. Basically ShellCheck running in Gitlab CI---maybe I should consider unit testing.
- **VimL** (and Python integration).
- **Robust `multiprocessing`**. Distributed systems are difficult to get right.
- **Releasing software for other people to use**. That means prioritizing usability both at install and run time, avoiding all the corner-case glitches that won't happen on my machine, writing good READMEs etc.

---

Both plugins are under the Code::Stats organization on Gitlab. Both have users beside myself (yay!).

- https://gitlab.com/code-stats/code-stats-zsh
- https://gitlab.com/code-stats/code-stats-vim

I also [worked a bit on the Code::Stats core](https://gitlab.com/code-stats/code-stats/commit/cd7b716c4d3aa7ba08133988e5e4acc041be3cba) before creating these plugins. I did like Elixir and Phoenix, but I currently prefer to spend my spare time outside web development.
