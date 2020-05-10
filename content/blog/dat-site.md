+++
title = "dat:// site tho"
date = 2018-06-14T18:38:58+03:00
tags = ["dat", "tools", "web", "decentralization"]
+++

I came across the [Dat Project](http://datproject.org/) yesterday. In short it's BitTorrent-based web with version history---yes, I admit my description sounds like one of those uber-for-larvae startups. But I quickly tried `dat` out and it seems very useful for filesharing and has potential for content publishing.
<!--more-->

## Where it's useful right away: transfering files

From time to time you need to transfer files from one laptop to another. It's 2018 and this isn't a trivial problem, at least for me. You could send the files over an instant messaging system or email, but only if the files are smallish. You could upload the files to a cloud service like Google Drive or Dropbox, but for large files you need to have space and it the upload needs to complete before you can begin downloading. For all cloud/service-based systems you also need to trust a third party with your data, which for work-related purposes isn't always a good idea. And you're restricted by your internet connection speed even if the devices are on the same LAN. You could use a USB pendrive, but that's a lot of trouble. You could connect directly using ssh or ftp or smb, but that needs setup and passwords and stuff.

Or, if you have `dat` installed, you could just share the files:

```
$ dat share
dat v13.10.0
Created new dat in /private/tmp/dat-test/test/.dat
dat://42f95988256e8ac390b75f74c427b54a4cb9cefa905cb3baeb43fec3d5a73d8b
Sharing dat: 1 files (0 B)

0 connections | Download 0 B/s Upload 0 B/s

Watching for file updates


Ctrl+C to Exit
```

And using the link on another machine, clone it.

```
$ dat clone dat://42f95988256e8ac390b75f74c427b54a4cb9cefa905cb3baeb43fec3d5a73d8b dir-name
dat v13.10.0
Cloning: (empty archive)
         1 files (5 B)
0 connections | Download 0 B/s Upload 0 B/s
4 connections | Download 56 B/s Upload 0 B/s

dat sync complete.
Version 2
Ctrl+C to Exit

Exiting the Dat program...
```

What's more, the `dat share` command watches for file updates and you can fetch any changes on the other machine immediately:

```
$ cd dir-name
$ dat sync
dat v13.10.0
Downloading dat: (empty archive)
                 2 files (11 B)
0 connections | Download 0 B/s Upload 0 B/s
2 connections | Download 0 B/s Upload 0 B/s

dat synced, waiting for updates.
[==========================================] 100.00%
Ctrl+C to Exit
```

Ok, there may be other tools that do this, but I like the usability, security has been considered in the design phase, and the protocol has potential for a lot more. The installation is easy, btw: `npm install -g dat`.

## Where it has potential: decentralized web

First off, let me note that this site is already available at [dat://hannuhartikainen.fi](dat://hannuhartikainen.fi). The only browser that supports the protocol, though, is [Beaker](https://beakerbrowser.com/). I like the idea of browsing a peer-to-peer web that looks like classic WWW but where you can also publish things directly inside your browser. You can also help publishers by seeding content (which Beaker automatically does while you have a tab open).

The peer-to-peer network isn't anonymous in any way (AFAIK the technology is very similar to BitTorrent), so it hopefully won't devolve into a darknet. Compared to IPFS, you can update the content without weird nameservice stuff, and there's the version history which might be useful.

I think the usability is already quite good, and it could become good enough for non-technical people to publish without resorting to a centralized service. Of course most end-users don't care if the platform is non-free and run by the most evil corporation in the world, but these platforms change from time to time and a great free peer-to-peer system might have a chance at becoming de facto.

## How I think it works

- When you create a *dat*, a public/private key pair is generated and the metadata of files is stored (probably hashes).
- The files are encrypted and can only be read with the public key (which is contained in the dat:// url). The private key is used for encryption or signing, dunno.
- For sharing and lookup, the public key is hashed so it's not revealed.
- Peer lookup is similar to BitTorrent, ie. DHT something something with servers to help.
- When files are changed, the metadata is updated. Only the most recent version of files is contained in a *dat*, but the history tells which files have changed. The storage requirements are thus much smaller than Git, but it's no VCS replacement.

## What's not so good yet

The technology is relatively young and that shows in some places. It's not trivial to understand what the Dat Project is about. There's only one browser for desktop---none for mobile. Everything is implemented in Node.js which is probably not optimal for RAM and CPU usage and perhaps bug prevalence.

On the other hand, the future looks very promising. Given a good technology, it's not difficult to write better documentation and implementations. And there are some very nice features coming down the line, like distributed editing of content. This might be good.
