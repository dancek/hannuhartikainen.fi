+++
title = "Advent of Code 2021 in BQN"
date = 2021-12-31
tags = ["BQN"]
+++

I just finished [Advent of Code 2021](https://adventofcode.com/2021). In [BQN](https://mlochbaum.github.io/BQN/). ([My solutions](https://github.com/dancek/bqn-advent2021).)

The slogan *BQN: finally, an APL for your flying saucer* might be the best single-sentence description of the language. It's a modern array programming language that also supports other paradigms. Especially functional programming, which I love to begin with and find a very useful companion to the array paradigm.

Some say you should learn programming languages that change how you think. That's reason enough for me, so I've tried array programming every now and then the past few years. While I originally approached APL and J as mental gymnastics with weird hieroglyphics, I've come to appreciate the benefits of the approach. Handling n-dimensional data is cumbersome with most traditional programming techniques. And I can't dismiss the philosophy of [Notation as a Tool of Thought](https://www.jsoftware.com/papers/tot.htm), a classic essay by Kenneth E. Iverson.

Then I heard about BQN. It immediately sounded like a language I'd love to know, but I put it off for a while. But when I heard a friend was solving Advent of Code with it, I had to try myself. I never expected to get far. I tried AoC in Racket in 2018 and only got 70% through, so I estimated with an array language I'd get through maybe the first week before quitting.

To my surprise BQN felt easy and well-fitting for most problems. Perhaps not easy to write, but such that when I finally figured out a good algorithm and read enough documentation to be able to write it, it made a lot of sense.

There were days when finding a solution was hard. I resorted to reading and taking ideas from other people's solutions on days [15](https://github.com/dancek/bqn-advent2021/blob/master/15.bqn) and [24](https://github.com/dancek/bqn-advent2021/blob/master/24.bqn). And day 23 I solved manually rather than programmatically.

On day 18 I thought the problem so difficult I'd first solve it in Clojure, a language I know well. I had bugs in the solution and just couldn't iron them all out, so I forgot about it for a couple of days. When I came back and started from scratch in BQN, I got all the previously-buggy parts working on first try. This was a mind-blowing moment for me: was I actually beginning to *think in arrays?*

And so I've come to a point where, when I need **rotation** matrices for all orthogonal 3D rotations and I've forgot most of linear algebra, [I casually write](https://github.com/dancek/bqn-advent2021/blob/master/19.bqn#L27-L30):
```
pm3 ← 1-2×⥊↕2‿2‿2
base ← 3‿3⥊1‿0‿0‿0
rotations ← ⥊pm3×˘⌜(⊢∾⌽¨)⌽⟜base¨↕3
```
And it works[^1], and I can understand the code better than if it was written in a verbose language.

Or when I need Manhattan distance between n-dimensional points, I know it's just `{+´|𝕩-𝕨}`.

I have a new powerful tool in my toolbox. As always, I'll be choosing the best tool for the job. But this tool is not just a programming language. Its notation is also a great tool of thought.

[^1]: The output of `⥊pm3×˘⌜(⊢∾⌽¨)⌽⟜base¨↕3` is:

```
┌─
· ┌─        ┌─        ┌─        ┌─        ┌─        ┌─        ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─         ┌─         ┌─         ┌─         ┌─         ┌─         ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─          ┌─           ┌─           ┌─           ┌─           ┌─           ┌─
  ╵ 1 0 0   ╵ 0 1 0   ╵ 0 0 1   ╵ 0 0 1   ╵ 1 0 0   ╵ 0 1 0   ╵ 1 0  0   ╵  0 1 0   ╵ 0  0 1   ╵  0 0 1   ╵ 1  0 0   ╵ 0 1  0   ╵ 1  0 0   ╵ 0 1  0   ╵  0 0 1   ╵ 0  0 1   ╵ 1 0  0   ╵  0 1 0   ╵ 1  0  0   ╵  0 1  0   ╵  0  0 1   ╵  0  0 1   ╵ 1  0  0   ╵  0 1  0   ╵ ¯1 0 0   ╵ 0 ¯1 0   ╵ 0 0 ¯1   ╵ 0 0 ¯1   ╵ ¯1 0 0   ╵ 0 ¯1 0   ╵ ¯1 0  0   ╵  0 ¯1 0   ╵ 0  0 ¯1   ╵  0 0 ¯1   ╵ ¯1  0 0   ╵ 0 ¯1  0   ╵ ¯1  0 0   ╵ 0 ¯1  0   ╵  0 0 ¯1   ╵ 0  0 ¯1   ╵ ¯1 0  0   ╵  0 ¯1 0   ╵ ¯1  0  0   ╵  0 ¯1  0   ╵  0  0 ¯1   ╵  0  0 ¯1   ╵ ¯1  0  0   ╵  0 ¯1  0
    0 1 0     0 0 1     1 0 0     0 1 0     0 0 1     1 0 0     0 1  0      0 0 1     1  0 0      0 1 0     0  0 1     1 0  0     0 ¯1 0     0 0 ¯1     ¯1 0 0     0 ¯1 0     0 0 ¯1     ¯1 0 0     0 ¯1  0      0 0 ¯1     ¯1  0 0      0 ¯1 0     0  0 ¯1     ¯1 0  0      0 1 0     0  0 1     1 0  0     0 1  0      0 0 1     1  0 0      0 1  0      0  0 1     1  0  0      0 1  0      0  0 1     1  0  0      0 ¯1 0     0  0 ¯1     ¯1 0  0     0 ¯1  0      0 0 ¯1     ¯1  0 0      0 ¯1  0      0  0 ¯1     ¯1  0  0      0 ¯1  0      0  0 ¯1     ¯1  0  0
    0 0 1     1 0 0     0 1 0     1 0 0     0 1 0     0 0 1     0 0 ¯1     ¯1 0 0     0 ¯1 0     ¯1 0 0     0 ¯1 0     0 0 ¯1     0  0 1     1 0  0      0 1 0     1  0 0     0 1  0      0 0 1     0  0 ¯1     ¯1 0  0      0 ¯1 0     ¯1  0 0     0 ¯1  0      0 0 ¯1      0 0 1     1  0 0     0 1  0     1 0  0      0 1 0     0  0 1      0 0 ¯1     ¯1  0 0     0 ¯1  0     ¯1 0  0      0 ¯1 0     0  0 ¯1      0  0 1     1  0  0      0 1  0     1  0  0      0 1  0      0  0 1      0  0 ¯1     ¯1  0  0      0 ¯1  0     ¯1  0  0      0 ¯1  0      0  0 ¯1
          ┘         ┘         ┘         ┘         ┘         ┘          ┘          ┘          ┘          ┘          ┘          ┘          ┘          ┘          ┘          ┘          ┘          ┘           ┘           ┘           ┘           ┘           ┘           ┘          ┘          ┘          ┘          ┘          ┘          ┘           ┘           ┘           ┘           ┘           ┘           ┘           ┘           ┘           ┘           ┘           ┘           ┘            ┘            ┘            ┘            ┘            ┘            ┘
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ┘
```
