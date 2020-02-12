---
title: "Looking for a small binary patch"
date: 2020-02-12T11:00:00+03:00
tags:
- RETRY
- Android
- bsdiff
---

*To make re-RETRY more easy to get, I thought of providing a bsdiff-based binary patch. Creating a small one is not easy, though.*

<!-- more -->

## Breaking news: RETRY is live again!

Turns out RETRY was re-published in January 2020 as [
Fail Plane - 2D Arcade Fun](https://play.google.com/store/apps/details?id=com.darkmatter.retry). Please go download it, buy "remove ads" for 3,99€ and forget about re-RETRY! I'm leaving the blog post and repo as-is for educational purposes. I believe their content does not infringe copyright per se, but now that the game is available running a patched game in order to spare 4 euros is obviously immoral. Please support the developer and spend that money.

This news makes publishing this blog post easier as I won't actually share the patch nor provide instructions. :) I wrote the post already in October but was too uncertain about publishing the patch so I never did.

## Creating a binary patch

Just running the whole patching pipeline and bsdiffing the resulting APK against the original gives a huge patch: 33MB. Ugh.

The DLL I got with ildasm + IL patches + ilasm is significantly different from the original. A patch for the DLL weighs a whopping 238KB (the original DLL is 1017KB). If you replace the DLL inside the APK with `zip -u` the resulting file is not very different: you get a patch size of 374KB. However, you still need to zipalign and re-sign the APK to make it work. After that you're looking at 436KB.

Looking for a better alternative, I edited the DLL directly with dnSpy. It does rewrite the file and the file size changed, but with my test change the patch for the DLL went down to 25KB. Updating the file in the apk in-place yielded an apk diff of 367KB, ie. not very different from the ildasm route. Re-signing took it to 428KB.

The actual change I made is basically either removing a dozen bytes of IL or replacing them with `nop`s.

So there are three points where large changes happen:

1. A change of a dozen bytes gets magnified to 25KB. This could possibly be alleviated by directly editing the DLL binary, which sounds interesting. However:
2. The DLL patch size doesn't seem to matter that much because we need to update the APK (basically a ZIP) and the resulting APK patch is almost the same size regardless of the DLL patch size. The DLL is completely recompressed and there's not much common in the resulting binary, and I'd like to know if that can be avoided. Hexediting the raw DEFLATE stream is probably ridiculously difficult, and building tools is a lot of work.
3. Re-signing the APK adds around 60KB more. Selecting suitable signing keys might affect this. Just randomly trying different ones seems easy.

I'd love to investigate each of these, but this is where I stop for now (especially as I won't publish the actual patch). I can think of other circumstances where I'd want a binary patch, so perhaps I'll revisit the idea. In particular, binary patches that provably do not contain copyrighted content would be interesting (that's one reason I wasn't comfortable releasing a 0.5MB binary blob).
