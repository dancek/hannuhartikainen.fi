+++
title = "Volvo HU-803 and the MELBUS protocol"
+++

I've made two CD-changer emulator / AUX cables for the Volvo HU car audio systems. The build is pretty much as described in [Gizmosnack's blog](http://gizmosnack.blogspot.com/2015/11/aux-in-volvo-hu-xxxx-radio.html).

The code I initially used was [an older version of visualapproach's Arduino implementation](https://github.com/visualapproach/Volvo-melbus/blob/433f19e05d3c14c469bea7f85b7bf9d8a27e124e/code/SAT_and_CDC.ino) with a single hardcoded text changed to point to this page.

Turns out that HU-803 doesn't support SAT (later versions like HU-650 and HU-850 do) so it doesn't show any text at all, anyway. An MD-changer does support track information but no one has published its protocol. Several people have reverse engineered it separately (probably with a device and a logic analyzer) and gone on to sell their own proprietary devices. Sigh.

So I have a couple of things I might hack on and write about:

- The MD-CHGR protocol. Probably very difficult without hardware supporting the protocol.
- A reimplementation on better hardware (say, an ARM board like the [Blue Pill](http://wiki.stm32duino.com/index.php?title=Blue_Pill) or ESP32 for bluetooth support), maybe in Rust.
- The minor things I did differently that made the second cable i made better than the first one.

But for now, this page is mostly a placeholder. It has to exist because I've written the URL in places. :D
