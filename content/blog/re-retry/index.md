+++
title = "re-RETRY: patching a Unity-based Android game"
date = 2019-09-10T20:30:00+03:00
summary = "Announcing re-RETRY, a modded version of RETRY (that you have to build yourself)."
tags = ["RETRY", "reverse engineering", "Android"]
+++

**UPDATE 2020-02-12:** RETRY was re-published in January 2020 as [
Fail Plane - 2D Arcade Fun](https://play.google.com/store/apps/details?id=com.darkmatter.retry). Please go download it and buy "remove ads" for 3,99€!

+++

*Announcing [re-RETRY](https://github.com/dancek/re-retry), a modded version of RETRY (that you have to build yourself).*

I'm a big fan of [RETRY](https://en.wikipedia.org/wiki/Retry), a 2014 mobile game by [Rovio](http://www.rovio.com/) / LVL11. In fact, I consider it the best mobile game I've seen to date. Unfortunately it was discontinued in 2017 and shortly after stopped working.

<video controls loop
  title="Playing RETRY, level B2: Impassable Ruins (almost passing the impassable section!)"
  width="560"
  height="320"
  src="retry.mp4"
  style="width: 100%; height: auto;"></video>

I kept the APK around because I hoped it would work again one day. I even copied it over when I switched phones, but it still didn't work. Last week I noticed it had started working again, just throwing some Google Play Games related error. I thought it'd be nice to get rid of the error message.

## What APKs are made of

Unpacking an APK is easy: just get [Apktool](https://ibotpeaches.github.io/Apktool/) and run `apktool decode foo.apk`. You'll get all the resources and stuff, and the Dalvik bytecode disassembled with [baksmali](https://github.com/JesusFreke/smali). The bytecode is quite easy to read and modify so that's great (as long as it's not obfuscated).

Repacking is kind of easy with `apktool build`, but you can only install signed APKs. That means you can't install a self-signed APK with a given package name on top of the official one. You probably can't use Google services with the same credentials either. For our purposes that's fine: it's a good idea to change the app name and package. That way you can have both the official and the modded one installed.

## How Unity complicates things

Looking at the APK contents for RETRY, there's quite a bunch of Dalvik bytecode but none of the game logic. The main entry point just launches UnityEngine. Turns out the game code (at least the most of it) is in `Assembly-CSharp.dll`. I tried a bunch of different things to work with it, with various levels of success[^1].

Eventually the successful approach was to use `ildasm` to disassemble to CIL (Common Intermediate Language) and `ilasm` to reassemble the DLL. They are .NET tools and for non-Windows require you to build [CoreCLR](https://github.com/dotnet/coreclr) yourself. Eventually they might ship with .NET Core. The Mono counterparts are buggy and insufficient, unfortunately.

Still, because it's Unity, a huge amount of the game behavior and content is actually in Unity assets rather than code. I haven't quite made sense of that yet. For example, I'd love to get screenshots of whole levels in RETRY, but I haven't figured out a way to zoom out.

## Editing bytecode

Once you get to a setup where you can unpack and repack things, all that remains is finding what modifications you want. Most things I wanted were very easy: find the relevant part of code, read and understand it, usually just remove a bit and you're done. Adding completely new features this way would be hard, though.

Finding the correct part of the codebase is more an art than a science, but with an unmangled unobfuscated reasonably good codebase you get far by reading enough to make sense of the vocabulary in naming, then guessing relevant class or method names. Another way is to start from known strings (which isn't usually possible with Unity). Some call graph crawling is often needed, too.

## Publishing patches

Now, I wanted to have something to show along with this blog post. At the same time I have respect for Rovio's copyright so I'm not going to share their code or assets, binary or disassembled. So I went ahead and wrote a Makefile and a bunch of patches that can take the original APK and create a modified one from it automatically. Here it is: https://github.com/dancek/re-retry

I'm not expecting many people (if any) to actually go through with building a modded RETRY with this, but maybe the concrete steps in the process are interesting. Actually just getting the dependencies right may take a bit of work, and I have no idea how well my patches work if you change the `ildasm`+`ilasm` versions (I'm using current CoreCLR master with a .NET Core 3.0 preview; CIL reports `//  Microsoft (R) .NET Framework IL Disassembler.  Version 4.5.30319.0`).

## Acknowledgements

I'm hugely grateful to Rovio for publishing RETRY and to all the people who made it. Thank you!

If you found this blog post helpful or start playing RETRY again, please support Rovio by buying content for their games. Or buy the [original game soundtrack](https://play.google.com/store/music/album/Ted_Striker_Retry_Original_Game_Soundtrack?id=B4qslltpinblm5kfodujwhaatai). I did, even though I could access it through a streaming service for free. Hoping someone notices that in analytics: still making money from a game discontinued in 2017!

[^1]: One tool of note is [dnSpy](https://github.com/0xd4d/dnSpy). It's excellent if you're on Windows and just want to patch a binary. But I like text-based formats and git history and platform independence and such, so disassembling and editing CIL was more my cup of tea.
