+++
title = "Looking for the best everyday compression tool"
date = 2018-04-21T22:30:00+03:00
tags = ["compression"]
+++

_**TL;DR** [lbzip2](http://lbzip2.org/) is a great default. But for fast compression, [pzstd](https://github.com/facebook/zstd/tree/dev/contrib/pzstd) is the best._

There have been news of better compression algorithms and tools every couple of years. I haven't followed that closely, but when I needed to compress large but easy-to-compress files at work I wanted to find out.

The data I had and used for this test is a ~400MB SQL dump. It's not a standard corpus and I'm not going to share it so this is going to be unscientific and hand-wavey. But hey, this is a quick blog post. What do you expect? Anyway, the data is real and useful and I probably want to compress similar data in the future. So the results are meaningful, at least to me.

Now, I don't need the absolute best compression tool in practice. I just want something reasonably good (ie. produces small files in a short time). Actually more importantly I need to know what tool to use and how to use it. I'm not going to analyze a table published in a journal and read a manpage when I have a file to compress. Therefore, I'm asking perhaps the most naive file compression research question possible:

> Which compression program gives the best tradeoff of compression rate and time, when used with no command-line options?

Did you notice I have one objective requirement in this highly subjective test? I really can't be bothered to remember which tools I want to use `-9` with, etc. So I'm only comparing the default options. Even that turned out to be a lot of work when I realized how many relevant compressors exist these days. I still left some out and probably missed some.

One more thing to note is that I live in real time so that's what matters to me. This gives parallel implementations a huge edge. I still included the single-threaded versions in the benchmark, and CPU time for parallel implementations, if someone is interested.

## Results

First, the raw data ordered by tool family: gzip, bzip2, xz, zstd and misc.

tool      | filesize | time    | CPU time
----------|----------|---------|----------
**gzip**  | 35072546 | 7.33    |
pigz      | 35125348 | 1.46    | 8.82
**bzip2** | 20409796 | 69.56   |
lbzip2    | 20301117 | 5.33    | 32.16
pbzip2    | 20432250 | 16.18   | 107.02
**xz**    | 18911332 | 170.12  |
pixz      | 19333820 | 34.90   | 211.77
pxz       | 19197624 | 43.73   | 237.31
**zstd**  | 39855523 | 1.29    |
pzstd     | 39684543 | 0.45    | 2.51
**misc**  |
brotli    | 20907744 | 1373.77 |
plzip     | 19888119 | 34.95   | 213.70
lz4       | 58872622 | 0.81    |
lzop      | 60764413 | 0.85    |
zpaq      | 43940645 | 4.65    | 13.16

Whenever a parallel implementation exists, it's much faster (assuming you have cores and they're not crunching something else).

The miscellaneous compressors (brotli, plzip, lz4 and lzop) didn't stand up to competition. Brotli was very slow and still larger than *bzip2. The two fast algorithms (lz4, lzop) lose to pzstd. Plzip comes close but is worse than pixz. Zpaq excelled in some other benchmarks, but that doesn't happen on default settings and I dislike the non-standard command-line usage anyway.

Two families had two parallel implementations. Lbzip2 vs. pbzip2 was surprisingly one-sided, with pbzip2 taking 3x more time and still ending up with a larger filesize. Pixz vs. pxz, on the other hand, is balanced with pixz favoring speed and pxz favoring filesize. I prefer pixz as the time difference is quite large.

So let's filter all the obviously suboptimal choices out, leaving us with the best parallel implementations from each family:

### Best-of-family

tool      | filesize | time    | CPU time
----------|----------|---------|----------
pigz      | 35125348 | 1.46    | 8.82
lbzip2    | 20301117 | 5.33    | 32.16
pixz      | **19333820** | 34.90   | 211.77
pzstd     | 39684543 | **0.45**    | 2.51

If you want minimal filesize, use pixz. If you're really not in a hurry, just use plain xz. The size difference is surprisingly large at over 2% (xz is smaller).

If you want to be as fast as possible, use pzstd, its performance is just amazing. It reaches near-gzip compression levels in a ridiculously short amount of time. I'll definitely try to remember that.

## The winner: lbzip2

We're looking for the best tradeoff, though. My recommendation: pick **lbzip2** if you only want one tool. It has a great (but not the best) compression ratio, yet it's quite fast. It's also very compatible---everyone has bzip2.

I'm frankly a bit surprised. Around five years ago it looked like xz was surpassing bzip2 in source tarballs. Of course it's a different use case (compress once, pay for bandwidth) but I didn't realize it back then. And then with all the hype around Brotli and Zstandard I thought there have been breakthroughs in the technology and everything compresses much better and faster now. But it's still a tradeoff as it always was (not surprising), and the old man bzip2 is still relevant (mildly surprising).

Another surprising thing is that parallel implementations of compression algorithms are quite efficient---enough that it makes sense to use them by default on a typical desktop machine. I have some idea of how a Lempel-Ziv archive is encoded and how one could be created, and parallelizing the compression seems difficult. Maybe we'll see GPGPU compression one of these days? But then maybe not--the overhead for some of the parallel implementations is significant. (I have no idea what happened in bzip2 vs. lbzip2, but that's an outlier.)

So, I'm starting to use lbzip2 whenever I need to compress a file or a tarball (ie. when I'm not using a zip to accommodate for GUI people). Speaking about tarballs, what about `tar -j`? Well, you could build tar with `--with-bzip2=lbzip2`. I'm lazy and just symlinked `bzip2`, `bunzip2` and `bzcat` to `lbzip2`. We'll see if this bites me later.

## Caveats

The compression tests were run on a Macbook Pro. The CPU was a 4-core HyperThreading-capable Core i7. The tools were installed from Homebrew.

There was other software running on the laptop at the same time. There was nothing especially CPU intensive, but I'll admit the test setup was not the fairest possible.

And the most obvious caveat: this comparison only used a single instance of a single type of data. I expect the size difference between xz and bzip2 to be much more considerable in other circumstances.
