+++
title = "Measuring speed between two ethernet adapters"
date = 2020-04-12T00:05:49+03:00
tags = ["network", "hardware"]
+++

Measuring LAN speed is not very well documented, so after spending an hour I wanted to write down my findings.
<!--more-->

I had a long cat5e ethernet cable that had broken clips on both connectors, and a sudden need for it. After a disconnect because the cable fell off the port, I got a handful of cheap 8P8C connectors and decided to try my luck. They say a crimping tool is absolutely needed, but being a skeptic I did the connectors with a flat-head screwdriver and saved 20 euros.

Now, the manually re-connected cable wasn't a bottleneck for my internet connection, but I was wondering whether it was still good for gigabit ethernet. Setting up multiple machines to test that sounded like a lot of work and I thought of doing it with dual ethernet adapters on a single laptop.

I went and installed [iPerf](https://iperf.fr/) from Homebrew. Looking at the manual, I saw there's the `--bind` option for specifying which adapter to use. First try, I got some 43Gbps meaning the traffic was going through the loopback device. After a bit of head scratching with `netstat -nr` I found this procedure to work:

1. Get IP addresses for both adapters on the same subnet. Let's call them IP_server and IP_client.
2. Disable the loopback route for IP_server: `sudo route -n delete <IP_server>`. Sometimes you have to do this multiple times before it takes effect.
3. Start the iPerf server: `iperf3 --server --bind <IP_server>`
4. Start the iPerf client: `iperf3 --client <IP_server> --bind <IP_client>`

This way I found out all my cables give transfer speeds of around 800Mbps. I'm not sure what the bottleneck is, but that's plenty for me.

After checking my cables I went on to test my networking equipment. My Gigabit-capable VDSL2/router transfers the same 800Mbps port to port, ie. it's not the bottleneck in this test. My old 100Mbit ADSL2/router did some 94Mbps.

Now for the interesting network gear: Powerline adapters. Back when I realized running cabling to all rooms is a pain, I found out about [power-line communication](https://en.wikipedia.org/wiki/Power-line_communication) and it seemed like a perfect solution: no long cables yet better stability than wifi. RRight. I got a pair of 1000Mbps HomePlug AV adapters and after they saturated my then-10Mbps internet connection, I got another 500Mbps pair for low-priority devices. Now, the reason I needed a long cable was that one day when remote working, both the powerline ethernet and wifi were glitchy at the same time. Weird, but no time for foil hats.

So how fast is a 1000Mbps HomePlug AV pair? I tested with all other devices disconnected and put two same-brand adapters on the same dual socket. That is, the conditions were as perfect as our house will ever have. The result, 320Mbps. Adding another adapter in another room, the speed went down to 80Mbps. The 500Mbps pair only did 100Mbps in ideal conditions.

## Takeaways

- Crimping RJ45 without a tool is doable.
- Network cables are all the same speed in trivial tests.
- HomePlug AV is slow compared to theoretical speeds, but ok-ish for casual networking (I used it for a couple of years on my desktop PC; the latency was good, but the throughput to the other side of the house was some 35Mbps).
