+++
title = "Announcing twinwiki"
date = 2020-07-06
tags = ["Gemini", "twinwiki", "Rust"]
+++

Last night I published a piece of software I've been working on for some weeks now, [twinwiki](https://sr.ht/~dancek/twinwiki/). Twinwiki is a Gemini wiki edited with sed commands. Wait, what?

## Gemini

[Gemini](https://gemini.circumlunar.space/) is a new (2019) protocol that takes the best parts of Gopher and adds modern things like TLS and UTF-8. It comes with a text/gemini document type that's basically much simpler than markdown, yet enough for working hypertext.

I discovered Gemini in May and have been quite enthusiastic about it ever since. Coming from the web, the Gemini ecosystem is a paradise. Everything is still new, the tools are easy to understand and to hack on, the community is active and the content personal and down-to-earth. No content marketing, spam, JS bloat and all that.

A couple of days after hearing about Gemini I set up [my own Gemini space](gemini://hannuhartikainen.fi/). I now have 7 posts and some other content over there, and there will be more. I'm trying to keep this website more polished and the gemini content can be raw, personal and unprofessional. Like social media without the social! Anyway, I won't crosspost. If you want to see the other side, get a Gemini client like [AV-98](https://tildegit.org/solderpunk/AV-98) (python CLI) or [deedum](https://play.google.com/store/apps/details?id=ca.snoe.deedum) (Android, upcoming iOS).

## twinwiki

So, Gemini has a very simple way of posting data to servers: the `10` status code asks for a line of user input, and the input is then submitted as query string. I figured out that `sed` is probably the only noninteractive stateless text editor that people are somewhat familiar with, and decided it would make for a good wiki.

I wrote a pure Rust CGI app (since some Gemini servers support CGI) with an embedded database. Basic wiki functionality is there: creating pages, editing, history, reverting etc. The custom sed parser only handles line/range addresses and commands a,c,d,i,s for now, but I'm quite happy with it.

Twinwiki is the first Gemini native wiki (to my knowledge). There was Alex Schroeder's [Gemini Wiki](https://oddmuse.org/wiki/Gemini_Wiki) before, but it uses a separate protocol for editing. It must be a better wiki and easier to edit, but it's not as hacky. :)

## Rust

As an aside, now that I've written an actual project in Rust I feel I'm getting the hang of it. It's definitely one of my favorite languages now.
